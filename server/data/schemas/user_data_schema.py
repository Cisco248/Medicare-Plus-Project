from datetime import date
from typing import Optional

from pydantic import AliasChoices, BaseModel, Field


class UserCreate(BaseModel):
    name: str
    email: str
    mobnum: str
    password: str
    date_of_birth: Optional[date] = Field(
        default=None,
        validation_alias=AliasChoices("date_of_birth", "birthDay", "birthday"),
    )
    height_cm: Optional[float] = Field(
        default=None,
        gt=0,
        le=300,
        validation_alias=AliasChoices("height_cm", "height"),
    )
    weight_kg: Optional[float] = Field(
        default=None,
        gt=0,
        le=500,
        validation_alias=AliasChoices("weight_kg", "weight"),
    )


class UserLogin(BaseModel):
    email: str
    password: str
