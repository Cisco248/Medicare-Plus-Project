from sqlalchemy import Column, DateTime, Float, Index, String

from data.models.base import BASE


class HARSensorSampleModel(BASE):
    """One paired accelerometer + gyroscope sample for a patient."""

    __tablename__ = "har_sensor_sample"
    __table_args__ = (
        Index("ix_har_sensor_user_time", "user_id", "timestamp"),
    )

    id = Column(String(36), primary_key=True, nullable=False)
    user_id = Column(String(36), nullable=False, index=True)
    timestamp = Column(DateTime(), nullable=False)
    acc_x = Column(Float, nullable=False)
    acc_y = Column(Float, nullable=False)
    acc_z = Column(Float, nullable=False)
    gyro_x = Column(Float, nullable=False)
    gyro_y = Column(Float, nullable=False)
    gyro_z = Column(Float, nullable=False)
