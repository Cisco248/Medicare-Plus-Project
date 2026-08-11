from pydantic import BaseModel


class Response(BaseModel):
    answer: str
    recommendations: list[str]
    caution: str
