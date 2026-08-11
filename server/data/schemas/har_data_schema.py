from datetime import datetime
from pydantic import BaseModel


class HARDataScheme(BaseModel):
    timestamp: datetime
    x: float
    y: float
    z: float
