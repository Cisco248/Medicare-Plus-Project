from datetime import datetime
from typing import Optional
from pydantic import BaseModel, Field, field_validator


class Request(BaseModel):
    question: str = Field(min_length=1, max_length=4000)


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

    start: datetime
    end: datetime
    timezone_offset: Optional[str] = None


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

    user_id: Optional[str] = None
    period: SummaryPeriod
    activities: HealthActivities
