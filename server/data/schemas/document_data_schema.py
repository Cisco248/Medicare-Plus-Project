from datetime import date
from typing import Optional

from pydantic import BaseModel


class DocumentUpdate(BaseModel):
    title: Optional[str] = None
    doc_type: Optional[str] = None
    description: Optional[str] = None
    report_date: Optional[date] = None


class DocumentStatusUpdate(BaseModel):
    status: str
