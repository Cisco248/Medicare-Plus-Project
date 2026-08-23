from datetime import datetime

from pydantic import AliasChoices, BaseModel, ConfigDict, Field


class Response(BaseModel):
    answer: str
    recommendations: list[str]
    caution: str


class HealthSummaryResponse(BaseModel):
    model_config = ConfigDict(populate_by_name=True, ser_json_by_alias=True)

    summary: str
    recommendations: list[str] = Field(default_factory=list)
    disclaimer: str
    generated_at: datetime = Field(
        validation_alias=AliasChoices("generated_at", "generatedAt"),
        serialization_alias="generatedAt",
    )
