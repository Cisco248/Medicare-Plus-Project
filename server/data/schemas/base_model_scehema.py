from typing import Any
from pydantic import BaseModel


class HypertensionScehema(BaseModel):
    age: int
    height: float
    weight: float
    hba1c: float
    cholesterol_mgdl: float
    diabetes_ordinal: str
    gender: str


class HeartScehema(BaseModel):
    bmi: float
    smoking: str
    alcohol_drinking: str
    stroke: str
    physical_health: Any
    mental_health: Any
    diff_walking: str
    sex: str
    age_category: str
    race: str
    diabetic: str
    physical_activity: str
    gen_health: str
    sleep_time: int
    asthma: str
    kidney_disease: str
    skin_cancer: str
