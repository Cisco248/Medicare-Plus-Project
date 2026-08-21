import pandas as pd
from fastapi import APIRouter
from data import HypertensionScehema, DiabetesScehema
from repository import (
    ArtifactLoader,
    HypertensionMiddleware,
    DiabetesMiddleware,
    RagClientMiddleware,
)
from core import ServerSettings

base_model_router = APIRouter()
config = ServerSettings()


@base_model_router.post("/hypertension", status_code=200, tags=["Base Model"])
async def hypertension_add_data(
    schema: HypertensionScehema,
    loader=ArtifactLoader(),
    middleware=HypertensionMiddleware(),
):

    model = loader.model_loader(config.HYPERTENSION_MODEL_PATH)
    features = loader.feature_loader(config.HYPERTENSION_FEATURE_PATH)
    labels = loader.label_loader(config.HYPERTENSION_LABEL_PATH)

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

    response = await RagClientMiddleware(
        url=f"{config.RAG_URL}/e-doc",
        data={
            "prediction": labels[pred_code],
            "age": schema.age,
            "height": schema.height,
            "weight": schema.weight,
            "bmi": bmi_value,
            "hemoglobin_count": schema.hba1c,
            "cholesterol_mgdl": schema.cholesterol_mgdl,
            "diabetes_ordinal": schema.diabetes_ordinal,
            "gender": schema.gender,
        },
    ).build()

    return response.json()


@base_model_router.post("/diabetes", status_code=200, tags=["Base Model"])
async def diabetes_add_data(
    schema: DiabetesScehema,
    loader=ArtifactLoader(),
    middleware=DiabetesMiddleware(),
):
    model = loader.model_loader(config.DIABETES_MODEL_PATH)
    scaler = loader.scaler_loader(config.DIABETES_SCALER_PATH)
    features = loader.feature_loader(config.DIABETES_FEATURE_PATH)

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

    question = middleware.build_rag_question(
        diagnosis=diagnosis,
        age=schema.age,
        gender=schema.gender,
        glucose=schema.glucose,
        bmi=schema.bmi,
        systolic_bp=schema.systolic_bp,
        diastolic_bp=schema.diastolic_bp,
        family_diabetes=schema.family_diabetes,
        hypertensive=schema.hypertensive,
    )

    recommendations = None
    try:
        rag_response = await RagClientMiddleware(
            url=f"{config.RAG_URL}/e-doc",
            data={"question": question},
        ).build()
        rag_response.raise_for_status()
        recommendations = rag_response.json()
    except Exception:
        # RAG system unreachable / mis-configured (e.g. missing OpenAI key) --
        # don't let that take down the diabetes prediction itself.
        recommendations = None

    return {
        "prediction": pred_code,
        "diagnosis": diagnosis,
        "confidence": round(pred_proba, 4),
        "recommendations": recommendations,
    }
