from pydantic import BaseModel, ConfigDict


class AuthResponse(BaseModel):
    token: str
    id: str
    name: str
    email: str
    mobnum: str
    password: str


class GetUser(BaseModel):
    id: str
    name: str
    email: str
    mobnum: str
    password: str
