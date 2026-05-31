from fastapi import APIRouter
from data.connection.response_json import RootResponse, StatusCode

from core.utils.dbConnection import engine, SessionLocal

router = APIRouter()


@router.get("/health")
def health():
    return {
        "engine": engine is not None,
        "session": SessionLocal is not None,
    }


@router.get("/", status_code=200)
async def root():
    return await RootResponse(StatusCode.OK, "Service is running").res
