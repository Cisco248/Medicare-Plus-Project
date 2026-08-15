from datetime import datetime

from pydantic import BaseModel, Field


class Response(BaseModel):
    answer: str
    recommendations: list[str]
    caution: str


class HealthSummaryResponse(BaseModel):
    """Response of ``POST /api/knowledge``.

    The summary is an AI-generated informational text grounded in the
    submitted health data and the retrieved medical knowledge. It is not a
    medical diagnosis, which the disclaimer states explicitly.
    """

    summary: str
    recommendations: list[str] = Field(default_factory=list)
    disclaimer: str
    generated_at: datetime
