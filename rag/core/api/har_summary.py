from fastapi import APIRouter, HTTPException, status, Request as FastAPIRequest
from pydantic import BaseModel, Field

from .ready import require_ready

har_router = APIRouter()


class HarSummaryRequest(BaseModel):
    question: str = Field(min_length=1, max_length=4000)


@har_router.post(
    "/har-summary",
    status_code=200,
    tags=["Human Activity Recognition"],
    summary="Explain a classified physical activity using the knowledge base",
)
async def ask_question(payload: HarSummaryRequest, request: FastAPIRequest):
    pipeline = require_ready(request)
    try:
        return pipeline.invoke(payload.question)
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc
