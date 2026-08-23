from datetime import date, datetime
from sqlalchemy import Column, Date, DateTime, Float, String, Text
from data.models.base import BASE


class UserModel(BASE):
    __tablename__ = "user"

    id = Column(String(36), primary_key=True, index=True)
    name = Column(String(50), nullable=False)
    email = Column(String(50), unique=True, nullable=False, index=True)
    mobnum = Column(String(15))
    password = Column(String(255), nullable=False)

    date_of_birth = Column(Date, nullable=True)
    gender = Column(String(20), nullable=True)
    height_cm = Column(Float, nullable=True)
    weight_kg = Column(Float, nullable=True)
    blood_group = Column(String(8), nullable=True)
    allergies = Column(Text, nullable=True)
    clinical_history = Column(Text, nullable=True)
    emergency_contact = Column(String(100), nullable=True)
    emergency_phone = Column(String(20), nullable=True)
    address = Column(String(255), nullable=True)
    preferred_language = Column(String(32), nullable=True)
    medical_notes = Column(Text, nullable=True)
    created_at = Column(DateTime, nullable=True)
    updated_at = Column(DateTime, nullable=True)

    @property
    def age(self) -> int | None:
        born = self.date_of_birth
        if born is None:
            return None
        today = date.today()
        years = today.year - born.year
        if (today.month, today.day) < (born.month, born.day):
            years -= 1
        return years if years >= 0 else None

    def touch(self) -> None:
        self.updated_at = datetime.utcnow()
