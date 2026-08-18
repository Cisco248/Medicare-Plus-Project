import logging
from fastapi import APIRouter, Request, status
from fastapi.responses import JSONResponse
from data import ClientFactory

health_router = APIRouter(prefix="", tags=["Health"])
logger = logging.getLogger("HealthCheck")


@health_router.get("/health")
def health(request: Request):
    db_client = ClientFactory()
    storage_ok = bool(db_client.health_manager())
    rag = getattr(request.app.state, "rag", None)
    rag_ready = bool(getattr(rag, "ready", False))
    is_healthy = storage_ok
    return JSONResponse(
        status_code=(
            status.HTTP_200_OK
            if is_healthy
            else status.HTTP_503_SERVICE_UNAVAILABLE
        ),
        content={
            "status_code": 200 if is_healthy else 503,
            "status": "Success" if is_healthy else "Error",
            "title": "Medicare+ RAG API",
            "description": "Medicare Retrieve Augmented Generative System",
            "version": "V1.0",
            "message": (
                "RAG storage is ready."
                if is_healthy
                else "RAG storage is unavailable."
            ),
            "body": {"storage": storage_ok, "ready": rag_ready},
        },
    )
