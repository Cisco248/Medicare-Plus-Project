"""Path-derived metadata so every ingested chunk keeps disease and topic context."""

from pathlib import Path

_DIR_META: dict[str, dict[str, str]] = {
    "diabetes": {"disease": "diabetes", "medical_domain": "endocrinology"},
    "hypertension": {"disease": "hypertension", "medical_domain": "cardiology"},
    "heart_disease": {"disease": "heart_disease", "medical_domain": "cardiology"},
    "cholesterol": {"disease": "cholesterol", "medical_domain": "cardiology"},
    "parameters": {"category": "parameter", "topic": "interpretation"},
    "models": {"category": "model", "topic": "prediction"},
    "e_doc": {"category": "e-doc", "topic": "form"},
    "combinations": {"category": "combination", "topic": "relationships"},
    "faq": {"category": "faq", "topic": "questions"},
    "medications": {"category": "medication", "topic": "treatment"},
    "diet": {"category": "diet", "topic": "nutrition"},
    "cross_disease": {"category": "cross_disease", "topic": "relationships"},
    "safety": {"category": "safety", "topic": "emergency"},
    "monitoring": {"category": "monitoring", "topic": "self_monitoring"},
    "physical_activity": {"category": "exercise", "topic": "activity"},
    "sleep": {"category": "sleep", "topic": "sleep"},
    "body_metrics": {
        "category": "parameter",
        "parameter": "bmi",
        "topic": "interpretation",
    },
    "heart_rate": {
        "category": "parameter",
        "parameter": "pulse_rate",
        "topic": "interpretation",
    },
    "daily_use_cases": {"category": "daily_summary", "topic": "wearables"},
    "wearables": {"category": "wearables", "topic": "device_limits"},
}

_FILE_CATEGORY = {
    "overview.md": "overview",
    "symptoms.md": "symptom",
    "risk_factors.md": "risk",
    "diagnosis.md": "diagnosis",
    "management.md": "management",
    "diet.md": "diet",
    "physical_activity.md": "exercise",
    "sleep.md": "sleep",
    "monitoring.md": "monitoring",
    "warning_signs.md": "emergency",
    "medications.md": "medication",
    "complications.md": "complication",
    "causes.md": "cause",
    "types.md": "definition",
    "emergencies.md": "emergency",
    "prevention.md": "prevention",
}

_PARAMETER_FILES = {
    "glucose.md": "glucose",
    "hba1c.md": "hba1c",
    "bmi.md": "bmi",
    "age.md": "age",
    "gender.md": "gender",
    "sex.md": "sex",
    "pulse_rate.md": "pulse_rate",
    "systolic_bp.md": "systolic_bp",
    "diastolic_bp.md": "diastolic_bp",
    "blood_pressure.md": "blood_pressure",
    "family_diabetes.md": "family_diabetes",
    "hypertensive.md": "hypertensive",
    "height.md": "height",
    "weight.md": "weight",
    "cholesterol.md": "cholesterol",
    "diabetes_ordinal.md": "diabetes_ordinal",
    "age_category.md": "age_category",
    "gen_health.md": "gen_health",
    "diabetic.md": "diabetic",
    "smoking.md": "smoking",
    "stroke.md": "stroke",
    "diff_walking.md": "diff_walking",
    "physical_health.md": "physical_health",
    "insulin.md": "insulin",
}

_MODEL_FILES = {
    "diabetes-model.md": "diabetes_prediction",
    "hypertension-model.md": "hypertension_prediction",
    "heart-disease-model.md": "heart_disease_prediction",
    "parameter-mapping.md": "all_models",
}


def metadata_for_source(source: str) -> dict[str, str]:
    raw = str(source or "").replace("\\", "/")
    lowered = raw.lower()
    meta: dict[str, str] = {"document_type": "knowledge"}

    if lowered.startswith("http://") or lowered.startswith("https://"):
        meta["document_type"] = "web"
        meta["category"] = "external_source"
        if "diabetes" in lowered:
            meta["disease"] = "diabetes"
        elif "blood-pressure" in lowered or "hypertension" in lowered:
            meta["disease"] = "hypertension"
        elif "heart" in lowered or "stroke" in lowered or "cholesterol" in lowered:
            meta["disease"] = "heart_disease"
        return meta

    parts = Path(raw).parts
    top = parts[0].lower() if parts else ""
    filename = Path(raw).name.lower()

    if top in _DIR_META:
        meta.update(_DIR_META[top])

    if filename in _FILE_CATEGORY:
        meta["topic"] = _FILE_CATEGORY[filename]
        meta.setdefault("category", _FILE_CATEGORY[filename])

    if filename in _PARAMETER_FILES:
        meta["category"] = "parameter"
        meta["parameter"] = _PARAMETER_FILES[filename]
        meta["topic"] = "interpretation"

    if filename in _MODEL_FILES:
        meta["category"] = "model"
        meta["model"] = _MODEL_FILES[filename]
        meta["topic"] = "prediction"
        if "diabetes" in filename:
            meta["disease"] = "diabetes"
        elif "hypertension" in filename:
            meta["disease"] = "hypertension"
        elif "heart" in filename:
            meta["disease"] = "heart_disease"

    if top == "faq":
        if "diabetes" in filename:
            meta["disease"] = "diabetes"
        elif "hypertension" in filename:
            meta["disease"] = "hypertension"
        elif "heart" in filename:
            meta["disease"] = "heart_disease"
        elif "parameter" in filename:
            meta["category"] = "parameter"
        elif "e_doc" in filename or "edoc" in filename:
            meta["category"] = "e-doc"
        elif "model" in filename:
            meta["category"] = "model"

    if top in {"medications", "diet", "e_doc"}:
        if "diabetes" in filename:
            meta["disease"] = "diabetes"
            if top == "e_doc":
                meta["model"] = "diabetes_prediction"
        elif "hypertension" in filename:
            meta["disease"] = "hypertension"
            if top == "e_doc":
                meta["model"] = "hypertension_prediction"
        elif "heart" in filename:
            meta["disease"] = "heart_disease"
            if top == "e_doc":
                meta["model"] = "heart_disease_prediction"

    if top == "parameters":
        param = meta.get("parameter", Path(filename).stem)
        if param in {
            "glucose",
            "hba1c",
            "family_diabetes",
            "insulin",
            "diabetes_ordinal",
            "diabetic",
        }:
            meta.setdefault("disease", "diabetes")
        if param in {
            "systolic_bp",
            "diastolic_bp",
            "blood_pressure",
            "hypertensive",
        }:
            meta.setdefault("disease", "hypertension")
        if param in {
            "smoking",
            "stroke",
            "diff_walking",
            "physical_health",
            "gen_health",
        }:
            meta.setdefault("disease", "heart_disease")

    return {key: value for key, value in meta.items() if value}


def context_prefix(metadata: dict[str, str]) -> str:
    bits = ["Medicare Plus educational knowledge."]
    if metadata.get("disease"):
        bits.append(f"Disease: {metadata['disease']}.")
    if metadata.get("parameter"):
        bits.append(f"Health parameter: {metadata['parameter']}.")
    if metadata.get("model"):
        bits.append(f"Prediction model: {metadata['model']}.")
    if metadata.get("category"):
        bits.append(f"Category: {metadata['category']}.")
    if metadata.get("topic"):
        bits.append(f"Topic: {metadata['topic']}.")
    bits.append("This is general education, not a clinical diagnosis.")
    return " ".join(bits)
