import uuid
from sqlalchemy.orm import Session
from core.constants.config import JWT_SECRET_KEY
from data.models.user_data_model import UserModel
from core.utils.encrypt_generator import EncryptionUtility
from fastapi import APIRouter, HTTPException, Depends
from data.schemas.user_data_schema import UserCreate, UserLogin
from repository.middlewares.authMiddleware import auth_middleware
from core.utils.token_generator import TokenGenerator
from core.utils.dbConnection import get_db

router = APIRouter()


@router.post("/register", status_code=200)
def SignUp(schema: UserCreate, db: Session = Depends(get_db)):
    data = db.query(UserModel).filter(UserModel.email == schema.email).all()
    if data:
        raise HTTPException(status_code=400, detail="Email Already Registered!")

    if not schema.password:
        raise HTTPException(status_code=400, detail="Passwords is Empty!")

    encrypt_pw = EncryptionUtility.encrypt(schema.password)
    user = UserModel(
        id=str(uuid.uuid4()),
        name=schema.name,
        email=schema.email,
        mobnum=schema.mobnum,
        password=encrypt_pw,
    )

    db.add(user)
    db.commit()
    db.refresh(user)
    return user


@router.post("/login", status_code=200)
def SignIn(schema: UserLogin, db: Session = Depends(get_db)):
    data = db.query(UserModel).filter(UserModel.email == schema.email).first()
    if not data:
        raise HTTPException(status_code=400, detail="Email Doesn't Exists!")

    if not EncryptionUtility.verify_password(schema.password, data.password):  # type: ignore
        raise HTTPException(status_code=400, detail="Password Incorrect!")

    token = TokenGenerator(secret_key=JWT_SECRET_KEY).create_token(data={"id": data.id})

    return {
        "token": token,
        "user": {
            "id": data.id,
            "name": data.name,
            "email": data.email,
            "mobnum": data.mobnum,
            "password": data.password,
        },
    }


@router.get("/profile", status_code=200)
def Profile(db: Session = Depends(get_db), user_dict=Depends(auth_middleware)):
    user = db.query(UserModel).filter(UserModel.id == user_dict["uid"]).first()

    if not user:
        raise HTTPException(status_code=404, detail="User Not Found!")

    return user
