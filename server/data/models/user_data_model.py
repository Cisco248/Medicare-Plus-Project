from sqlalchemy import Column, String
from data.models.base import BASE


class UserModel(BASE):
    __tablename__ = "user"

    id = Column(String(36), primary_key=True, index=True)
    name = Column(String(50), nullable=False)
    email = Column(String(50), unique=True, nullable=False, index=True)
    mobnum = Column(String(15))
    password = Column(String(255), nullable=False)
