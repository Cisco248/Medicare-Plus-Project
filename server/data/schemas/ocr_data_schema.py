from pydantic import BaseModel


class OCRDataSchema(BaseModel):
    image: str
    medicine_name: str
    generic_name: str
