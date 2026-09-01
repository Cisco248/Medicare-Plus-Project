from datetime import datetime
from typing import Optional
from pydantic import (
    AliasChoices,
    BaseModel,
    ConfigDict,
    Field,
    field_validator,
    model_validator,
)


class Request(BaseModel):
    question: str = Field(min_length=1, max_length=4000)
    patient_context: Optional[str] = Field(default=None, max_length=4000)


class EDocRequest(BaseModel):
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
            "patient_id",
            "user_id",
            "date",
            "disease",
            "category",
            "parameter",
            "topic",
            "medical_domain",
            "model",
        }
        unknown = set(value or {}) - allowed
        if unknown:
            raise ValueError(
                f"Unsupported metadata filter fields: {', '.join(sorted(unknown))}"
            )
        return value


class SummaryPeriod(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    start: datetime
    end: datetime
    timezone_offset: Optional[str] = Field(
        default=None,
        validation_alias=AliasChoices("timezone_offset", "timezoneOffset"),
    )


class HeartRateSummary(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    average_bpm: Optional[float] = Field(
        default=None, validation_alias=AliasChoices("average_bpm", "averageBpm")
    )
    min_bpm: Optional[int] = Field(
        default=None, validation_alias=AliasChoices("min_bpm", "minBpm")
    )
    max_bpm: Optional[int] = Field(
        default=None, validation_alias=AliasChoices("max_bpm", "maxBpm")
    )
    resting_bpm: Optional[float] = Field(
        default=None, validation_alias=AliasChoices("resting_bpm", "restingBpm")
    )


class SleepSummary(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    total_minutes: int = Field(
        validation_alias=AliasChoices("total_minutes", "totalMinutes")
    )
    session_count: int = Field(
        validation_alias=AliasChoices("session_count", "sessionCount")
    )


class WorkoutSummary(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    type: str
    title: Optional[str] = None
    start_time: datetime = Field(
        validation_alias=AliasChoices("start_time", "startTime")
    )
    end_time: datetime = Field(
        validation_alias=AliasChoices("end_time", "endTime")
    )
    duration_minutes: int = Field(
        validation_alias=AliasChoices("duration_minutes", "durationMinutes")
    )


class BloodPressureSummary(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    systolic_mm_hg: float = Field(
        validation_alias=AliasChoices("systolic_mm_hg", "systolicMmHg")
    )
    diastolic_mm_hg: float = Field(
        validation_alias=AliasChoices("diastolic_mm_hg", "diastolicMmHg")
    )
    measured_at: Optional[datetime] = Field(
        default=None, validation_alias=AliasChoices("measured_at", "measuredAt")
    )


class HealthActivities(BaseModel):
    """
    Normalized health metrics collected from Google Health Connect.

    ``None`` always means "data unavailable" (missing permission or no records) and must never be interpreted as zero.
    """

    model_config = ConfigDict(populate_by_name=True)

    date: Optional[datetime] = None
    steps: Optional[int] = None
    distance_meters: Optional[float] = Field(
        default=None,
        validation_alias=AliasChoices("distance_meters", "distanceMeters"),
    )
    active_calories: Optional[float] = Field(
        default=None,
        validation_alias=AliasChoices("active_calories", "activeCalories"),
    )
    total_calories: Optional[float] = Field(
        default=None,
        validation_alias=AliasChoices("total_calories", "totalCalories"),
    )
    heart_rate: Optional[HeartRateSummary] = Field(
        default=None, validation_alias=AliasChoices("heart_rate", "heartRate")
    )
    sleep: Optional[SleepSummary] = None
    workouts: list[WorkoutSummary] = Field(default_factory=list)
    weight_kilograms: Optional[float] = Field(
        default=None,
        validation_alias=AliasChoices("weight_kilograms", "weightKilograms"),
    )
    height_meters: Optional[float] = Field(
        default=None,
        validation_alias=AliasChoices("height_meters", "heightMeters"),
    )
    blood_pressure: Optional[BloodPressureSummary] = Field(
        default=None,
        validation_alias=AliasChoices("blood_pressure", "bloodPressure"),
    )
    blood_glucose_mmol_per_liter: Optional[float] = Field(
        default=None,
        validation_alias=AliasChoices(
            "blood_glucose_mmol_per_liter", "bloodGlucoseMmolPerLiter"
        ),
    )
    oxygen_saturation_percent: Optional[float] = Field(
        default=None,
        validation_alias=AliasChoices(
            "oxygen_saturation_percent", "oxygenSaturationPercent"
        ),
    )


class HealthSummaryRequest(BaseModel):
    """Payload of ``POST /api/knowledge`` sent by the mobile client."""

    model_config = ConfigDict(populate_by_name=True)

    question: Optional[str] = Field(default=None, max_length=8000)
    user_id: Optional[str] = Field(
        default=None,
        validation_alias=AliasChoices("user_id", "userId"),
    )
    period: Optional[SummaryPeriod] = None
    activities: Optional[HealthActivities] = None
    age: Optional[int] = None
    gender: Optional[str] = None
    height_cm: Optional[float] = Field(
        default=None, validation_alias=AliasChoices("height_cm", "heightCm")
    )
    weight_kg: Optional[float] = Field(
        default=None, validation_alias=AliasChoices("weight_kg", "weightKg")
    )

    @model_validator(mode="after")
    def require_question_or_activities(self):
        if self.question and self.question.strip():
            return self
        if self.activities is not None:
            return self
        raise ValueError("Provide a generation question or recorded activity data.")


def _display(value, suffix: str = "") -> str:
    if value is None:
        return "N/A"
    return f"{value}{suffix}"


def compose_knowledge_question(payload: HealthSummaryRequest) -> str:
    """Same recorded-value block as the mobile ``generationQuestion`` helper."""
    if payload.question and payload.question.strip():
        return payload.question.strip()

    activities = payload.activities
    height = payload.height_cm
    if height is None and activities is not None and activities.height_meters:
        height = activities.height_meters * 100
    weight = payload.weight_kg
    if weight is None and activities is not None:
        weight = activities.weight_kilograms

    gender = (payload.gender or "").strip().lower()
    if gender == "male":
        gender_text = "Male"
    elif gender == "female":
        gender_text = "Female"
    elif gender:
        gender_text = payload.gender.strip()  # type: ignore[union-attr]
    else:
        gender_text = "N/A"

    heart_text = "N/A"
    if activities is not None and activities.heart_rate is not None:
        bpm = activities.heart_rate.average_bpm or activities.heart_rate.resting_bpm
        if bpm is not None:
            heart_text = f"{bpm:.0f} bpm"

    pressure_text = "N/A"
    if activities is not None and activities.blood_pressure is not None:
        pressure = activities.blood_pressure
        pressure_text = (
            f"{pressure.systolic_mm_hg:.0f} mmHg / {pressure.diastolic_mm_hg:.0f} mmHg"
        )

    sleep_text = "N/A"
    if activities is not None and activities.sleep is not None:
        sleep_text = f"{activities.sleep.total_minutes} minutes"

    return f"""
Generate a health summary for the following patient data.

Context:
You are a health assistant that generates a health summary for a patient based on their activity data.

Recorded values (input only; do not copy this list into the report):
- Age: {_display(payload.age, " years")}
- Gender: {gender_text}
- Height: {_display(height, " cm")}
- Weight: {_display(weight, " kg")}
- Blood Pressure: {pressure_text}
- Blood Sugar: {_display(None if activities is None else activities.blood_glucose_mmol_per_liter, " mmol/L")}
- Heart Rate: {heart_text}
- Sleep: {sleep_text}
- Steps: {_display(None if activities is None else activities.steps, " steps")}
- Calories: {_display(None if activities is None else activities.total_calories, " calories")}
- Distance: {_display(None if activities is None else activities.distance_meters, " meters")}
Today's Date: {datetime.now().isoformat(timespec="seconds")}

Instructions:
- Do not include a Health Summary parameter list in the answer.
- Write Status, Trend, Risk, Recommendations, and Insights only.
- Use only the recorded values above. If a field is N/A, treat it as unavailable. Do not invent measurements.
""".strip()


KNOWLEDGE_SYSTEM_TEMPLATE = """
You are a health assistant that writes an informational daily health summary.

Use only the recorded patient values in the question. If a field is N/A, treat it as unavailable.
Do not invent measurements, diagnoses, or lab results.
Do not copy the recorded values back as a Health Summary parameter list.
Use the medical knowledge context only for general interpretation of recorded values.
This is not a diagnosis and must not replace clinical review.

Write the answer in this exact order:
Status:
<one short paragraph based only on recorded values>

Trend:
<one short paragraph based only on recorded values>

Risk:
<informational risk statement, not a diagnosis>

Recommendations:
- <actionable item grounded in recorded values>
- <actionable item grounded in recorded values>

Insights:
- <brief insight grounded in recorded values>
""".strip()
