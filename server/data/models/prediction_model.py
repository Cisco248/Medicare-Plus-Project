from sqlalchemy import (
    Column,
    DateTime,
    Float,
    ForeignKey,
    String,
    Text,
    Index,
)

from data.models.base import BASE


class PatientPredictionModel(BASE):
    """Versioned, explainable risk indicator. Never overwritten in place."""

    __tablename__ = "patient_prediction"
    __table_args__ = (Index("ix_prediction_user_generated", "user_id", "generated_at"),)

    id = Column(String(36), primary_key=True)
    user_id = Column(String(36), ForeignKey("user.id"), nullable=False, index=True)
    prediction_type = Column(String(64), nullable=False)
    prediction = Column(Text, nullable=False)
    risk_level = Column(String(32), nullable=False)
    prediction_score = Column(Float, nullable=True)
    model_name = Column(String(80), nullable=False)
    model_version = Column(String(32), nullable=False)
    prompt_version = Column(String(32), nullable=True)
    input_window = Column(String(64), nullable=True)
    generated_at = Column(DateTime, nullable=False)
    expires_at = Column(DateTime, nullable=True)


class PredictionEvidenceModel(BASE):
    __tablename__ = "prediction_evidence"

    id = Column(String(36), primary_key=True)
    prediction_id = Column(
        String(36), ForeignKey("patient_prediction.id"), nullable=False, index=True
    )
    statement = Column(Text, nullable=False)
    metric_type = Column(String(64), nullable=True)
    created_at = Column(DateTime, nullable=False)


class RagDocumentModel(BASE):
    """Authoritative patient-scoped RAG metadata. Chroma is only an index."""

    __tablename__ = "rag_document"
    __table_args__ = (Index("ix_rag_doc_user_type", "user_id", "document_type"),)

    id = Column(String(36), primary_key=True)
    user_id = Column(String(36), ForeignKey("user.id"), nullable=False, index=True)
    document_type = Column(String(64), nullable=False)
    source = Column(String(64), nullable=False)
    source_date = Column(DateTime, nullable=True)
    title = Column(String(200), nullable=True)
    content = Column(Text, nullable=False)
    metadata_json = Column(Text, nullable=True)
    embedding_ref = Column(String(120), nullable=True)
    created_at = Column(DateTime, nullable=False)
    updated_at = Column(DateTime, nullable=False)
