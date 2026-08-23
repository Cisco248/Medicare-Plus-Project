from datetime import date
from typing import Optional

from fastapi import APIRouter, BackgroundTasks, Depends, Query
from sqlalchemy.orm import Session

from core import get_db
from data.models.user_data_model import UserModel
from data.schemas.health_activity_schema import (
    DailySummaryOut,
    HealthActivityIngestRequest,
    HealthActivityIngestResponse,
    HealthTrendsOut,
    PatientPredictionOut,
)
from repository.middlewares.auth_middleware import get_current_user
from repository.middlewares.health_activity_middleware import HealthActivityMiddleware
from repository.middlewares.prediction_middleware import PredictionMiddleware
from repository.middlewares.summary_ai_middleware import SummaryAIMiddleware

health_activity_router = APIRouter()


@health_activity_router.post(
    "/har",
    status_code=200,
    tags=["Health Activity Record"],
    response_model=HealthActivityIngestResponse,
    summary="Ingest a patient's health activity records for a calendar day",
)
def ingest_health_activity(
    payload: HealthActivityIngestRequest,
    background: BackgroundTasks,
    db: Session = Depends(get_db),
    user: UserModel = Depends(get_current_user),
) -> HealthActivityIngestResponse:
    result = HealthActivityMiddleware.ingest(db, user, payload)
    if result.summary_id:
        background.add_task(
            SummaryAIMiddleware.enrich,
            user_id=str(user.id),
            day=payload.date,
            timezone_name=payload.timezone,
        )
        background.add_task(SummaryAIMiddleware.generate_detached, user_id=str(user.id))
    return result


@health_activity_router.get(
    "/har/daily",
    status_code=200,
    tags=["Health Activity Record"],
    response_model=DailySummaryOut,
    summary="Return the authenticated patient's daily health summary",
)
def get_daily_summary(
    day: Optional[date] = Query(default=None),
    timezone: str = Query(default="UTC"),
    db: Session = Depends(get_db),
    user: UserModel = Depends(get_current_user),
) -> DailySummaryOut:
    return HealthActivityMiddleware.get_daily(db, user, day or date.today(), timezone)


@health_activity_router.get(
    "/har/trends",
    status_code=200,
    tags=["Health Activity Record"],
    response_model=HealthTrendsOut,
    summary="Return a 7-day trend for one health metric",
)
def get_health_trends(
    metric: str = Query(default="steps"),
    days: int = Query(default=7, ge=2, le=30),
    db: Session = Depends(get_db),
    user: UserModel = Depends(get_current_user),
) -> HealthTrendsOut:
    return HealthActivityMiddleware.trends(db, user, metric, days)


@health_activity_router.get(
    "/har/predictions",
    status_code=200,
    tags=["Health Activity Record"],
    response_model=list[PatientPredictionOut],
    summary="Return stored risk indicators for the authenticated patient",
)
def get_predictions(
    refresh: bool = Query(default=False),
    db: Session = Depends(get_db),
    user: UserModel = Depends(get_current_user),
) -> list[PatientPredictionOut]:
    if refresh:
        PredictionMiddleware.generate(db, user)
        return PredictionMiddleware.latest(db, user)
    existing = PredictionMiddleware.latest(db, user)
    if existing:
        return existing
    return [PredictionMiddleware.generate(db, user)]


@health_activity_router.post(
    "/har/predictions",
    status_code=200,
    tags=["Health Activity Record"],
    response_model=list[PatientPredictionOut],
    summary="Regenerate risk indicators from the latest health record",
)
def refresh_predictions(
    db: Session = Depends(get_db),
    user: UserModel = Depends(get_current_user),
) -> list[PatientPredictionOut]:
    PredictionMiddleware.generate(db, user)
    return PredictionMiddleware.latest(db, user)
