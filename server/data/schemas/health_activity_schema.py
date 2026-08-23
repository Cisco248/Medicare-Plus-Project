from datetime import date, datetime
from typing import Optional

from pydantic import AliasChoices, BaseModel, ConfigDict, Field, field_validator

ALLOWED_METRICS = {
    "steps": ("count", 0, 200_000),
    "distance": ("meters", 0, 200_000),
    "active_calories": ("kcal", 0, 20_000),
    "total_calories": ("kcal", 0, 20_000),
    "heart_rate": ("bpm", 20, 250),
    "resting_heart_rate": ("bpm", 20, 200),
    "sleep_minutes": ("minutes", 0, 1_440),
    "active_minutes": ("minutes", 0, 1_440),
    "weight": ("kg", 1, 500),
    "height": ("cm", 30, 300),
    "blood_pressure_systolic": ("mmHg", 50, 260),
    "blood_pressure_diastolic": ("mmHg", 30, 180),
    "blood_glucose": ("mmol/L", 1, 40),
    "oxygen_saturation": ("percent", 50, 100),
    "body_temperature": ("celsius", 30, 45),
}

METRIC_ALIASES = {
    "distance_meters": "distance",
    "activecalories": "active_calories",
    "totalcalories": "total_calories",
    "restingheartrate": "resting_heart_rate",
    "sleep": "sleep_minutes",
    "weight_kg": "weight",
    "height_cm": "height",
    "height_m": "height",
    "spo2": "oxygen_saturation",
    "temperature": "body_temperature",
}


class HealthActivityRecordIn(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    metric_type: str
    value: float
    unit: Optional[str] = None
    recorded_at: datetime
    source: str = "health_connect"
    device_id: Optional[str] = None
    external_record_id: Optional[str] = Field(
        default=None,
        validation_alias=AliasChoices("external_record_id", "externalRecordId", "id"),
    )

    @field_validator("metric_type")
    @classmethod
    def normalize_metric(cls, value: str) -> str:
        key = value.strip().lower().replace(" ", "_")
        return METRIC_ALIASES.get(key, key)

    @field_validator("source")
    @classmethod
    def normalize_source(cls, value: str) -> str:
        return value.strip().lower() or "health_connect"


class HealthActivityIngestRequest(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    patient_id: Optional[str] = Field(
        default=None,
        validation_alias=AliasChoices("patient_id", "patientId", "user_id", "userId"),
    )
    date: date
    timezone: str = "UTC"
    records: list[HealthActivityRecordIn] = Field(default_factory=list)


class HealthActivityRecordOut(BaseModel):
    id: str
    metric_type: str
    value: float
    unit: str
    recorded_at: datetime
    source: str
    created: bool


class HealthActivityIngestResponse(BaseModel):
    status: str
    processing: bool
    summary_id: Optional[str] = None
    accepted: int
    duplicates: int
    rejected: int
    records: list[HealthActivityRecordOut] = Field(default_factory=list)


class DailySummaryOut(BaseModel):
    patient_id: str
    date: date
    timezone: str
    steps: Optional[int] = None
    distance_meters: Optional[float] = None
    active_calories: Optional[float] = None
    total_calories: Optional[float] = None
    average_heart_rate: Optional[float] = None
    min_heart_rate: Optional[float] = None
    max_heart_rate: Optional[float] = None
    resting_heart_rate: Optional[float] = None
    sleep_minutes: Optional[int] = None
    activity_minutes: Optional[int] = None
    systolic_mm_hg: Optional[float] = None
    diastolic_mm_hg: Optional[float] = None
    blood_glucose_mmol: Optional[float] = None
    oxygen_saturation_percent: Optional[float] = None
    temperature_celsius: Optional[float] = None
    weight_kg: Optional[float] = None
    height_cm: Optional[float] = None
    anomalies: list[str] = Field(default_factory=list)
    ai_summary: Optional[str] = None
    recommendations: list[str] = Field(default_factory=list)
    disclaimer: str = (
        "AI-generated health insight. This information is intended to "
        "support monitoring and should not replace professional medical evaluation."
    )


class TrendPointOut(BaseModel):
    date: date
    value: Optional[float] = None


class HealthTrendsOut(BaseModel):
    patient_id: str
    metric: str
    unit: str
    points: list[TrendPointOut]


class PredictionEvidenceOut(BaseModel):
    statement: str
    metric_type: Optional[str] = None


class PatientPredictionOut(BaseModel):
    id: str
    prediction_type: str
    prediction: str
    risk_level: str
    prediction_score: Optional[float] = None
    model_name: str
    model_version: str
    prompt_version: Optional[str] = None
    input_window: Optional[str] = None
    generated_at: datetime
    evidence: list[PredictionEvidenceOut] = Field(default_factory=list)
    disclaimer: str = (
        "Potential risk indicator only. This is not a diagnosis and "
        "requires clinical review."
    )
