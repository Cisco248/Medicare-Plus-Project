from datetime import datetime

from sqlalchemy import Column, Date, DateTime, ForeignKey, String, Text

from data.models.base import BASE


class DocumentModel(BASE):
    __tablename__ = "document"

    id = Column(String(36), primary_key=True, index=True)
    user_id = Column(String(36), ForeignKey("user.id"), nullable=False, index=True)
    title = Column(String(100), nullable=False)
    doc_type = Column(String(50), nullable=False)
    file_name = Column(String(255), nullable=False)
    file_path = Column(String(255), nullable=False)
    file_type = Column(String(10), nullable=False)
    description = Column(Text, nullable=True)
    issuer = Column(String(100), nullable=True)
    hospital = Column(String(100), nullable=True)
    report_date = Column(Date, nullable=True)
    status = Column(String(20), nullable=False, default="uploaded")
    created_at = Column(DateTime, nullable=False, default=datetime.utcnow)
    updated_at = Column(
        DateTime,
        nullable=False,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
    )
