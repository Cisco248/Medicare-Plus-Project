import logging
from datetime import datetime, timezone

from fastapi import APIRouter, HTTPException, Request as FastAPIRequest, status
from langchain_core.prompts import ChatPromptTemplate

from core.configs.configuration import RAGSettings
from data import HealthSummaryRequest, HealthSummaryResponse
from data.model.request import KNOWLEDGE_SYSTEM_TEMPLATE, compose_knowledge_question
from data import load_knowledge_urls
from domain import setup_rag_system
from domain.pipeline.chain_manager import RAGPipeline

logger = logging.getLogger(__name__)
settings = RAGSettings()

knowledge_router = APIRouter()

DISCLAIMER = (
    "This is an AI-generated informational summary based on your recorded "
    "health data. It is not medical advice or a diagnosis. Consult a "
    "healthcare professional for medical concerns."
)

_SECTION_HEADINGS = (
    "recommendations:",
    "recommendation:",
    "insights:",
)

_BODY_HEADINGS = (
    "status:",
    "trend:",
    "risk:",
    "recommendations:",
    "recommendation:",
    "insights:",
)


def _strip_health_summary_parameters(text: str) -> str:
    """Drop a leading Health Summary parameter dump from the generated report."""
    stripped = text.strip()
    lower = stripped.lower()
    if not lower.startswith("health summary"):
        return stripped
    indexes = [
        lower.find(heading)
        for heading in _BODY_HEADINGS
        if lower.find(heading) != -1
    ]
    if not indexes:
        return stripped
    return stripped[min(indexes) :].strip()

_HEALTH_SUMMARY_PROMPT = ChatPromptTemplate.from_messages(
    [
        ("system", KNOWLEDGE_SYSTEM_TEMPLATE),
        (
            "human",
            "Recorded patient data and generation question:\n{question}\n\n"
            "Medical knowledge context:\n{context}",
        ),
    ]
)


def _split_recommendations(text: str) -> tuple[str, list[str]]:
    lower = text.lower()
    rec_index = lower.find("recommendations:")
    if rec_index == -1:
        rec_index = lower.find("recommendation:")
    if rec_index == -1:
        return text.strip(), []

    summary = text[:rec_index].strip()
    remainder = text[rec_index:]
    insight_index = remainder.lower().find("\ninsights:")
    rec_block = remainder if insight_index == -1 else remainder[:insight_index]
    lines = [
        line.strip().lstrip("-*\u2022 ").strip()
        for line in rec_block.splitlines()[1:]
        if line.strip().lstrip("-*\u2022 ").strip()
        and not line.strip().lower().startswith(_SECTION_HEADINGS)
    ]
    if insight_index != -1:
        summary = f"{summary}\n\n{remainder[insight_index:].strip()}".strip()
    return summary or text.strip(), lines


def _generate(pipeline: RAGPipeline, question: str) -> str:
    generate = getattr(pipeline, "invoke_health_summary", None)
    if callable(generate):
        return str(generate(question, prompt=_HEALTH_SUMMARY_PROMPT))
    return str(pipeline.invoke(question))


@knowledge_router.post(
    "/knowledge",
    status_code=status.HTTP_200_OK,
    response_model=HealthSummaryResponse,
    tags=["Knowledge"],
    summary="Generate a daily health summary from the mobile generationQuestion",
)
async def generate_health_summary(
    payload: HealthSummaryRequest,
    request: FastAPIRequest,
) -> HealthSummaryResponse:
    rag = getattr(request.app.state, "rag", None)
    if rag is None:
        rag = setup_rag_system(
            [settings.FILE_LOCATION],
            urls=load_knowledge_urls(settings.KNOWLEDGE_URLS_FILE),
        )
        request.app.state.rag = rag
    if not getattr(rag, "ready", False):
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="The RAG knowledge index is not ready.",
        )

    question = compose_knowledge_question(payload)
    if payload.user_id:
        logger.info("Generating patient-scoped health summary for a single user")
    try:
        generated = _generate(rag, question)
    except ValueError as exc:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(exc))
    except Exception:
        logger.exception("RAG health-summary generation failed")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="The health summary could not be generated. Please try again.",
        )

    summary, recommendations = _split_recommendations(
        _strip_health_summary_parameters(str(generated))
    )
    return HealthSummaryResponse(
        summary=summary,
        recommendations=recommendations,
        disclaimer=DISCLAIMER,
        generated_at=datetime.now(timezone.utc),
    )
