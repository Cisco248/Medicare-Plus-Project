from datetime import date
from typing import Optional

from pydantic import BaseModel, Field, field_validator


KNOWN_CONDITION_CODES = {
    "hypertension",
    "diabetes",
    "cardiovascular_disease",
    "chronic_kidney_disease",
    "asthma",
    "copd",
    "obesity",
    "smoking",
    "stroke",
    "other",
}


class PatientConditionSchema(BaseModel):
    code: str
    label: str
    notes: Optional[str] = None
    diagnosed_at: Optional[date] = None

    @field_validator("code")
    @classmethod
    def validate_code(cls, value: str) -> str:
        code = value.strip().lower()
        if code not in KNOWN_CONDITION_CODES:
            raise ValueError(
                "Unknown condition code. Use one of: "
                + ", ".join(sorted(KNOWN_CONDITION_CODES))
            )
        return code


class PatientMedicationSchema(BaseModel):
    name: str
    dosage: Optional[str] = None
    frequency: Optional[str] = None
    started_at: Optional[date] = None
    ended_at: Optional[date] = None


class PatientProfileUpdate(BaseModel):
    name: Optional[str] = None
    mobnum: Optional[str] = None
    date_of_birth: Optional[date] = None
    gender: Optional[str] = None
    height_cm: Optional[float] = Field(default=None, gt=0, le=300)
    weight_kg: Optional[float] = Field(default=None, gt=0, le=500)
    blood_group: Optional[str] = None
    allergies: Optional[str] = None
    clinical_history: Optional[str] = None
    emergency_contact: Optional[str] = None
    emergency_phone: Optional[str] = None
    address: Optional[str] = None
    preferred_language: Optional[str] = None
    medical_notes: Optional[str] = None
    conditions: Optional[list[PatientConditionSchema]] = None
    medications: Optional[list[PatientMedicationSchema]] = None
