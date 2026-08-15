from typing import Any, Dict
import uuid
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from core import ServerSettings, get_db, AuthString
from data import UserCreate, UserLogin, UserModel
from repository import AuthenticationMiddleware

setting = ServerSettings()
auth_router = APIRouter()


@auth_router.post(
    "/register", status_code=200, tags=["Authentication"], include_in_schema=True
)
def sign_up(model: UserCreate, db: Session = Depends(get_db)):
    data = db.query(UserModel).filter(UserModel.email == model.email).all()
    hashed_pw = AuthenticationMiddleware.register_middleware(data, model)
    user = UserModel(
        id=str(uuid.uuid4()),
        name=model.name,
        email=model.email,
        mobnum=model.mobnum,
        password=hashed_pw,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


@auth_router.post("/login", status_code=200, tags=["Authentication"])
def sign_in(model: UserLogin, db: Session = Depends(get_db)) -> Dict[str, Any]:
    data = db.query(UserModel).filter(UserModel.email == model.email).first()
    result = AuthenticationMiddleware.login_middleware(data, model)
    return result.dict()
