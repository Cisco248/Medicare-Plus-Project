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
    """Optional client-supplied window for POST /api-har/predict.

    Production prediction uses stored samples from the previous 6 hours and
    then scores the latest short burst. This schema is for authenticated
    testing of a prepared window.
    """

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
    lookback_hours: int = 6
    history_samples: int = 0
    history_start: datetime | None = None
    history_end: datetime | None = None
    summary: Any | None = None


class HARSixHourWindowOut(BaseModel):
    lookback_hours: int
    history_samples: int
    history_start: datetime | None = None
    history_end: datetime | None = None
    inference_samples: int
    inference_start: datetime | None = None
    inference_end: datetime | None = None
    ready: bool
