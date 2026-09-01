import threading
from pathlib import Path
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from core import ServerSettings, get_db
from core.configs.server_configuration import BASE_DIR
from data import HARWindowScheme
from data.models.user_data_model import UserModel
from data.schemas.har_data_schema import (
    HARCurrentPredictionOut,
    HARSensorBatchIn,
    HARSensorStoreResponse,
    HARSixHourWindowOut,
)
from repository.middlewares import ArtifactLoader, HARMiddleware, RagClientMiddleware
from repository.middlewares.auth_middleware import get_current_user

har_router = APIRouter()
config = ServerSettings()

_har_model = None
_har_model_lock = threading.Lock()


def _compose_har_questions(activity: str, confidence: Any) -> str:
    return f"""
        Explain this Human Activity Recognition for patient activity summarizations only the medical knowledge context.

        Do not diagnose and Do not invent facts.

        Activity Category: {activity}
        Confidence Value: {confidence}
    """


def _load_har_model():
    global _har_model
    if _har_model is not None:
        return _har_model
    with _har_model_lock:
        if _har_model is not None:
            return _har_model
        path = ArtifactLoader.resolve(
            config.HAR_MODEL_PATH,
            str(BASE_DIR / "artifacts" / "har" / "model.pkl"),
            str(BASE_DIR / "artifact" / "har" / "model.pkl"),
        )
        if not path or not Path(path).exists():
            raise HTTPException(
                status_code=503,
                detail="The human activity model is not available on the server.",
            )
        try:
            _har_model = ArtifactLoader().model_loader(path)
        except Exception as exc:
            raise HTTPException(
                status_code=503,
                detail="The human activity model is not available on the server.",
            ) from exc
        return _har_model


def _predict_from_readings(readings: list, model) -> tuple[str, float, dict]:
    try:
        return HARMiddleware().predict(readings, model)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except RuntimeError as exc:
        raise HTTPException(status_code=503, detail=str(exc)) from exc


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


@har_router.get(
    "/window",
    status_code=200,
    tags=["Human Activity Recognition"],
    response_model=HARSixHourWindowOut,
)
def get_six_hour_window(
    db: Session = Depends(get_db),
    user: UserModel = Depends(get_current_user),
) -> HARSixHourWindowOut:
    history = HARMiddleware.get_sensor_data_for_last_six_hours(db, str(user.id))
    window = HARMiddleware.inference_window(history)
    return HARSixHourWindowOut(**HARMiddleware.describe_window(history, window))


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
    history = HARMiddleware.get_sensor_data_for_last_six_hours(db, str(user.id))
    if not history:
        raise HTTPException(
            status_code=400,
            detail="No motion samples were stored in the last 6 hours.",
        )
    window = HARMiddleware.inference_window(history)
    if len(window) < HARMiddleware.MIN_WINDOW_SIZE:
        raise HTTPException(
            status_code=400,
            detail=(
                "Not enough recent motion samples for a prediction. "
                f"Need at least {HARMiddleware.MIN_WINDOW_SIZE} samples "
                "in the latest activity burst."
            ),
        )
    model = _load_har_model()
    activity, confidence, _features = _predict_from_readings(window, model)
    summary = await _optional_har_summary(activity, confidence)
    described = HARMiddleware.describe_window(history, window)
    return HARCurrentPredictionOut(
        activity=activity,
        confidence=round(confidence, 4),
        window_samples=described["inference_samples"],
        window_start=described["inference_start"],
        window_end=described["inference_end"],
        lookback_hours=described["lookback_hours"],
        history_samples=described["history_samples"],
        history_start=described["history_start"],
        history_end=described["history_end"],
        summary=summary,
    )


@har_router.post("/predict", status_code=200, tags=["Human Activity Recognition"])
async def predict_activity(
    window: HARWindowScheme,
    _user: UserModel = Depends(get_current_user),
):
    model = _load_har_model()
    activity, confidence, _features = _predict_from_readings(window.readings, model)
    summary = await _optional_har_summary(activity, confidence)
    return {
        "activity": activity,
        "confidence": round(confidence, 4),
        "window_samples": len(window.readings),
        "summary": summary,
    }
