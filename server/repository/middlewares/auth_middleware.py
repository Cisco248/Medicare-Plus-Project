import uuid
from datetime import datetime
from typing import List

import jwt
from fastapi import Depends, Header, HTTPException
from sqlalchemy.orm import Session

from core import AuthString, EncryptionUtility, ServerSettings, TokenGenerator, get_db
from data import UserCreate, UserLogin, UserModel
from data.models.patient_clinical_model import (
    PatientConditionModel,
    PatientMedicationModel,
)
from data.schemas.patient_profile_schema import PatientProfileUpdate
from repository.models.auth_response import (
    AuthResponse,
    PatientConditionOut,
    PatientMedicationOut,
)

setting = ServerSettings()


def _conditions(db: Session, user_id: str) -> list[PatientConditionOut]:
    rows = (
        db.query(PatientConditionModel)
        .filter(PatientConditionModel.user_id == user_id)
        .all()
    )
    return [
        PatientConditionOut(
            code=row.code,
            label=row.label,
            notes=row.notes,
            diagnosed_at=row.diagnosed_at,
        )
        for row in rows
    ]


def _medications(db: Session, user_id: str) -> list[PatientMedicationOut]:
    rows = (
        db.query(PatientMedicationModel)
        .filter(PatientMedicationModel.user_id == user_id)
        .all()
    )
    return [
        PatientMedicationOut(
            name=row.name,
            dosage=row.dosage,
            frequency=row.frequency,
            started_at=row.started_at,
            ended_at=row.ended_at,
        )
        for row in rows
    ]


def user_to_auth_response(
    user: UserModel,
    token: str,
    db: Session | None = None,
) -> AuthResponse:
    conditions = _conditions(db, str(user.id)) if db is not None else []
    medications = _medications(db, str(user.id)) if db is not None else []
    return AuthResponse(
        token=token,
        id=str(user.id),
        name=str(user.name),
        email=str(user.email),
        mobnum=user.mobnum,
        date_of_birth=user.date_of_birth,
        age=user.age,
        gender=user.gender,
        height_cm=user.height_cm,
        weight_kg=user.weight_kg,
        blood_group=user.blood_group,
        allergies=user.allergies,
        clinical_history=user.clinical_history,
        emergency_contact=user.emergency_contact,
        emergency_phone=user.emergency_phone,
        address=user.address,
        preferred_language=user.preferred_language,
        medical_notes=user.medical_notes,
        conditions=conditions,
        medications=medications,
    )


def get_current_user(
    db: Session = Depends(get_db),
    x_auth_token: str | None = Header(default=None, alias="X-Auth-Token"),
) -> UserModel:
    if not x_auth_token:
        raise HTTPException(status_code=401, detail=AuthString.NO_TOKEN.value)
    token = TokenGenerator()
    try:
        payload = token.verify_token(setting.JWT_SECRET_KEY, x_auth_token)
    except jwt.PyJWTError:
        raise HTTPException(
            status_code=401, detail=AuthString.FAILED_AUTHORIZATION.value
        )
    user_id = payload.get("id") if isinstance(payload, dict) else None
    if not user_id:
        raise HTTPException(
            status_code=401, detail=AuthString.TOKEN_VERIFICATION.value
        )
    user = db.query(UserModel).filter(UserModel.id == user_id).first()
    if user is None:
        raise HTTPException(status_code=401, detail=AuthString.USER_NOT_FOUND.value)
    return user


class AuthenticationMiddleware:
    @staticmethod
    def auth_middleware(
        data: UserModel | None,
        x_auth_token: str | None = Header(default=None, alias="X-Auth-Token"),
        db: Session | None = None,
    ):
        token = TokenGenerator()
        try:
            if data is None:
                raise HTTPException(status_code=401, detail=AuthString.USER_NOT_FOUND)
            if not x_auth_token:
                raise HTTPException(status_code=401, detail=AuthString.NO_TOKEN.value)
            verify_token = token.verify_token(setting.JWT_SECRET_KEY, x_auth_token)
            if not verify_token:
                raise HTTPException(
                    status_code=401, detail=AuthString.TOKEN_VERIFICATION.value
                )
            token_user_id = (
                verify_token.get("id") if isinstance(verify_token, dict) else None
            )
            if token_user_id and token_user_id != str(data.id):
                raise HTTPException(
                    status_code=403,
                    detail="The authenticated user does not match this profile.",
                )
            return user_to_auth_response(data, x_auth_token, db)
        except HTTPException:
            raise
        except jwt.PyJWTError:
            raise HTTPException(
                status_code=401,
                detail=AuthString.FAILED_AUTHORIZATION.value,
            )

    @staticmethod
    def register_middleware(response: List[UserModel], schema: UserCreate):
        if response:
            raise HTTPException(status_code=409, detail=AuthString.EMAIL_ALREADY_EXISTS.value)
        if not schema.email or not schema.password:
            raise HTTPException(status_code=400, detail=AuthString.FIELD_EMPTY.value)
        return EncryptionUtility.encrypt(schema.password)

    @staticmethod
    def login_middleware(result: UserModel | None, schema: UserLogin, db: Session | None = None) -> AuthResponse:
        token = TokenGenerator()
        if not schema.email or not schema.password:
            raise HTTPException(status_code=400, detail=AuthString.FIELD_EMPTY.value)
        if not result:
            raise HTTPException(status_code=401, detail=AuthString.USER_NOT_FOUND.value)
        if not EncryptionUtility.verify_password(schema.password, str(result.password)):
            raise HTTPException(status_code=401, detail=AuthString.PASSWORD_INCORRECT.value)
        gen_token = token.create_token(setting.JWT_SECRET_KEY, data={"id": result.id})
        return user_to_auth_response(result, gen_token, db)

    @staticmethod
    def update_profile(db: Session, user: UserModel, payload: PatientProfileUpdate) -> AuthResponse:
        scalar_fields = (
            "name",
            "mobnum",
            "date_of_birth",
            "gender",
            "height_cm",
            "weight_kg",
            "blood_group",
            "allergies",
            "clinical_history",
            "emergency_contact",
            "emergency_phone",
            "address",
            "preferred_language",
            "medical_notes",
        )
        updates = payload.model_dump(exclude_unset=True)
        for field in scalar_fields:
            if field in updates:
                setattr(user, field, updates[field])
        user.touch()

        if payload.conditions is not None:
            db.query(PatientConditionModel).filter(
                PatientConditionModel.user_id == user.id
            ).delete()
            for item in payload.conditions:
                db.add(
                    PatientConditionModel(
                        id=str(uuid.uuid4()),
                        user_id=str(user.id),
                        code=item.code,
                        label=item.label,
                        notes=item.notes,
                        diagnosed_at=item.diagnosed_at,
                        created_at=datetime.utcnow(),
                    )
                )
        if payload.medications is not None:
            db.query(PatientMedicationModel).filter(
                PatientMedicationModel.user_id == user.id
            ).delete()
            for item in payload.medications:
                db.add(
                    PatientMedicationModel(
                        id=str(uuid.uuid4()),
                        user_id=str(user.id),
                        name=item.name,
                        dosage=item.dosage,
                        frequency=item.frequency,
                        started_at=item.started_at,
                        ended_at=item.ended_at,
                        created_at=datetime.utcnow(),
                    )
                )
        db.commit()
        db.refresh(user)
        return user_to_auth_response(user, "", db)
