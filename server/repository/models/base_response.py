from pydantic import BaseModel


class DiabetesResponse(BaseModel):
    prediction: int
    risk_probability: float
    status: str
