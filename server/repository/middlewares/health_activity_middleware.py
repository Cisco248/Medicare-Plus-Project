from __future__ import annotations

import json
import logging
import uuid
from datetime import date, datetime, time, timedelta, timezone
from statistics import mean
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

from fastapi import HTTPException
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from data.models.health_activity_model import (
    HealthActivityDailySummaryModel,
    HealthActivityRecordModel,
)
from data.models.prediction_model import RagDocumentModel
from data.models.user_data_model import UserModel
from data.schemas.health_activity_schema import (
    ALLOWED_METRICS,
    DailySummaryOut,
    HealthActivityIngestRequest,
    HealthActivityIngestResponse,
    HealthActivityRecordOut,
    HealthTrendsOut,
    TrendPointOut,
    WeeklyOverviewOut,
)

logger = logging.getLogger(__name__)

SUM_METRICS = {"steps", "distance", "active_calories", "total_calories", "sleep_minutes", "active_minutes"}
AVG_METRICS = {"heart_rate", "resting_heart_rate", "blood_glucose", "oxygen_saturation", "body_temperature"}
LATEST_METRICS = {"weight", "height"}


def _as_utc(value: datetime) -> datetime:
    if value.tzinfo is None:
        return value.replace(tzinfo=timezone.utc)
    return value.astimezone(timezone.utc)


def _zone(name: str) -> ZoneInfo:
    try:
        return ZoneInfo(name)
    except ZoneInfoNotFoundError:
        return ZoneInfo("UTC")


def _day_bounds(day: date, tz_name: str) -> tuple[datetime, datetime]:
    zone = _zone(tz_name)
    start = datetime.combine(day, time.min, tzinfo=zone).astimezone(timezone.utc)
    end = datetime.combine(day + timedelta(days=1), time.min, tzinfo=zone).astimezone(
        timezone.utc
    )
    return start, end


def _validate_record(metric: str, value: float, unit: str | None) -> tuple[str, float, str]:
    spec = ALLOWED_METRICS.get(metric)
    if spec is None:
        raise HTTPException(status_code=422, detail=f"Unsupported metric_type: {metric}")
    expected_unit, minimum, maximum = spec
    if metric == "height" and unit in {"m", "meters", "metre", "metres"}:
        value = value * 100
        unit = "cm"
    if unit and unit != expected_unit and metric != "height":
        raise HTTPException(
            status_code=422,
            detail=f"Unexpected unit '{unit}' for {metric}; expected {expected_unit}.",
        )
    if value < minimum or value > maximum:
        raise HTTPException(
            status_code=422,
            detail=f"{metric} value {value} is outside the accepted range.",
        )
    return metric, value, expected_unit


class HealthActivityMiddleware:
    @staticmethod
    def ingest(
        db: Session,
        user: UserModel,
        payload: HealthActivityIngestRequest,
    ) -> HealthActivityIngestResponse:
        if payload.patient_id and payload.patient_id != user.id:
            raise HTTPException(
                status_code=403,
                detail="You are not allowed to submit health data for another patient.",
            )

        accepted = 0
        duplicates = 0
        rejected = 0
        results: list[HealthActivityRecordOut] = []

        for item in payload.records:
            try:
                metric, value, unit = _validate_record(
                    item.metric_type, item.value, item.unit
                )
            except HTTPException as error:
                logger.info("Rejected HAR metric: %s", error.detail)
                rejected += 1
                continue

            recorded_at = _as_utc(item.recorded_at).replace(tzinfo=None)
            external_id = (item.external_record_id or "").strip()
            existing = (
                db.query(HealthActivityRecordModel)
                .filter(
                    HealthActivityRecordModel.user_id == user.id,
                    HealthActivityRecordModel.metric_type == metric,
                    HealthActivityRecordModel.recorded_at == recorded_at,
                    HealthActivityRecordModel.source == item.source,
                    HealthActivityRecordModel.external_record_id == external_id,
                )
                .first()
            )
            if existing:
                duplicates += 1
                results.append(
                    HealthActivityRecordOut(
                        id=existing.id,
                        metric_type=existing.metric_type,
                        value=existing.value,
                        unit=existing.unit,
                        recorded_at=existing.recorded_at,
                        source=existing.source,
                        created=False,
                    )
                )
                continue

            record = HealthActivityRecordModel(
                id=str(uuid.uuid4()),
                user_id=str(user.id),
                metric_type=metric,
                value=value,
                unit=unit,
                recorded_at=recorded_at,
                source=item.source,
                device_id=item.device_id,
                external_record_id=external_id,
                created_at=datetime.utcnow(),
            )
            try:
                with db.begin_nested():
                    db.add(record)
                    db.flush()
            except IntegrityError:
                duplicates += 1
                continue
            accepted += 1
            results.append(
                HealthActivityRecordOut(
                    id=record.id,
                    metric_type=metric,
                    value=value,
                    unit=unit,
                    recorded_at=recorded_at,
                    source=item.source,
                    created=True,
                )
            )

        db.commit()
        logger.info(
            "HAR ingest user=%s date=%s accepted=%s duplicates=%s rejected=%s",
            user.id,
            payload.date.isoformat(),
            accepted,
            duplicates,
            rejected,
        )
        summary = HealthActivityMiddleware.aggregate_day(
            db, user, payload.date, payload.timezone
        )
        return HealthActivityIngestResponse(
            status="accepted",
            processing=False,
            summary_id=summary.id if summary else None,
            accepted=accepted,
            duplicates=duplicates,
            rejected=rejected,
            records=results,
        )

    @staticmethod
    def aggregate_day(
        db: Session,
        user: UserModel,
        day: date,
        tz_name: str,
    ) -> HealthActivityDailySummaryModel | None:
        start, end = _day_bounds(day, tz_name)
        rows = (
            db.query(HealthActivityRecordModel)
            .filter(
                HealthActivityRecordModel.user_id == user.id,
                HealthActivityRecordModel.recorded_at >= start.replace(tzinfo=None),
                HealthActivityRecordModel.recorded_at < end.replace(tzinfo=None),
            )
            .all()
        )
        if not rows:
            return (
                db.query(HealthActivityDailySummaryModel)
                .filter(
                    HealthActivityDailySummaryModel.user_id == user.id,
                    HealthActivityDailySummaryModel.summary_date == day,
                )
                .first()
            )

        grouped: dict[str, list[HealthActivityRecordModel]] = {}
        for row in rows:
            grouped.setdefault(row.metric_type, []).append(row)

        values: dict[str, float | int | None] = {}
        for metric, items in grouped.items():
            numbers = [item.value for item in items]
            if metric in SUM_METRICS:
                values[metric] = sum(numbers)
            elif metric in AVG_METRICS:
                values[metric] = mean(numbers)
            elif metric in LATEST_METRICS:
                latest = max(items, key=lambda item: item.recorded_at)
                values[metric] = latest.value
            elif metric == "blood_pressure_systolic":
                values[metric] = numbers[-1]
            elif metric == "blood_pressure_diastolic":
                values[metric] = numbers[-1]

        heart = grouped.get("heart_rate") or []
        anomalies = HealthActivityMiddleware._detect_anomalies(values, heart)

        summary = (
            db.query(HealthActivityDailySummaryModel)
            .filter(
                HealthActivityDailySummaryModel.user_id == user.id,
                HealthActivityDailySummaryModel.summary_date == day,
            )
            .first()
        )
        now = datetime.utcnow()
        if summary is None:
            summary = HealthActivityDailySummaryModel(
                id=str(uuid.uuid4()),
                user_id=str(user.id),
                summary_date=day,
                created_at=now,
            )
            db.add(summary)

        summary.timezone = tz_name
        summary.steps = int(values["steps"]) if values.get("steps") is not None else None
        summary.distance_meters = values.get("distance")
        summary.active_calories = values.get("active_calories")
        summary.total_calories = values.get("total_calories")
        summary.average_heart_rate = values.get("heart_rate")
        summary.min_heart_rate = min((item.value for item in heart), default=None)
        summary.max_heart_rate = max((item.value for item in heart), default=None)
        summary.resting_heart_rate = values.get("resting_heart_rate")
        summary.sleep_minutes = (
            int(values["sleep_minutes"]) if values.get("sleep_minutes") is not None else None
        )
        summary.activity_minutes = (
            int(values["active_minutes"]) if values.get("active_minutes") is not None else None
        )
        summary.systolic_mm_hg = values.get("blood_pressure_systolic")
        summary.diastolic_mm_hg = values.get("blood_pressure_diastolic")
        summary.blood_glucose_mmol = values.get("blood_glucose")
        summary.oxygen_saturation_percent = values.get("oxygen_saturation")
        summary.temperature_celsius = values.get("body_temperature")
        summary.weight_kg = values.get("weight")
        summary.height_cm = values.get("height")
        summary.anomalies_json = json.dumps(anomalies)
        summary.updated_at = now
        db.commit()
        db.refresh(summary)

        HealthActivityMiddleware._persist_rag_document(db, user, summary)
        return summary

    @staticmethod
    def _detect_anomalies(
        values: dict[str, float | int | None],
        heart: list[HealthActivityRecordModel],
    ) -> list[str]:
        findings: list[str] = []
        systolic = values.get("blood_pressure_systolic")
        diastolic = values.get("blood_pressure_diastolic")
        if systolic is not None and systolic >= 140:
            findings.append("Elevated systolic blood pressure reading")
        if diastolic is not None and diastolic >= 90:
            findings.append("Elevated diastolic blood pressure reading")
        glucose = values.get("blood_glucose")
        if glucose is not None and glucose >= 11.1:
            findings.append("Elevated blood glucose reading")
        spo2 = values.get("oxygen_saturation")
        if spo2 is not None and spo2 < 92:
            findings.append("Low oxygen saturation reading")
        if heart and max(item.value for item in heart) >= 150:
            findings.append("High peak heart rate during the period")
        sleep = values.get("sleep_minutes")
        if sleep is not None and sleep < 300:
            findings.append("Sleep duration below 5 hours")
        steps = values.get("steps")
        if steps is not None and steps < 2000:
            findings.append("Low recorded step count")
        return findings

    @staticmethod
    def _persist_rag_document(
        db: Session,
        user: UserModel,
        summary: HealthActivityDailySummaryModel,
    ) -> None:
        title = f"Daily health activity {summary.summary_date.isoformat()}"
        content = HealthActivityMiddleware.to_context(user, summary)
        metadata = {
            "patient_id": str(user.id),
            "document_type": "health_activity",
            "date": summary.summary_date.isoformat(),
            "source": "har",
        }
        existing = (
            db.query(RagDocumentModel)
            .filter(
                RagDocumentModel.user_id == user.id,
                RagDocumentModel.document_type == "health_activity",
                RagDocumentModel.source == "har",
                RagDocumentModel.title == title,
            )
            .first()
        )
        now = datetime.utcnow()
        if existing is None:
            existing = RagDocumentModel(
                id=str(uuid.uuid4()),
                user_id=str(user.id),
                document_type="health_activity",
                source="har",
                created_at=now,
            )
            db.add(existing)
        existing.source_date = datetime.combine(summary.summary_date, time.min)
        existing.title = title
        existing.content = content
        existing.metadata_json = json.dumps(metadata)
        existing.updated_at = now
        db.commit()

    @staticmethod
    def to_context(user: UserModel, summary: HealthActivityDailySummaryModel) -> str:
        lines = [
            f"Patient: {user.name}",
            f"Date: {summary.summary_date.isoformat()}",
        ]
        if user.age is not None:
            lines.append(f"Age: {user.age}")
        if user.height_cm is not None:
            lines.append(f"Height: {user.height_cm} cm")
        if user.weight_kg is not None:
            lines.append(f"Weight: {user.weight_kg} kg")
        mapping = (
            ("Steps", summary.steps, "count"),
            ("Distance", summary.distance_meters, "m"),
            ("Active calories", summary.active_calories, "kcal"),
            ("Total calories", summary.total_calories, "kcal"),
            ("Average heart rate", summary.average_heart_rate, "bpm"),
            ("Resting heart rate", summary.resting_heart_rate, "bpm"),
            ("Sleep", summary.sleep_minutes, "minutes"),
            ("Systolic BP", summary.systolic_mm_hg, "mmHg"),
            ("Diastolic BP", summary.diastolic_mm_hg, "mmHg"),
            ("Blood glucose", summary.blood_glucose_mmol, "mmol/L"),
            ("Oxygen saturation", summary.oxygen_saturation_percent, "%"),
        )
        for label, value, unit in mapping:
            if value is not None:
                lines.append(f"{label}: {value} {unit}")
        return "\n".join(lines)

    @staticmethod
    def get_daily(
        db: Session, user: UserModel, day: date, tz_name: str
    ) -> DailySummaryOut:
        summary = HealthActivityMiddleware.aggregate_day(db, user, day, tz_name)
        if summary is None:
            raise HTTPException(status_code=404, detail="No health activity for this date.")
        return HealthActivityMiddleware.to_daily_out(summary)

    @staticmethod
    def to_daily_out(summary: HealthActivityDailySummaryModel) -> DailySummaryOut:
        anomalies: list[str] = []
        if summary.anomalies_json:
            try:
                anomalies = json.loads(summary.anomalies_json)
            except json.JSONDecodeError:
                anomalies = []
        recommendations: list[str] = []
        if summary.recommendations_json:
            try:
                recommendations = json.loads(summary.recommendations_json)
            except json.JSONDecodeError:
                recommendations = []
        return DailySummaryOut(
            patient_id=str(summary.user_id),
            date=summary.summary_date,
            timezone=summary.timezone,
            steps=summary.steps,
            distance_meters=summary.distance_meters,
            active_calories=summary.active_calories,
            total_calories=summary.total_calories,
            average_heart_rate=summary.average_heart_rate,
            min_heart_rate=summary.min_heart_rate,
            max_heart_rate=summary.max_heart_rate,
            resting_heart_rate=summary.resting_heart_rate,
            sleep_minutes=summary.sleep_minutes,
            activity_minutes=summary.activity_minutes,
            systolic_mm_hg=summary.systolic_mm_hg,
            diastolic_mm_hg=summary.diastolic_mm_hg,
            blood_glucose_mmol=summary.blood_glucose_mmol,
            oxygen_saturation_percent=summary.oxygen_saturation_percent,
            temperature_celsius=summary.temperature_celsius,
            weight_kg=summary.weight_kg,
            height_cm=summary.height_cm,
            anomalies=anomalies,
            ai_summary=summary.ai_summary,
            recommendations=recommendations,
        )

    @staticmethod
    def trends(
        db: Session,
        user: UserModel,
        metric: str,
        days: int = 7,
    ) -> HealthTrendsOut:
        field_map = {
            "steps": ("steps", "count"),
            "distance": ("distance_meters", "meters"),
            "total_calories": ("total_calories", "kcal"),
            "active_calories": ("active_calories", "kcal"),
            "heart_rate": ("average_heart_rate", "bpm"),
            "sleep": ("sleep_minutes", "minutes"),
            "activity": ("activity_minutes", "minutes"),
            "blood_pressure": ("systolic_mm_hg", "mmHg"),
        }
        if metric not in field_map:
            raise HTTPException(status_code=422, detail="Unsupported trend metric.")
        attr, unit = field_map[metric]
        zone = _zone("UTC")
        end = datetime.now(zone).date()
        start = end - timedelta(days=days - 1)
        rows = (
            db.query(HealthActivityDailySummaryModel)
            .filter(
                HealthActivityDailySummaryModel.user_id == user.id,
                HealthActivityDailySummaryModel.summary_date >= start,
                HealthActivityDailySummaryModel.summary_date <= end,
            )
            .all()
        )
        by_date = {row.summary_date: getattr(row, attr) for row in rows}
        points = [
            TrendPointOut(date=start + timedelta(days=offset), value=by_date.get(start + timedelta(days=offset)))
            for offset in range(days)
        ]
        return HealthTrendsOut(patient_id=str(user.id), metric=metric, unit=unit, points=points)

    @staticmethod
    def weekly_overview(
        db: Session,
        user: UserModel,
        days: int = 7,
        tz_name: str = "UTC",
        end_day: date | None = None,
    ) -> WeeklyOverviewOut:
        zone = _zone(tz_name)
        end = end_day or datetime.now(zone).date()
        start = end - timedelta(days=days - 1)
        rows = (
            db.query(HealthActivityDailySummaryModel)
            .filter(
                HealthActivityDailySummaryModel.user_id == user.id,
                HealthActivityDailySummaryModel.summary_date >= start,
                HealthActivityDailySummaryModel.summary_date <= end,
            )
            .order_by(HealthActivityDailySummaryModel.summary_date.desc())
            .all()
        )
        by_date = {row.summary_date: row for row in rows}
        summaries = []
        for offset in range(days):
            day = start + timedelta(days=offset)
            row = by_date.get(day)
            if row is None:
                summaries.append(
                    DailySummaryOut(
                        patient_id=str(user.id),
                        date=day,
                        timezone=tz_name,
                    )
                )
            else:
                summaries.append(HealthActivityMiddleware.to_daily_out(row))
        return WeeklyOverviewOut(
            patient_id=str(user.id),
            start=start,
            end=end,
            days=days,
            timezone=tz_name,
            summaries=summaries,
        )
