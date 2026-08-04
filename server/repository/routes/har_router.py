from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends
from data import HARDataScheme
from core import get_db

har_router = APIRouter()


@har_router.post("/insert-data", status_code=200, tags=["Human Activity Recognition"])
def add_data(db_schema: HARDataScheme, db: Session = Depends(get_db)):
    pass
    # response = HARDataModel(
    #     id=str(short_uuid()),
    #     timestamp=middleware["timestamp"],
    #     x=middleware["x"],
    #     y=middleware["y"],
    #     z=middleware["z"],
    # )

    # db.add(response)
    # db.commit()
    # db.refresh(response)
    # return response


@har_router.get("/get-data", status_code=200, tags=["Human Activity Recognition"])
def get_data(db: Session = Depends(get_db)):
    pass
    # response = db.query(HARDataModel).all()
    # if not response:
    #     raise HTTPException(status_code=404, detail="Data Not Found!")
    # return response
