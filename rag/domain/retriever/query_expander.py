"""Expand chatbot questions with medical synonyms and e-doc disease hints."""

from __future__ import annotations

import re

_GENERIC_PHRASES = (
    "this disease",
    "this condition",
    "this illness",
    "my results",
    "my result",
    "my values",
    "my value",
    "my parameters",
    "these parameters",
    "my prediction",
    "the prediction",
    "the model",
    "e-doc",
    "edoc",
    "my glucose",
    "my bmi",
    "my blood pressure",
    "my bp",
    "my sugar",
)

_ALIAS_GROUPS: tuple[tuple[tuple[str, ...], tuple[str, ...]], ...] = (
    (
        ("diabetes", "diabetic", "prediabetes", "pre-diabetic", "pre diabetic"),
        ("diabetes mellitus", "high blood sugar", "blood glucose"),
    ),
    (
        ("hypertension", "hypertensive", "high blood pressure", "high bp", "elevated bp"),
        ("hypertension", "high blood pressure"),
    ),
    (
        (
            "heart disease",
            "cardiac",
            "cardiovascular",
            "heart attack",
            "coronary",
            "heart condition",
        ),
        ("heart disease", "cardiovascular disease"),
    ),
    (
        ("glucose", "blood sugar", "sugar level", "blood glucose"),
        ("glucose", "blood sugar", "blood glucose"),
    ),
    (("bmi", "body mass"), ("bmi", "body mass index")),
    (
        ("hba1c", "a1c", "hb a1c", "glycated", "hemoglobin count"),
        ("hba1c", "glycated hemoglobin"),
    ),
    (
        ("cholesterol", "ldl", "hdl", "triglyceride", "lipid"),
        ("cholesterol", "blood lipids"),
    ),
    (("insulin",), ("insulin", "diabetes")),
    (
        ("diet", "food", "eat", "meal", "rice", "dhal", "hopper", "roti"),
        ("diet", "eating pattern", "nutrition"),
    ),
    (
        ("exercise", "walking", "activity", "workout", "sedentary"),
        ("physical activity", "exercise"),
    ),
    (
        (
            "emergency",
            "unconscious",
            "chest pain",
            "stroke",
            "seizure",
            "hypoglycaemia",
            "hypoglycemia",
        ),
        ("emergency warning signs",),
    ),
    (
        ("identify", "diagnose", "diagnosis", "test for", "how do i know"),
        ("diagnosis", "diagnostic test"),
    ),
    (
        ("control", "manage", "management", "treat"),
        ("management", "self-care"),
    ),
    (
        ("medication", "medicine", "drug", "tablet", "insulin"),
        ("medication", "medicine class"),
    ),
    (
        ("e-doc", "edoc", "e doc", "prediction", "the model", "why does the model"),
        ("e-doc", "prediction model", "health parameter"),
    ),
    (("pulse", "heart rate", "bpm"), ("pulse rate", "heart rate")),
    (("family history", "family diabetes"), ("family history of diabetes",)),
)


def _contains_any(text: str, phrases: tuple[str, ...] | list[str]) -> bool:
    return any(phrase in text for phrase in phrases)


def expand_query(question: str, patient_context: str | None = None) -> str:
    """Return a retrieval query with modest synonym and context hints."""
    question = (question or "").strip()
    if not question:
        return question

    text = question.lower()
    extras: list[str] = []

    # Whole-word "sugar" and "bp" so we do not match unrelated tokens.
    if re.search(r"\bsugar\b", text) and "diabetes" not in text:
        extras.extend(["glucose", "blood sugar", "diabetes"])
    if re.search(r"\bbp\b", text) and "blood pressure" not in text:
        extras.extend(["blood pressure", "hypertension"])

    for triggers, aliases in _ALIAS_GROUPS:
        if _contains_any(text, triggers):
            extras.extend(aliases)

    context = (patient_context or "").lower()
    needs_disease_hint = _contains_any(text, _GENERIC_PHRASES) or bool(
        re.search(r"\bmy\b", text)
    )
    if needs_disease_hint or context:
        if "diabetes" in context and "diabetes" not in text:
            extras.append("diabetes")
        if (
            "hypertension" in context or "blood pressure" in context
        ) and "hypertension" not in text:
            extras.append("hypertension")
        if "heart" in context and "heart disease" not in text:
            extras.append("heart disease")

    unique: list[str] = []
    seen: set[str] = set()
    lowered_question = text
    for item in extras:
        key = item.lower()
        if key in seen or key in lowered_question:
            continue
        seen.add(key)
        unique.append(item)

    if not unique:
        return question
    return f"{question} {' '.join(unique)}"
