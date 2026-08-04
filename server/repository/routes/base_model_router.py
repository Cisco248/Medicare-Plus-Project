from dataclasses import dataclass
import pandas as pd
from fastapi import APIRouter
from data import HypertensionScehema
from repository import ArtifactLoader
from core import ServerSettings

base_model_router = APIRouter()
config = ServerSettings()


@dataclass
class ResponseModel:
    def to_dict(self, prediction: str, data: HypertensionScehema):
        return {
            "prediction": prediction,
            "age": data.age,
            "bmi": data.bmi,
            "hba1c_pct": data.hba1c_pct,
            "cholesterol_mgdl": data.cholesterol_mgdl,
            "diabetes_ordinal": data.diabetes_ordinal,
        }


@base_model_router.post("/hypertension", status_code=200, tags=["Base Model"])
def hypertension_add_data(schema: HypertensionScehema, middleware=ArtifactLoader()):
    """
    Parameters:
        schema: HypertensionScehema
            age: int
            bmi: float
            hba1c_pct: float
            cholesterol_mgdl: float
            diabetes_ordinal: int
            sex_male: int

        middleware: ArtifactLoader
            model_loader: function to load the model artifact

    Returns:
        dict:
            {Prediction: Non-Diabetic,
            Glucose: 148 mg/dL,
            Blood Pressure: 72 mmHg,
            Skin Thickness: 35 mm,
            Insulin: 0 μU/mL,
            BMI: 33.6 kg/m²,
            Diabetes Pedigree Function: 0.627,
            Age: 50 years}
    """

    model = middleware.model_loader(config.HYPERTENSION_MODEL_PATH)
    features = middleware.feature_loader(config.HYPERTENSION_FEATURE_PATH)
    labels = middleware.label_loader(config.HYPERTENSION_LABEL_PATH)

    sample = pd.DataFrame(
        [
            {
                "age": schema.age,
                "bmi": schema.bmi,
                "hba1c_pct": schema.hba1c_pct,
                "cholesterol_mgdl": schema.cholesterol_mgdl,
                "diabetes_ordinal": schema.diabetes_ordinal,
                "sex_male": schema.sex_male,
            }
        ]
    )[features]

    pred_code = model.predict(sample)[0]
    return ResponseModel().to_dict(labels[pred_code], schema)
