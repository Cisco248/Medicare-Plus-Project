import logging
from datetime import datetime, timezone

from fastapi import APIRouter, HTTPException, Request as FastAPIRequest, status

from core.configs.configuration import RAGSettings
from data import HealthActivities, HealthSummaryRequest, HealthSummaryResponse
from domain import setup_rag_system

logger = logging.getLogger(__name__)
knowledge_router = APIRouter()
settings = RAGSettings()

DISCLAIMER = (
    "This is an AI-generated informational summary based on your recorded "
    "health data. It is not medical advice or a diagnosis. Consult a "
    "healthcare professional for medical concerns."
)

_RECOMMENDATION_HEADINGS = ("recommendations:", "recommendation:")


def _describe_activities(activities: HealthActivities) -> tuple[list[str], list[str]]:
    """Splits the metrics into factual statements and unavailable metrics."""
    facts: list[str] = []
    unavailable: list[str] = []

    def add(label: str, value: str | None) -> None:
        if value is None:
            unavailable.append(label)
        else:
            facts.append(f"- {label}: {value}")

    add("Steps", f"{activities.steps}" if activities.steps is not None else None)
    add(
        "Distance",
        f"{activities.distance_meters:.0f} meters"
        if activities.distance_meters is not None
        else None,
    )
    add(
        "Active calories burned",
        f"{activities.active_calories:.0f} kcal"
        if activities.active_calories is not None
        else None,
    )
    add(
        "Total calories burned",
        f"{activities.total_calories:.0f} kcal"
        if activities.total_calories is not None
        else None,
    )

    heart_rate = activities.heart_rate
    if heart_rate is None:
        unavailable.append("Heart rate")
    else:
        parts = []
        if heart_rate.average_bpm is not None:
            parts.append(f"average {heart_rate.average_bpm:.0f} bpm")
        if heart_rate.min_bpm is not None and heart_rate.max_bpm is not None:
            parts.append(f"range {heart_rate.min_bpm}-{heart_rate.max_bpm} bpm")
        if heart_rate.resting_bpm is not None:
            parts.append(f"resting {heart_rate.resting_bpm:.0f} bpm")
        facts.append(f"- Heart rate: {', '.join(parts) if parts else 'measured'}")

    sleep = activities.sleep
    if sleep is None:
        unavailable.append("Sleep")
    else:
        hours, minutes = divmod(sleep.total_minutes, 60)
        facts.append(
            f"- Sleep: {hours}h {minutes}m across {sleep.session_count} session(s)"
        )

    if activities.workouts:
        sessions = "; ".join(
            f"{workout.type.lower().replace('_', ' ')} for "
            f"{workout.duration_minutes} minute(s)"
            for workout in activities.workouts
        )
        facts.append(f"- Workouts: {sessions}")
    else:
        unavailable.append("Workouts")

    add(
        "Weight",
        f"{activities.weight_kilograms:.1f} kg"
        if activities.weight_kilograms is not None
        else None,
    )
    add(
        "Height",
        f"{activities.height_meters:.2f} m"
        if activities.height_meters is not None
        else None,
    )

    blood_pressure = activities.blood_pressure
    add(
        "Blood pressure",
        f"{blood_pressure.systolic_mm_hg:.0f}/{blood_pressure.diastolic_mm_hg:.0f} mmHg"
        if blood_pressure is not None
        else None,
    )
    add(
        "Blood glucose",
        f"{activities.blood_glucose_mmol_per_liter:.1f} mmol/L"
        if activities.blood_glucose_mmol_per_liter is not None
        else None,
    )
    add(
        "Oxygen saturation",
        f"{activities.oxygen_saturation_percent:.0f}%"
        if activities.oxygen_saturation_percent is not None
        else None,
    )

    return facts, unavailable


def _build_question(payload: HealthSummaryRequest) -> str:
    facts, unavailable = _describe_activities(payload.activities)
    period = payload.period
    lines = [
        "You are given a patient's recorded health data from "
        f"{period.start.isoformat()} to {period.end.isoformat()}.",
        "Recorded data:",
        *facts,
    ]
    if unavailable:
        lines.append(
            "The following metrics were NOT recorded and are unknown "
            "(do not assume they are zero and do not invent values): "
            + ", ".join(unavailable)
            + "."
        )
    lines.append(
        "Write a short informational summary of the patient's health and "
        "activity based only on the recorded data above and the medical "
        "context. Do not provide a diagnosis. Do not invent measurements."
    )
    return "\n".join(lines)


def _split_recommendations(text: str) -> tuple[str, list[str]]:
    """Extracts an optional 'Recommendations:' section from the LLM output."""
    lower = text.lower()
    for heading in _RECOMMENDATION_HEADINGS:
        index = lower.find(heading)
        if index == -1:
            continue
        summary = text[:index].strip()
        recommendations = [
            line.strip().lstrip("-*\u2022 ").strip()
            for line in text[index + len(heading):].splitlines()
            if line.strip().lstrip("-*\u2022 ").strip()
        ]
        return summary or text.strip(), recommendations
    return text.strip(), []


@knowledge_router.post(
    "/knowledge",
    status_code=status.HTTP_200_OK,
    response_model=HealthSummaryResponse,
    tags=["RAG System"],
)
async def generate_health_summary(
    payload: HealthSummaryRequest, request: FastAPIRequest
) -> HealthSummaryResponse:
    rag = getattr(request.app.state, "rag", None)
    if rag is None:
        rag = setup_rag_system(f"{settings.FILE_LOCATION}/sample.pdf")

    question = _build_question(payload)
    try:
        generated = rag.invoke(question)
    except Exception:
        logger.exception("RAG health-summary generation failed")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="The health summary could not be generated. Please try again.",
        )

    summary, recommendations = _split_recommendations(str(generated))
    return HealthSummaryResponse(
        summary=summary,
        recommendations=recommendations,
        disclaimer=DISCLAIMER,
        generated_at=datetime.now(timezone.utc),
    )
