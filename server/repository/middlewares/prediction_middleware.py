from __future__ import annotations

import logging
import uuid
from datetime import datetime, timedelta

from sqlalchemy.orm import Session

from data.models.health_activity_model import HealthActivityDailySummaryModel
from data.models.patient_clinical_model import PatientConditionModel
from data.models.prediction_model import PatientPredictionModel, PredictionEvidenceModel
from data.models.user_data_model import UserModel
from data.schemas.health_activity_schema import (
    PatientPredictionOut,
    PredictionEvidenceOut,
)

logger = logging.getLogger(__name__)

MODEL_NAME = "medicare-plus-risk-rules"
MODEL_VERSION = "1.0.0"
PROMPT_VERSION = "risk-rules-v1"
INPUT_WINDOW = "7d"


class PredictionMiddleware:
    """Explainable rule-based risk indicators. Not a medical diagnosis."""

    @staticmethod
    def generate(db: Session, user: UserModel) -> PatientPredictionOut:
        window_start = datetime.utcnow() - timedelta(days=7)
        summaries = (
            db.query(HealthActivityDailySummaryModel)
            .filter(
                HealthActivityDailySummaryModel.user_id == user.id,
                HealthActivityDailySummaryModel.summary_date
                >= window_start.date(),
            )
            .all()
        )
        conditions = (
            db.query(PatientConditionModel)
            .filter(PatientConditionModel.user_id == user.id)
            .all()
        )
        condition_codes = {item.code for item in conditions}

        evidence: list[tuple[str, str | None]] = []
        score = 0.0

        if user.age is not None and user.age >= 60:
            evidence.append((f"Age {user.age} is associated with higher cardiometabolic risk", "age"))
            score += 0.1

        bmi = PredictionMiddleware._bmi(user)
        if bmi is not None and bmi >= 30:
            evidence.append((f"BMI {bmi:.1f} is in the obesity range", "bmi"))
            score += 0.15

        if "hypertension" in condition_codes:
            evidence.append(("Existing recorded condition: hypertension", "ncd"))
            score += 0.2
        if "diabetes" in condition_codes:
            evidence.append(("Existing recorded condition: diabetes", "ncd"))
            score += 0.2

        if summaries:
            avg_steps = PredictionMiddleware._avg(summaries, "steps")
            if avg_steps is not None and avg_steps < 4000:
                evidence.append(
                    (f"7-day average steps ({avg_steps:.0f}) are below a typical activity range", "steps")
                )
                score += 0.1
            avg_sleep = PredictionMiddleware._avg(summaries, "sleep_minutes")
            if avg_sleep is not None and avg_sleep < 360:
                evidence.append(
                    (f"7-day average sleep ({avg_sleep / 60:.1f} h) is below 6 hours", "sleep")
                )
                score += 0.1
            avg_sys = PredictionMiddleware._avg(summaries, "systolic_mm_hg")
            if avg_sys is not None and avg_sys >= 135:
                evidence.append(
                    (f"Recent average systolic blood pressure is {avg_sys:.0f} mmHg", "blood_pressure")
                )
                score += 0.15
            avg_resting = PredictionMiddleware._avg(summaries, "resting_heart_rate")
            if avg_resting is not None and avg_resting >= 85:
                evidence.append(
                    (f"Recent average resting heart rate is {avg_resting:.0f} bpm", "heart_rate")
                )
                score += 0.1
            avg_glucose = PredictionMiddleware._avg(summaries, "blood_glucose_mmol")
            if avg_glucose is not None and avg_glucose >= 7.0:
                evidence.append(
                    (f"Recent average blood glucose is {avg_glucose:.1f} mmol/L", "blood_glucose")
                )
                score += 0.15

        score = min(score, 0.95)
        if score >= 0.55:
            risk = "high"
            statement = (
                "Potential elevated cardiometabolic risk based on recorded "
                "trends and existing conditions. Requires clinical review."
            )
        elif score >= 0.25:
            risk = "moderate"
            statement = (
                "Potential moderate risk indicators are present in the recent "
                "health record. Monitor and discuss with a clinician if they persist."
            )
        else:
            risk = "low"
            statement = (
                "Recorded measurements do not currently indicate a high-risk "
                "pattern. Continue routine monitoring."
            )
        if not evidence:
            evidence.append(("Insufficient recent measurements to raise a specific risk flag", None))

        prediction = PatientPredictionModel(
            id=str(uuid.uuid4()),
            user_id=str(user.id),
            prediction_type="cardiometabolic_risk",
            prediction=statement,
            risk_level=risk,
            prediction_score=round(score, 3),
            model_name=MODEL_NAME,
            model_version=MODEL_VERSION,
            prompt_version=PROMPT_VERSION,
            input_window=INPUT_WINDOW,
            generated_at=datetime.utcnow(),
            expires_at=datetime.utcnow() + timedelta(days=7),
        )
        db.add(prediction)
        db.flush()
        for statement_text, metric in evidence:
            db.add(
                PredictionEvidenceModel(
                    id=str(uuid.uuid4()),
                    prediction_id=prediction.id,
                    statement=statement_text,
                    metric_type=metric,
                    created_at=datetime.utcnow(),
                )
            )
        db.commit()
        logger.info(
            "Prediction stored user=%s type=%s risk=%s model=%s/%s",
            user.id,
            prediction.prediction_type,
            risk,
            MODEL_NAME,
            MODEL_VERSION,
        )
        return PredictionMiddleware.to_out(db, prediction)

    @staticmethod
    def latest(db: Session, user: UserModel) -> list[PatientPredictionOut]:
        rows = (
            db.query(PatientPredictionModel)
            .filter(PatientPredictionModel.user_id == user.id)
            .order_by(PatientPredictionModel.generated_at.desc())
            .limit(10)
            .all()
        )
        return [PredictionMiddleware.to_out(db, row) for row in rows]

    @staticmethod
    def to_out(db: Session, prediction: PatientPredictionModel) -> PatientPredictionOut:
        evidence_rows = (
            db.query(PredictionEvidenceModel)
            .filter(PredictionEvidenceModel.prediction_id == prediction.id)
            .all()
        )
        return PatientPredictionOut(
            id=prediction.id,
            prediction_type=prediction.prediction_type,
            prediction=prediction.prediction,
            risk_level=prediction.risk_level,
            prediction_score=prediction.prediction_score,
            model_name=prediction.model_name,
            model_version=prediction.model_version,
            prompt_version=prediction.prompt_version,
            input_window=prediction.input_window,
            generated_at=prediction.generated_at,
            evidence=[
                PredictionEvidenceOut(statement=item.statement, metric_type=item.metric_type)
                for item in evidence_rows
            ],
        )

    @staticmethod
    def _bmi(user: UserModel) -> float | None:
        if user.height_cm is None or user.weight_kg is None:
            return None
        if user.height_cm <= 0:
            return None
        metres = user.height_cm / 100
        return user.weight_kg / (metres * metres)

    @staticmethod
    def _avg(rows: list[HealthActivityDailySummaryModel], attr: str) -> float | None:
        values = [getattr(row, attr) for row in rows if getattr(row, attr) is not None]
        if not values:
            return None
        return sum(values) / len(values)
