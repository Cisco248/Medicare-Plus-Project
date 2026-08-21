from datetime import datetime
from pydantic import BaseModel


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
