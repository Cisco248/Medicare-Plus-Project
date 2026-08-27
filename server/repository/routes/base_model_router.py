from pathlib import Path

import pandas as pd
from fastapi import APIRouter, HTTPException
from data import DiabetesSchema, HeartDiseaseSchema, HypertensionScehema
from repository.middlewares import (
    ArtifactLoader,
    DiabetesMiddleware,
    HeartDiseaseMiddleware,
    HypertensionMiddleware,
    RagClientMiddleware,
)
from core import ServerSettings

base_model_router = APIRouter()
config = ServerSettings()


@base_model_router.post("/hypertension", status_code=200, tags=["Base Model"])
async def hypertension_add_data(schema: HypertensionScehema):
    loader = ArtifactLoader()
    middleware = HypertensionMiddleware()

    model = loader.model_loader(config.HYPERTENSION_PATH + "/model.pkl")
    features = loader.feature_loader(config.HYPERTENSION_PATH + "/features.pkl")
    labels = loader.label_loader(config.HYPERTENSION_PATH + "/labels.pkl")

    bmi_value = middleware.bmi_calculator(schema.height, schema.weight)
    gender_value = middleware.gender_encoder(schema.gender)
    diabetes_value = middleware.diabetes_encoder(schema.diabetes_ordinal)

    data = pd.DataFrame(
        [
            {
                "age": schema.age,
                "bmi": bmi_value,
                "hba1c_pct": schema.hba1c,
                "cholesterol_mgdl": schema.cholesterol_mgdl,
                "diabetes_ordinal": diabetes_value,
                "sex_male": gender_value,
            }
        ]
    )[features]
    pred_code = model.predict(data)[0]
    prediction = labels[pred_code]
    question = middleware.compose_question(schema, prediction, bmi_value)

    recommendations: str | None = None
    try:
        response = await RagClientMiddleware(
            url=f"{config.rag_url}/api/e-doc",
            data={"question": question},
        ).build()
        response.raise_for_status()
        recommendations = response.json()
    except HTTPException as exc:
        status_code = 503 if exc.status_code in (503, 504, None) else 502
        if exc.status_code and 400 <= exc.status_code < 500 and exc.status_code != 404:
            status_code = exc.status_code
        raise HTTPException(status_code=status_code, detail=str(exc)) from exc

    return {
        "prediction": prediction,
        "recommendations": recommendations,
    }


@base_model_router.post("/diabetes", status_code=200, tags=["Base Model"])
async def diabetes_add_data(schema: DiabetesSchema):
    loader = ArtifactLoader()
    middleware = DiabetesMiddleware()

    try:
        model = loader.model_loader(config.DIABETES_MODEL_PATH)
        scaler = loader.scaler_loader(config.DIABETES_SCALER_PATH)
        features = loader.feature_loader(config.DIABETES_FEATURE_PATH)
    except Exception as exc:
        raise HTTPException(
            status_code=503,
            detail="The diabetes model is not available on the server.",
        ) from exc

    gender_value = middleware.gender_encoder(schema.gender)
    family_diabetes_value = middleware.yes_no_encoder(schema.family_diabetes)
    hypertensive_value = middleware.yes_no_encoder(schema.hypertensive)

    data = pd.DataFrame(
        [
            {
                "age": schema.age,
                "gender": gender_value,
                "pulse_rate": schema.pulse_rate,
                "systolic_bp": schema.systolic_bp,
                "diastolic_bp": schema.diastolic_bp,
                "glucose": schema.glucose,
                "bmi": schema.bmi,
                "family_diabetes": family_diabetes_value,
                "hypertensive": hypertensive_value,
            }
        ]
    )[features]

    scaled_data = scaler.transform(data)
    pred_code = int(model.predict(scaled_data)[0])
    pred_proba = float(model.predict_proba(scaled_data)[0][pred_code])
    diagnosis = middleware.risk_label(pred_code)

    question = middleware.build_rag_question(diagnosis=diagnosis, schema=schema)

    recommendations = None
    try:
        rag_response = await RagClientMiddleware(
            url=f"{config.rag_url}/api/e-doc",
            data={"question": question},
        ).build()
        rag_response.raise_for_status()
        recommendations = rag_response.json()
    except Exception:
        recommendations = None

    return {
        "prediction": diagnosis,
        "pred_code": pred_code,
        "diagnosis": diagnosis,
        "confidence": round(pred_proba, 4),
        "recommendations": recommendations,
    }


def _heart_disease_model_path() -> str:
    configured = Path(config.HEART_DISEASE_MODEL_PATH)
    if configured.exists():
        return str(configured)
    spaced = configured.parent / "model .pkl"
    if spaced.exists():
        return str(spaced)
    return str(configured)


async def _predict_heart_disease(schema: HeartDiseaseSchema) -> dict:
    loader = ArtifactLoader()
    middleware = HeartDiseaseMiddleware()
    try:
        model = loader.model_loader(_heart_disease_model_path())
        scaler = loader.scaler_loader(config.HEART_DISEASE_SCALER_PATH)
        features = middleware.load_features(config.HEART_DISEASE_FEATURE_PATH)
        info = middleware.load_info(config.HEART_DISEASE_INFO_PATH)
    except Exception as exc:
        raise HTTPException(
            status_code=503,
            detail="The heart-disease model is not available on the server.",
        ) from exc

    try:
        encoded = middleware.encode(schema)
    except ValueError as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc

    frame = pd.DataFrame([encoded])[features]
    numeric_cols = [
        column
        for column in info.get("numeric_cols", [])
        if column in frame.columns
    ]
    if numeric_cols:
        frame[numeric_cols] = scaler.transform(frame[numeric_cols])

    probability = float(model.predict_proba(frame)[0, 1])
    threshold = float(info.get("recommended_threshold", 0.6))
    high_risk = probability >= threshold
    diagnosis = middleware.risk_label(high_risk)
    question = middleware.build_rag_question(schema, diagnosis, probability)

    recommendations = None
    try:
        rag_response = await RagClientMiddleware(
            url=f"{config.rag_url}/api/e-doc",
            data={"question": question},
        ).build()
        rag_response.raise_for_status()
        recommendations = rag_response.json()
    except Exception:
        recommendations = None

    return {
        "pred_code": int(high_risk),
        "diagnosis": diagnosis,
        "confidence": round(probability, 4),
        "threshold": threshold,
        "recommendations": recommendations,
    }


@base_model_router.post("/heart-disease", status_code=200, tags=["Base Model"])
async def heart_disease_add_data(schema: HeartDiseaseSchema):
    return await _predict_heart_disease(schema)


@base_model_router.post("/hear-disease", status_code=200, tags=["Base Model"])
async def heart_disease_add_data_alias(schema: HeartDiseaseSchema):
    return await _predict_heart_disease(schema)
