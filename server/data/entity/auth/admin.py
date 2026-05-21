from sqlalchemy import Column, String, LargeBinary
from data.models.base import BASE


class AuthEntity(BASE):
    __tablename__ = "auth_admin"

    id = Column(String(36), primary_key=True, index=True)
    fname = Column(String(20), nullable=False)
    lname = Column(String(20), nullable=False)
    email = Column(String(50), unique=True, nullable=False, index=True)
    mobnum = Column(String(15))
    password = Column(LargeBinary, nullable=False)
    conpassword = Column(LargeBinary, nullable=False)
