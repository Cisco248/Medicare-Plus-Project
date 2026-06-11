from sqlalchemy.orm import Session
from data.models.har_data_model import HARDataModel
from fastapi import APIRouter, HTTPException, Depends
from data.schemas.har_data_schema import HARDataScheme
from core.utils.dbConnection import get_db
from core.utils.uuid import short_uuid

router = APIRouter()


@router.post("/insert-data", status_code=200)
def AddData(schema: HARDataScheme, db: Session = Depends(get_db)):
    if schema.x is None or schema.y is None or schema.z is None:
        raise HTTPException(status_code=400, detail="Invalid sensor data")

    response = HARDataModel(
        id=str(short_uuid()),
        timestamp=schema.timestamp,
        x=schema.x,
        y=schema.y,
        z=schema.z,
    )

    db.add(response)
    db.commit()
    db.refresh(response)
    return response


@router.get("/get-data", status_code=200)
def GetData(db: Session = Depends(get_db)):
    response = db.query(HARDataModel).all()
    if not response:
        raise HTTPException(status_code=404, detail="Data Not Found!")
    return response
