import re
from typing import Any

from pydantic import AliasChoices, BaseModel, Field, model_validator

_BP_READING = re.compile(
    r"^\s*(\d+(?:\.\d+)?)\s*[/\-]\s*(\d+(?:\.\d+)?)\s*$"
)


def parse_bp_reading(value: str) -> tuple[float, float] | None:
    match = _BP_READING.match(value)
    if match is None:
        return None
    return float(match.group(1)), float(match.group(2))


class HypertensionScehema(BaseModel):
    age: int
    height: float
    weight: float
    hba1c: float
    cholesterol_mgdl: float
    diabetes_ordinal: str
    gender: str


class DiabetesSchema(BaseModel):
    """Accepts both the Flutter e-doc form and the snake_case API shape.

    The mobile form sends camelCase plus a single ``bpReading`` such as
    ``120/80``. The model still uses split systolic/diastolic values.
    """

    age: int
    gender: str
    pulse_rate: float = Field(
        validation_alias=AliasChoices("pulse_rate", "pulseRate")
    )
    systolic_bp: float | None = Field(
        default=None,
        validation_alias=AliasChoices("systolic_bp", "systolicBp"),
    )
    diastolic_bp: float | None = Field(
        default=None,
        validation_alias=AliasChoices("diastolic_bp", "diastolicBp"),
    )
    glucose: float
    bmi: float
    family_diabetes: str = Field(
        validation_alias=AliasChoices("family_diabetes", "familyDiabetes")
    )
    hypertensive: str
    bp_reading: str | None = Field(
        default=None,
        validation_alias=AliasChoices("bp_reading", "bpReading"),
    )

    @model_validator(mode="before")
    @classmethod
    def _split_blood_pressure(cls, data: Any) -> Any:
        if not isinstance(data, dict):
            return data
        payload = dict(data)
        systolic = payload.get("systolic_bp", payload.get("systolicBp"))
        diastolic = payload.get("diastolic_bp", payload.get("diastolicBp"))
        reading = payload.get("bp_reading", payload.get("bpReading"))
        if (systolic is None or diastolic is None) and reading:
            parsed = parse_bp_reading(str(reading))
            if parsed is None:
                raise ValueError("Blood pressure must look like 120/80")
            payload["systolic_bp"] = parsed[0]
            payload["diastolic_bp"] = parsed[1]
        return payload

    @model_validator(mode="after")
    def _require_blood_pressure(self) -> "DiabetesSchema":
        if self.systolic_bp is None or self.diastolic_bp is None:
            raise ValueError(
                "Blood pressure is required as 120/80 or systolic_bp and diastolic_bp"
            )
        return self


class HeartDiseaseSchema(BaseModel):
    """Inputs for the XGBoost heart-disease model in artifacts/base/heart_disease."""

    age_category: str | None = Field(
        default=None,
        validation_alias=AliasChoices("age_category", "ageCategory"),
    )
    age: int | None = None
    sex: str
    bmi: float
    gen_health: str = Field(
        validation_alias=AliasChoices("gen_health", "genHealth")
    )
    diabetic: str
    smoking: str
    stroke: str
    diff_walking: str = Field(
        validation_alias=AliasChoices("diff_walking", "diffWalking")
    )
    physical_health: float = Field(
        validation_alias=AliasChoices("physical_health", "physicalHealth")
    )

    @model_validator(mode="after")
    def _require_age(self) -> "HeartDiseaseSchema":
        if not self.age_category and self.age is None:
            raise ValueError("Provide age_category or age")
        return self


HeartScehema = HeartDiseaseSchema
