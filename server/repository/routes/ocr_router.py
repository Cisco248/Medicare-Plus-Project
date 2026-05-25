import uuid
from sqlalchemy.orm import Session
from core.constants.config import DB_URL
from data.models.ocr_data_model import OCRDataModel
from fastapi import APIRouter, HTTPException, Depends
from core.utils.dbConnection import DatabaseConnection
from data.schemas.ocr_data_schema import OCRDataSchema

router = APIRouter()
db = DatabaseConnection(DB_URL)
db.init_db()


@router.post("/insert-data", status_code=200)
def AddData(schema: OCRDataSchema, db: Session = Depends(db.get_db)):
    data = db.query(OCRDataModel).filter(OCRDataModel.image == schema.image).all()
    if data:
        raise HTTPException(status_code=400, detail="Image Already Added!")

    if not schema.medicine_name and schema.generic_name:
        raise HTTPException(
            status_code=400,
            detail=f"Medicine Name: {schema.medicine_name} | Generic Name: {schema.generic_name}",
        )

    response = OCRDataModel(
        id=str(uuid.uuid4()),
        image=schema.image,
        medicine_name=schema.medicine_name,
        generic_name=schema.generic_name,
    )

    db.add(response)
    db.commit()
    db.refresh(response)
    return response


@router.get("/get-data", status_code=200)
def GetData(db: Session = Depends(db.get_db)):
    response = db.query(OCRDataModel).all()
    if not response:
        raise HTTPException(status_code=404, detail="Data Not Found!")
    return response
