from datetime import datetime
from typing import Optional
from pydantic import AliasChoices, BaseModel, ConfigDict, Field, field_validator, model_validator


class Request(BaseModel):
    question: str = Field(min_length=1, max_length=4000)


class EDocRequest(BaseModel):
    """Payload of ``POST /api/e-doc``.

    Accepts a free-text ``question`` and/or the structured hypertension
    assessment fields the backend already sends.
    """

    question: Optional[str] = Field(default=None, max_length=4000)
    prediction: Optional[str] = None
    age: Optional[int] = None
    height: Optional[float] = None
    weight: Optional[float] = None
    bmi: Optional[float] = None
    hemoglobin_count: Optional[float] = None
    cholesterol_mgdl: Optional[float] = None
    diabetes_ordinal: Optional[str] = None
    gender: Optional[str] = None

    @model_validator(mode="after")
    def require_question_or_prediction(self):
        if self.question and self.question.strip():
            return self
        if self.prediction and str(self.prediction).strip():
            return self
        raise ValueError("Provide a question or a prediction result.")


def compose_edoc_question(payload: EDocRequest) -> str:
    """Turn an E-Doc request into a grounded retrieval question."""
    if payload.question and payload.question.strip():
        return payload.question.strip()

    lines = [
        "Explain this hypertension risk assessment for a patient using only "
        "the medical knowledge context. Do not diagnose and do not invent facts.",
        f"Predicted status: {payload.prediction}.",
    ]
    if payload.age is not None:
        lines.append(f"Age: {payload.age}.")
    if payload.gender:
        lines.append(f"Gender: {payload.gender}.")
    if payload.height is not None:
        lines.append(f"Height: {payload.height} cm.")
    if payload.weight is not None:
        lines.append(f"Weight: {payload.weight} kg.")
    if payload.bmi is not None:
        lines.append(f"BMI: {payload.bmi:.1f}.")
    if payload.hemoglobin_count is not None:
        lines.append(f"HbA1c: {payload.hemoglobin_count}%.")
    if payload.cholesterol_mgdl is not None:
        lines.append(f"Cholesterol: {payload.cholesterol_mgdl} mg/dL.")
    if payload.diabetes_ordinal:
        lines.append(f"Diabetes status: {payload.diabetes_ordinal}.")
    return " ".join(lines)


class SimilaritySearchRequest(Request):
    k: int = Field(default=3, ge=1, le=20)
    metadata_filter: dict[str, str | int | float | bool] | None = None

    @field_validator("metadata_filter")
    @classmethod
    def validate_filter_keys(cls, value):
        allowed = {
            "source",
            "page",
            "document_type",
            "type",
            "issuer",
            "hospital",
        }
        unknown = set(value or {}) - allowed
        if unknown:
            raise ValueError(
                f"Unsupported metadata filter fields: {', '.join(sorted(unknown))}"
            )
        return value


class SummaryPeriod(BaseModel):
    """Date range the health data was collected for (UTC instants)."""

    model_config = ConfigDict(populate_by_name=True)

    start: datetime
    end: datetime
    timezone_offset: Optional[str] = Field(
        default=None,
        validation_alias=AliasChoices("timezone_offset", "timezoneOffset"),
    )


class HeartRateSummary(BaseModel):
    average_bpm: Optional[float] = None
    min_bpm: Optional[int] = None
    max_bpm: Optional[int] = None
    resting_bpm: Optional[float] = None


class SleepSummary(BaseModel):
    total_minutes: int
    session_count: int


class WorkoutSummary(BaseModel):
    type: str
    title: Optional[str] = None
    start_time: datetime
    end_time: datetime
    duration_minutes: int


class BloodPressureSummary(BaseModel):
    systolic_mm_hg: float
    diastolic_mm_hg: float
    measured_at: Optional[datetime] = None


class HealthActivities(BaseModel):
    """
    Normalized health metrics collected from Google Health Connect.

    ``None`` always means "data unavailable" (missing permission or no records) and must never be interpreted as zero.
    """

    date: Optional[datetime] = None
    steps: Optional[int] = None
    distance_meters: Optional[float] = None
    active_calories: Optional[float] = None
    total_calories: Optional[float] = None
    heart_rate: Optional[HeartRateSummary] = None
    sleep: Optional[SleepSummary] = None
    workouts: list[WorkoutSummary] = Field(default_factory=list)
    weight_kilograms: Optional[float] = None
    height_meters: Optional[float] = None
    blood_pressure: Optional[BloodPressureSummary] = None
    blood_glucose_mmol_per_liter: Optional[float] = None
    oxygen_saturation_percent: Optional[float] = None


class HealthSummaryRequest(BaseModel):
    """Payload of ``POST /api/knowledge`` sent by the mobile client."""

    model_config = ConfigDict(populate_by_name=True)

    user_id: Optional[str] = Field(
        default=None,
        validation_alias=AliasChoices("user_id", "userId"),
    )
    period: SummaryPeriod
    activities: HealthActivities
