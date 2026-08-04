from fastapi import APIRouter
from core import DBConnection, ResponseMessage

init_router = APIRouter()


@init_router.get(
    "/health", tags=["Health"], status_code=200, response_model=ResponseMessage
)
def health():
    return ResponseMessage(
        body={
            "engine": DBConnection.ENGINE is not None,
            "session": DBConnection.SESSION_LOACAL is not None,
        }
    )


@init_router.get("/", status_code=200, response_model=ResponseMessage)
def root():
    return ResponseMessage(body="Service is running")
