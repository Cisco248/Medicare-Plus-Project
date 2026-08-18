import logging
from fastapi import APIRouter, status
from core.formats import ResponseModel, _ResponseCode, _ResponseStatus
from data import ClientFactory

health_router = APIRouter(prefix="", tags=["Health"])
logger = logging.getLogger("HealthCheck")


@health_router.get(
    "/health",
    status_code=status.HTTP_200_OK,
    response_model=ResponseModel,
)
def health() -> ResponseModel:
    db_client = ClientFactory()
    is_healthy = db_client.health_manager()
    return ResponseModel(
        status_code=(
            _ResponseCode.SUCCESS if is_healthy else _ResponseCode.BAD_REQUEST
        ),
        status=_ResponseStatus.SUCCESS if is_healthy else _ResponseStatus.ERROR,
        message=(
            "RAG storage is ready." if is_healthy else "RAG storage is unavailable."
        ),
        body=None,
    )
