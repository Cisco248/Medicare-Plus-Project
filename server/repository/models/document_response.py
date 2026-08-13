from datetime import date, datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict


class DocumentResponse(BaseModel):
    id: str
    user_id: str
    title: str
    doc_type: str
    file_name: str
    file_type: str
    description: Optional[str] = None
    report_date: Optional[date] = None
    status: str
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
