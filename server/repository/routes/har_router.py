from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends
from data import HARDataScheme, HARWindowScheme
from core import get_db, ServerSettings
from repository import ArtifactLoader, HARMiddleware

har_router = APIRouter()
config = ServerSettings()


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


@har_router.post("/predict", status_code=200, tags=["Human Activity Recognition"])
def predict_activity(
    window: HARWindowScheme,
    loader=ArtifactLoader(),
    middleware=HARMiddleware(),
):
    model = loader.model_loader(config.HAR_MODEL_PATH)

    features = middleware.extract_features(window.readings)
    # keep the exact column order the model was trained on
    ordered = [[features[name] for name in model.feature_names_in_]]

    pred_activity = model.predict(ordered)[0]
    proba = model.predict_proba(ordered)[0]
    confidence = float(max(proba))

    return {
        "activity": pred_activity,
        "confidence": round(confidence, 4),
        "sample_count": len(window.readings),
    }
