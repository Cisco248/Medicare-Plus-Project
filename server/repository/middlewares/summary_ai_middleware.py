from __future__ import annotations

import json
import logging
from datetime import date

from sqlalchemy.orm import Session

from core import DBConnection, ServerSettings
from data.models.health_activity_model import HealthActivityDailySummaryModel
from data.models.patient_clinical_model import PatientConditionModel, PatientMedicationModel
from data.models.prediction_model import RagDocumentModel
from data.models.user_data_model import UserModel
from repository.middlewares.health_activity_middleware import HealthActivityMiddleware
from repository.middlewares.prediction_middleware import PredictionMiddleware

logger = logging.getLogger(__name__)
setting = ServerSettings()


class SummaryAIMiddleware:
    @staticmethod
    def enrich(user_id: str, day: date, timezone_name: str) -> None:
        db: Session = DBConnection.SESSION_LOACAL()
        try:
            user = db.query(UserModel).filter(UserModel.id == user_id).first()
            if user is None:
                return
            summary = HealthActivityMiddleware.aggregate_day(db, user, day, timezone_name)
            if summary is None:
                return
            context = SummaryAIMiddleware._patient_context(db, user, day)
            question = (
                "You are given one patient's own recorded health data only. "
                "Do not invent measurements. Do not diagnose. "
                "Write a short informational daily health insight and a "
                "'Recommendations:' section.\n\n"
                f"{context}"
            )
            url = f"{setting.rag_url}/api/knowledge"
            payload = {
                "userId": user_id,
                "period": {
                    "start": f"{day.isoformat()}T00:00:00Z",
                    "end": f"{day.isoformat()}T23:59:59Z",
                    "timezoneOffset": timezone_name,
                },
                "activities": SummaryAIMiddleware._activities(summary),
            }
            try:
                import httpx

                response = httpx.post(url, json=payload, timeout=30.0)
                if response.status_code >= 400:
                    logger.warning(
                        "RAG daily summary failed user=%s status=%s",
                        user_id,
                        response.status_code,
                    )
                    return
                body = response.json()
                summary.ai_summary = body.get("summary")
                recommendations = body.get("recommendations") or []
                summary.recommendations_json = json.dumps(recommendations)
                db.commit()
            except Exception:
                logger.exception("RAG daily summary enrichment failed user=%s", user_id)
        finally:
            db.close()

    @staticmethod
    def generate_detached(user_id: str) -> None:
        db: Session = DBConnection.SESSION_LOACAL()
        try:
            user = db.query(UserModel).filter(UserModel.id == user_id).first()
            if user is None:
                return
            PredictionMiddleware.generate(db, user)
        except Exception:
            logger.exception("Background prediction failed user=%s", user_id)
        finally:
            db.close()

    @staticmethod
    def _patient_context(db: Session, user: UserModel, day: date) -> str:
        conditions = (
            db.query(PatientConditionModel)
            .filter(PatientConditionModel.user_id == user.id)
            .all()
        )
        medications = (
            db.query(PatientMedicationModel)
            .filter(PatientMedicationModel.user_id == user.id)
            .all()
        )
        documents = (
            db.query(RagDocumentModel)
            .filter(RagDocumentModel.user_id == user.id)
            .order_by(RagDocumentModel.updated_at.desc())
            .limit(5)
            .all()
        )
        lines = [f"Patient profile for {user.name} (id scoped: {user.id})"]
        if user.age is not None:
            lines.append(f"Age: {user.age}")
        if conditions:
            lines.append(
                "Recorded conditions: "
                + ", ".join(f"{item.label} ({item.code})" for item in conditions)
            )
        if medications:
            lines.append(
                "Medications: " + ", ".join(item.name for item in medications)
            )
        for document in documents:
            if document.source_date and document.source_date.date() == day:
                lines.append(document.content)
        return "\n".join(lines)

    @staticmethod
    def _activities(summary: HealthActivityDailySummaryModel) -> dict:
        activities: dict = {"date": f"{summary.summary_date.isoformat()}T00:00:00Z"}
        if summary.steps is not None:
            activities["steps"] = summary.steps
        if summary.distance_meters is not None:
            activities["distance_meters"] = summary.distance_meters
        if summary.active_calories is not None:
            activities["active_calories"] = summary.active_calories
        if summary.total_calories is not None:
            activities["total_calories"] = summary.total_calories
        if summary.average_heart_rate is not None:
            activities["heart_rate"] = {
                "average_bpm": summary.average_heart_rate,
                "min_bpm": int(summary.min_heart_rate) if summary.min_heart_rate else None,
                "max_bpm": int(summary.max_heart_rate) if summary.max_heart_rate else None,
                "resting_bpm": summary.resting_heart_rate,
            }
        if summary.sleep_minutes is not None:
            activities["sleep"] = {
                "total_minutes": summary.sleep_minutes,
                "session_count": 1,
            }
        if summary.weight_kg is not None:
            activities["weight_kilograms"] = summary.weight_kg
        if summary.height_cm is not None:
            activities["height_meters"] = summary.height_cm / 100
        if summary.systolic_mm_hg is not None and summary.diastolic_mm_hg is not None:
            activities["blood_pressure"] = {
                "systolic_mm_hg": summary.systolic_mm_hg,
                "diastolic_mm_hg": summary.diastolic_mm_hg,
            }
        if summary.blood_glucose_mmol is not None:
            activities["blood_glucose_mmol_per_liter"] = summary.blood_glucose_mmol
        if summary.oxygen_saturation_percent is not None:
            activities["oxygen_saturation_percent"] = summary.oxygen_saturation_percent
        return activities
