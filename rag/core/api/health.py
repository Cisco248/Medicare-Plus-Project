import logging

from fastapi import APIRouter

health_router = APIRouter()
logger = logging.getLogger("HealthCheck")


@health_router.get("/health")
async def health() -> str:
    return logger.makeRecord(
        name="HealthCheck",
        level=logging.INFO,
        fn="",
        lno=0,
        msg="RAG API is healthy",
        args=(),
        exc_info=None,
    ).getMessage()
