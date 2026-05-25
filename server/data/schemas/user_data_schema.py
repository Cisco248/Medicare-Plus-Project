from pydantic import BaseModel


class UserCreate(BaseModel):
    fname: str
    lname: str
    email: str
    mobnum: str
    password: str


class UserLogin(BaseModel):
    email: str
    password: str
