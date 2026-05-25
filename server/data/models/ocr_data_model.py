from sqlalchemy import Column, String
from data.models.base import BASE


class OCRDataModel(BASE):
    __tablename__ = "ocr_data"
    __exist__ = True

    id = Column(String(36), primary_key=True, index=True)
    image = Column(String(200), nullable=False)
    medicine_name = Column(String(100), nullable=False)
    generic_name = Column(String(100), nullable=False)
