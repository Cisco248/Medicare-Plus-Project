from fastapi import APIRouter
from data.connection.response_json import RootResponse, StatusCode

router = APIRouter()


@router.get("/", status_code=200)
async def root():
    return await RootResponse(StatusCode.OK, "Service is running").res
