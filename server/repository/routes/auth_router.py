from typing import Any, Dict
import uuid
from datetime import datetime

from fastapi import APIRouter, Depends, Header, Query
from sqlalchemy.orm import Session

from core import get_db
from data import UserCreate, UserLogin, UserModel
from data.schemas.patient_profile_schema import PatientProfileUpdate
from repository.middlewares.auth_middleware import (
    AuthenticationMiddleware,
    get_current_user,
    user_to_auth_response,
)

auth_router = APIRouter()


@auth_router.post(
    "/register",
    status_code=200,
    tags=["Authentication"],
    include_in_schema=True,
    summary="Register a new patient account",
)
def sign_up(model: UserCreate, db: Session = Depends(get_db)):
    data = db.query(UserModel).filter(UserModel.email == model.email).all()
    hashed_pw = AuthenticationMiddleware.register_middleware(data, model)
    now = datetime.utcnow()
    user = UserModel(
        id=str(uuid.uuid4()),
        name=model.name,
        email=model.email,
        mobnum=model.mobnum,
        password=hashed_pw,
        date_of_birth=model.date_of_birth,
        height_cm=model.height_cm,
        weight_kg=model.weight_kg,
        created_at=now,
        updated_at=now,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user_to_auth_response(user, "", db)


@auth_router.post(
    "/login",
    status_code=200,
    tags=["Authentication"],
    summary="Authenticate a patient and return a JWT",
)
def sign_in(model: UserLogin, db: Session = Depends(get_db)) -> Dict[str, Any]:
    data = db.query(UserModel).filter(UserModel.email == model.email).first()
    result = AuthenticationMiddleware.login_middleware(data, model, db)
    return result.model_dump()


@auth_router.post(
    "/profile",
    status_code=200,
    tags=["Authentication"],
    summary="Return the authenticated patient's profile",
)
def profile(
    user_id: str | None = Query(default=None, alias="user_id"),
    userId: str | None = Query(default=None, alias="userId"),
    db: Session = Depends(get_db),
    x_auth_token: str | None = Header(default=None, alias="X-Auth-Token"),
) -> Dict[str, Any]:
    requested = user_id or userId
    if requested:
        data = db.query(UserModel).filter(UserModel.id == requested).first()
    else:
        data = None
    result = AuthenticationMiddleware.auth_middleware(
        data=data, x_auth_token=x_auth_token, db=db
    )
    return result.model_dump()


@auth_router.get(
    "/profile",
    status_code=200,
    tags=["Authentication"],
    summary="Return the authenticated patient's profile using the JWT only",
)
def get_own_profile(
    db: Session = Depends(get_db),
    user: UserModel = Depends(get_current_user),
    x_auth_token: str | None = Header(default=None, alias="X-Auth-Token"),
) -> Dict[str, Any]:
    result = user_to_auth_response(user, x_auth_token or "", db)
    return result.model_dump()


@auth_router.put(
    "/profile",
    status_code=200,
    tags=["Authentication"],
    summary="Update the authenticated patient's clinical profile",
)
def update_profile(
    payload: PatientProfileUpdate,
    db: Session = Depends(get_db),
    user: UserModel = Depends(get_current_user),
    x_auth_token: str | None = Header(default=None, alias="X-Auth-Token"),
) -> Dict[str, Any]:
    result = AuthenticationMiddleware.update_profile(db, user, payload)
    result.token = x_auth_token or ""
    return result.model_dump()
