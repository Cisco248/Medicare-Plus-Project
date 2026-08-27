from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from core import ServerSettings, get_db
from data import HARWindowScheme
from data.models.user_data_model import UserModel
from data.schemas.har_data_schema import (
    HARCurrentPredictionOut,
    HARSensorBatchIn,
    HARSensorStoreResponse,
)
from repository.middlewares import ArtifactLoader, HARMiddleware, RagClientMiddleware
from repository.middlewares.auth_middleware import get_current_user

har_router = APIRouter()
config = ServerSettings()


def _compose_har_questions(activity: str, confidence: Any) -> str:
    return f"""
        Explain this Human Activity Recognition for patient activity summarizations only the medical knowledge context.

        Do not diagnose and Do not invent facts.

        Activity Category: {activity}
        Confidence Value: {confidence}
    """


def _load_har_model():
    try:
        return ArtifactLoader().model_loader(config.HAR_MODEL_PATH)
    except Exception as exc:
        raise HTTPException(
            status_code=503,
            detail="The human activity model is not available on the server.",
        ) from exc


def _predict_from_readings(readings: list, model) -> tuple[str, float, dict]:
    middleware = HARMiddleware()
    try:
        features = middleware.extract_features(readings)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    names = getattr(model, "feature_names_in_", None)
    ordered = (
        [[features[name] for name in names]]
        if names is not None
        else [list(features.values())]
    )
    pred_activity = str(model.predict(ordered)[0])
    proba = model.predict_proba(ordered)[0]
    confidence = float(max(proba))
    return pred_activity, confidence, features


async def _optional_har_summary(activity: str, confidence: float) -> Any | None:
    try:
        response = await RagClientMiddleware(
            url=f"{config.rag_url}/api/har-summary",
            data={"question": _compose_har_questions(activity, confidence)},
        ).build()
        response.raise_for_status()
        return response.json()
    except Exception:
        return None


@har_router.post("/samples", status_code=200, tags=["Human Activity Recognition"])
def store_sensor_samples(
    payload: HARSensorBatchIn,
    db: Session = Depends(get_db),
    user: UserModel = Depends(get_current_user),
) -> HARSensorStoreResponse:
    return HARMiddleware.store_samples(db, str(user.id), payload.samples)


@har_router.get("/samples", status_code=200, tags=["Human Activity Recognition"])
def list_sensor_samples(
    limit: int = Query(default=200, ge=1, le=2000),
    db: Session = Depends(get_db),
    user: UserModel = Depends(get_current_user),
):
    stats = HARMiddleware.sample_stats(db, str(user.id))
    rows = HARMiddleware.list_recent(db, str(user.id), limit)
    return {
        "sample_count": stats.sample_count,
        "oldest": stats.oldest,
        "newest": stats.newest,
        "samples": [
            {
                "timestamp": row.timestamp,
                "acc_x": row.acc_x,
                "acc_y": row.acc_y,
                "acc_z": row.acc_z,
                "gyro_x": row.gyro_x,
                "gyro_y": row.gyro_y,
                "gyro_z": row.gyro_z,
            }
            for row in rows
        ],
    }


@har_router.post(
    "/predict-current",
    status_code=200,
    tags=["Human Activity Recognition"],
    response_model=HARCurrentPredictionOut,
)
async def predict_current_window(
    db: Session = Depends(get_db),
    user: UserModel = Depends(get_current_user),
) -> HARCurrentPredictionOut:
    window = HARMiddleware.current_window(db, str(user.id))
    if len(window) < HARMiddleware.MIN_WINDOW_SIZE:
        raise HTTPException(
            status_code=400,
            detail=(
                "Not enough recent motion samples for a window. "
                f"Need at least {HARMiddleware.MIN_WINDOW_SIZE}."
            ),
        )
    model = _load_har_model()
    activity, confidence, _features = _predict_from_readings(window, model)
    summary = await _optional_har_summary(activity, confidence)
    return HARCurrentPredictionOut(
        activity=activity,
        confidence=round(confidence, 4),
        window_samples=len(window),
        window_start=window[0].timestamp,
        window_end=window[-1].timestamp,
        summary=summary,
    )


@har_router.post("/predict", status_code=200, tags=["Human Activity Recognition"])
async def predict_activity(window: HARWindowScheme):
    model = _load_har_model()
    activity, confidence, _features = _predict_from_readings(window.readings, model)
    summary = await _optional_har_summary(activity, confidence)
    return {
        "activity": activity,
        "confidence": round(confidence, 4),
        "window_samples": len(window.readings),
        "summary": summary,
    }
