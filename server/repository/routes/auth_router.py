import uuid
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from core import ServerSettings, get_db, AuthString
from data import UserCreate, UserLogin, UserModel
from repository import AuthenticationMiddleware

setting = ServerSettings()
auth_router = APIRouter()


@auth_router.post(
    "/register",
    status_code=200,
    tags=["Authentication"],
    include_in_schema=True,
)
def sign_up(
    model: UserCreate,
    db: Session = Depends(get_db),
):
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


@auth_router.post(
    "/login",
    status_code=200,
    tags=["Authentication"],
)
def sign_in(
    model: UserLogin,
    db: Session = Depends(get_db),
):
    data = db.query(UserModel).filter(UserModel.email == model.email).first()
    values = AuthenticationMiddleware.login_middleware(data, model)
    return values


@auth_router.get(
    "/profile",
    status_code=200,
    tags=["User"],
)
def profile(
    db: Session = Depends(get_db),
    user_dict=Depends(AuthenticationMiddleware.auth_middleware),
):
    user = db.query(UserModel).filter(UserModel.id == user_dict["uid"]).first()
    if not user:
        raise HTTPException(404, AuthString.USER_NOT_FOUND)
    return user
