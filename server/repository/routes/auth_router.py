import uuid

from sqlalchemy.orm import Session
from core.constants.config import DB_URL, JWT_SECRET_KEY
from data.models.userModel import UserModel
from core.utils.encrypt_generator import EncryptionUtility
from fastapi import APIRouter, HTTPException, Depends
from core.utils.dbConnection import DatabaseConnection
from data.schemas.userScheme import UserCreate, UserLogin
from repository.middlewares.authMiddleware import auth_middleware
from core.utils.token_generator import TokenGenerator

router = APIRouter()
db = DatabaseConnection(DB_URL)
db.init_db()


@router.post("/register", status_code=200)
def SignUp(schema: UserCreate, db: Session = Depends(db.get_db)):
    data = db.query(UserModel).filter(UserModel.email == schema.email).all()
    if data:
        raise HTTPException(status_code=400, detail="Email Already Registered!")

    if not schema.password:
        raise HTTPException(status_code=400, detail="Passwords is Empty!")

    encrypt_pw = EncryptionUtility.encrypt(schema.password)
    user = UserModel(
        id=str(uuid.uuid4()),
        fname=schema.fname,
        lname=schema.lname,
        email=schema.email,
        mobnum=schema.mobnum,
        password=encrypt_pw,
    )

    db.add(user)
    db.commit()
    db.refresh(user)
    return user


@router.post("/login", status_code=200)
def SignIn(schema: UserLogin, db: Session = Depends(db.get_db)):
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
            "fname": data.fname,
            "lname": data.lname,
            "email": data.email,
            "mobnum": data.mobnum,
        },
    }


@router.get("/get-data", status_code=200)
def GetData(db: Session = Depends(db.get_db), user_dict=Depends(auth_middleware)):
    user = db.query(UserModel).filter(UserModel.id == user_dict["uid"]).first()

    if not user:
        raise HTTPException(status_code=404, detail="User Not Found!")

    return user
