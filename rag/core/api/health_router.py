<<<<<<< Updated upstream
import logging
from fastapi import APIRouter, status
from core import ResponseModel, _ResponseCode, _ResponseStatus
from data import ChromaClient

health_router = APIRouter(prefix="", tags=["Health"])
logger = logging.getLogger("HealthCheck")


@health_router.get(
    "/health",
    status_code=status.HTTP_200_OK,
    response_model=ResponseModel,
)
def health() -> ResponseModel:
    db_client = ChromaClient()
    return ResponseModel(
        status_code=(
            _ResponseCode.SUCCESS if db_client.health() else _ResponseCode.BAD_REQUEST
        ),
        status=_ResponseStatus.SUCCESS if db_client.health() else _ResponseStatus.ERROR,
        message=(
            "Server Start Successfull!"
            if db_client.health()
            else "Server Start Failed!"
        ),
        body=None,
    )
=======
import logging
from fastapi import APIRouter, status
from core import ResponseModel, _ResponseCode, _ResponseStatus
from data import ChromaClient

health_router = APIRouter(prefix="", tags=["Health"])
logger = logging.getLogger("HealthCheck")


@health_router.get(
    "/health",
    status_code=status.HTTP_200_OK,
    response_model=ResponseModel,
)
def health() -> ResponseModel:
    db_client = ChromaClient()
    return ResponseModel(
        status_code=(
            _ResponseCode.SUCCESS if db_client.health() else _ResponseCode.BAD_REQUEST
        ),
        status=_ResponseStatus.SUCCESS if db_client.health() else _ResponseStatus.ERROR,
        message=(
            "Server Start Successfull!"
            if db_client.health()
            else "Server Start Failed!"
        ),
        body=None,
    )
>>>>>>> Stashed changes
