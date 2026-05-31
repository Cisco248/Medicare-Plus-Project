import uuid
from sqlalchemy.orm import Session
from data.models.har_data_model import HARDataModel
from fastapi import APIRouter, HTTPException, Depends
from data.schemas.har_data_schema import HARDataScheme
from core.utils.dbConnection import get_db

router = APIRouter()


@router.post("/insert-data", status_code=200)
def AddData(schema: HARDataScheme, db: Session = Depends(get_db)):
    data = db.query(HARDataModel).all()
    if data:
        raise HTTPException(status_code=400, detail="Image Already Added!")

    response = HARDataModel(
        id=str(uuid.uuid4()),
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
