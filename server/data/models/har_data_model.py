from sqlalchemy import VARCHAR, Column, DateTime, Float
from data.models.base import BASE


class HARDataModel(BASE):
    __tablename__ = "har_data"

    id = Column(VARCHAR(36), primary_key=True, nullable=False)
    timestamp = Column(DateTime(), nullable=False, index=True)
    x = Column(Float(36), nullable=False)
    y = Column(Float(36), nullable=False)
    z = Column(Float(36), nullable=False)
