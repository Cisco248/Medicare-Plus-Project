from datetime import date
from typing import Optional

from pydantic import BaseModel, Field


class PatientConditionOut(BaseModel):
    code: str
    label: str
    notes: Optional[str] = None
    diagnosed_at: Optional[date] = None


class PatientMedicationOut(BaseModel):
    name: str
    dosage: Optional[str] = None
    frequency: Optional[str] = None
    started_at: Optional[date] = None
    ended_at: Optional[date] = None


class AuthResponse(BaseModel):
    token: str
    id: str
    name: str
    email: str
    mobnum: Optional[str] = None
    date_of_birth: Optional[date] = None
    age: Optional[int] = None
    gender: Optional[str] = None
    height_cm: Optional[float] = None
    weight_kg: Optional[float] = None
    blood_group: Optional[str] = None
    allergies: Optional[str] = None
    clinical_history: Optional[str] = None
    emergency_contact: Optional[str] = None
    emergency_phone: Optional[str] = None
    address: Optional[str] = None
    preferred_language: Optional[str] = None
    medical_notes: Optional[str] = None
    conditions: list[PatientConditionOut] = Field(default_factory=list)
    medications: list[PatientMedicationOut] = Field(default_factory=list)


class GetUser(BaseModel):
    id: str
    name: str
    email: str
    mobnum: Optional[str] = None
