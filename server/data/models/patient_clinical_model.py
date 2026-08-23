from sqlalchemy import Column, Date, DateTime, ForeignKey, String, Text, UniqueConstraint

from data.models.base import BASE


KNOWN_CONDITIONS = (
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
)


class PatientConditionModel(BASE):
    __tablename__ = "patient_condition"
    __table_args__ = (
        UniqueConstraint("user_id", "code", "label", name="uq_patient_condition"),
    )

    id = Column(String(36), primary_key=True)
    user_id = Column(String(36), ForeignKey("user.id"), nullable=False, index=True)
    code = Column(String(64), nullable=False)
    label = Column(String(120), nullable=False)
    notes = Column(Text, nullable=True)
    diagnosed_at = Column(Date, nullable=True)
    created_at = Column(DateTime, nullable=True)


class PatientMedicationModel(BASE):
    __tablename__ = "patient_medication"

    id = Column(String(36), primary_key=True)
    user_id = Column(String(36), ForeignKey("user.id"), nullable=False, index=True)
    name = Column(String(120), nullable=False)
    dosage = Column(String(80), nullable=True)
    frequency = Column(String(80), nullable=True)
    started_at = Column(Date, nullable=True)
    ended_at = Column(Date, nullable=True)
    created_at = Column(DateTime, nullable=True)
