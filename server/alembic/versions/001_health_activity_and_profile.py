"""Health activity, patient profile, prediction, and RAG metadata tables.

Revision ID: 001_har_profile
This file documents the schema introduced for the Health Activity Record
pipeline. Runtime still uses SQLAlchemy create_all plus SchemaMiddleware
ALTERs so existing Docker volumes keep working without a manual upgrade step.
"""

REVISION = "001_har_profile"
DOWN_REVISION = None


def upgrade() -> None:
    """create_all() creates these tables on first boot.

    New tables:
    - patient_condition
    - patient_medication
    - health_activity_record
    - health_activity_daily_summary
    - patient_prediction
    - prediction_evidence
    - rag_document

    Modified table:
    - user: date_of_birth, gender, height_cm, weight_kg, blood_group,
      allergies, clinical_history, emergency_contact, emergency_phone,
      address, preferred_language, medical_notes, created_at, updated_at
    """


def downgrade() -> None:
    """Drop the HAR / profile tables. User profile columns are left in place."""
