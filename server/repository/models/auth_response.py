from pydantic import BaseModel, ConfigDict


class AuthResponse(BaseModel):
    token: str
    id: str
    name: str
    email: str
    mobnum: str
    password: str

    model_config = ConfigDict(from_attributes=True)
