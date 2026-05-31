from sqlalchemy import Column, Float, String
from data.models.base import BASE


class HARDataModel(BASE):
    __tablename__ = "har_data"

    id = Column(String(16), primary_key=True, nullable=False, index=True)
    x_axis_accelorometer = Column(Float(10), nullable=False)
    y_axis_accelorometer = Column(Float(10), nullable=False)
    z_axis_accelorometer = Column(Float(10), nullable=False)
    x_axis_gyroscopemeter = Column(Float(10), nullable=False)
    y_axis_gyroscopemeter = Column(Float(10), nullable=False)
    z_axis_gyroscopemeter = Column(Float(10), nullable=False)
