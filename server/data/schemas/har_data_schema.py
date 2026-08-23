from datetime import datetime
from typing import Any

from pydantic import BaseModel, Field


class HARDataScheme(BaseModel):
    timestamp: datetime
    x: float
    y: float
    z: float


class HARSensorReading(BaseModel):
    """A single accelerometer + gyroscope sample captured on-device."""

    timestamp: datetime
    acc_x: float
    acc_y: float
    acc_z: float
    gyro_x: float
    gyro_y: float
    gyro_z: float


class HARWindowScheme(BaseModel):
    """A ~3s window of sensor samples (ideally ~100Hz -> ~300 samples)
    sent from the mobile client for a single activity prediction."""

    readings: list[HARSensorReading]


class HARSensorBatchIn(BaseModel):
    samples: list[HARSensorReading] = Field(min_length=1, max_length=2000)


class HARSensorStoreResponse(BaseModel):
    accepted: int
    pruned: int
    sample_count: int
    oldest: datetime | None = None
    newest: datetime | None = None


class HARCurrentPredictionOut(BaseModel):
    activity: str
    confidence: float
    window_samples: int
    window_start: datetime | None = None
    window_end: datetime | None = None
    summary: Any | None = None
