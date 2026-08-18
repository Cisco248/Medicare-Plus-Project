import pandas as pd
from fastapi import APIRouter, HTTPException
from data import HypertensionScehema, DiabetesSchema
from repository import ArtifactLoader, HypertensionMiddleware, RagClientMiddleware
from repository.middlewares.rag_client_middleware import RagClientError
from core import ServerSettings

base_model_router = APIRouter()
config = ServerSettings()


def _compose_hypertension_question(schema: HypertensionScehema, prediction: str, bmi: float) -> str:
    return (
        "Explain this hypertension risk assessment for a patient using only "
        "the medical knowledge context. Do not diagnose and do not invent facts. "
        f"Predicted status: {prediction}. "
        f"Age: {schema.age}. Gender: {schema.gender}. "
        f"Height: {schema.height} cm. Weight: {schema.weight} kg. "
        f"BMI: {bmi:.1f}. HbA1c: {schema.hba1c}%. "
        f"Cholesterol: {schema.cholesterol_mgdl} mg/dL. "
        f"Diabetes status: {schema.diabetes_ordinal}."
    )


@base_model_router.post("/hypertension", status_code=200, tags=["Base Model"])
async def hypertension_add_data(
    schema: HypertensionScehema,
    loader=ArtifactLoader(),
    middleware=HypertensionMiddleware(),
):

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
    question = _compose_hypertension_question(schema, prediction, bmi_value)

    try:
        response = await RagClientMiddleware(
            url=f"{config.RAG_HOST}:{config.RAG_PORT}/api/e-doc",
            data={
                "question": question,
                "prediction": prediction,
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
    except RagClientError as exc:
        status_code = 503 if exc.status_code in (503, 504, None) else 502
        if exc.status_code and 400 <= exc.status_code < 500 and exc.status_code != 404:
            status_code = exc.status_code
        raise HTTPException(status_code=status_code, detail=str(exc)) from exc

    try:
        return response.json()
    except ValueError as exc:
        raise HTTPException(
            status_code=502,
            detail="The assessment service returned an unexpected response.",
        ) from exc


@base_model_router.post("/diabetes", status_code=200, tags=["Base Model"])
async def diabetes_add_data(request: DiabetesSchema):
    try:
        pass

    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

    except Exception:
        raise HTTPException(status_code=500, detail="Prediction failed")
