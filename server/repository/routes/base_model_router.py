import pandas as pd
from fastapi import APIRouter, HTTPException
from data import HypertensionScehema, DiabetesSchema
from repository import ArtifactLoader, HypertensionMiddleware, RagClientMiddleware
from core import ServerSettings

base_model_router = APIRouter()
config = ServerSettings()


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

    response = await RagClientMiddleware(
        url=f"{config.RAG_HOST}:{config.RAG_PORT}/e-doc",
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
async def diabetes_add_data(request: DiabetesSchema):
    try:
        pass

    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

    except Exception as e:
        raise HTTPException(status_code=500, detail="Prediction failed")
