from sqlalchemy import (
    Column,
    Date,
    DateTime,
    Float,
    ForeignKey,
    Integer,
    String,
    Text,
    UniqueConstraint,
    Index,
)

from data.models.base import BASE


class HealthActivityRecordModel(BASE):
    """A single measured health metric. Raw records are never deleted by aggregation."""

    __tablename__ = "health_activity_record"
    __table_args__ = (
        UniqueConstraint(
            "user_id",
            "metric_type",
            "recorded_at",
            "source",
            "external_record_id",
            name="uq_har_record_idempotent",
        ),
        Index("ix_har_user_recorded", "user_id", "recorded_at"),
        Index("ix_har_user_metric_recorded", "user_id", "metric_type", "recorded_at"),
    )

    id = Column(String(36), primary_key=True)
    user_id = Column(String(36), ForeignKey("user.id"), nullable=False, index=True)
    metric_type = Column(String(64), nullable=False)
    value = Column(Float, nullable=False)
    unit = Column(String(32), nullable=False)
    recorded_at = Column(DateTime, nullable=False)
    source = Column(String(64), nullable=False, default="health_connect")
    device_id = Column(String(120), nullable=True)
    external_record_id = Column(String(120), nullable=False, default="")
    created_at = Column(DateTime, nullable=False)


class HealthActivityDailySummaryModel(BASE):
    """Derived 24-hour summary. Independent of the raw measurement table."""

    __tablename__ = "health_activity_daily_summary"
    __table_args__ = (
        UniqueConstraint("user_id", "summary_date", name="uq_har_daily_summary"),
        Index("ix_har_summary_user_date", "user_id", "summary_date"),
    )

    id = Column(String(36), primary_key=True)
    user_id = Column(String(36), ForeignKey("user.id"), nullable=False, index=True)
    summary_date = Column(Date, nullable=False)
    timezone = Column(String(64), nullable=False, default="UTC")
    steps = Column(Integer, nullable=True)
    distance_meters = Column(Float, nullable=True)
    active_calories = Column(Float, nullable=True)
    total_calories = Column(Float, nullable=True)
    average_heart_rate = Column(Float, nullable=True)
    min_heart_rate = Column(Float, nullable=True)
    max_heart_rate = Column(Float, nullable=True)
    resting_heart_rate = Column(Float, nullable=True)
    sleep_minutes = Column(Integer, nullable=True)
    activity_minutes = Column(Integer, nullable=True)
    systolic_mm_hg = Column(Float, nullable=True)
    diastolic_mm_hg = Column(Float, nullable=True)
    blood_glucose_mmol = Column(Float, nullable=True)
    oxygen_saturation_percent = Column(Float, nullable=True)
    temperature_celsius = Column(Float, nullable=True)
    weight_kg = Column(Float, nullable=True)
    height_cm = Column(Float, nullable=True)
    anomalies_json = Column(Text, nullable=True)
    ai_summary = Column(Text, nullable=True)
    recommendations_json = Column(Text, nullable=True)
    created_at = Column(DateTime, nullable=False)
    updated_at = Column(DateTime, nullable=False)
