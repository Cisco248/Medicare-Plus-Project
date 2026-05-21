import jwt
import uuid
import bcrypt
from sqlalchemy.orm import Session

from core.constants.config import DB_URL
from data.entity.auth.client import ClientAuthEntity
from core.utils.hasspassword import hash_password
from fastapi import APIRouter, HTTPException, Depends
from core.utils.dbConnection import DatabaseConnection
from data.schemas.userScheme import UserCreate, UserLogin
from repository.middlewares.authMiddleware import auth_middleware

router = APIRouter()
db = DatabaseConnection(DB_URL)


@router.post("/register", status_code=200)
def SignUp(user: UserCreate, db: Session = Depends(db.set_db)):
    existing_user = (
        db.query(ClientAuthEntity).filter(ClientAuthEntity.email == user.email).all()
    )
    if existing_user:
        raise HTTPException(status_code=400, detail="Email Already Registered!")

    if user.password != user.conpassword:
        raise HTTPException(status_code=400, detail="Passwords Doesn't Match!")

    hashed_pw = hash_password(user.password)

    new_user_db = ClientAuthEntity(
        id=str(uuid.uuid4()),
        fname=user.fname,
        lname=user.lname,
        email=user.email,
        mobnum=user.mobnum,
        password=hashed_pw,
        conpassword=hashed_pw,
    )

    db.add(new_user_db)
    db.commit()
    db.refresh(new_user_db)

    return new_user_db


@router.post("/login", status_code=200)
def SignIn(user: UserLogin, db: Session = Depends(db.set_db)):
    login_user = (
        db.query(ClientAuthEntity).filter(ClientAuthEntity.email == user.email).first()
    )

    if not login_user:
        raise HTTPException(status_code=400, detail="Email Doesn't Exists!")

    if not bcrypt.checkpw(user.password.encode("utf-8"), login_user.password):  # type: ignore
        raise HTTPException(status_code=400, detail="Invalid Password!")

    token = jwt.encode({"id": login_user.id}, "password_key")

    return {"token": token, "user": login_user}


@router.get("/get-data", status_code=200)
def GetData(db: Session = Depends(db.set_db), user_dict=Depends(auth_middleware)):
    user = (
        db.query(ClientAuthEntity)
        .filter(ClientAuthEntity.id == user_dict["uid"])
        .first()
    )

    if not user:
        raise HTTPException(status_code=404, detail="User Not Found!")

    return user
