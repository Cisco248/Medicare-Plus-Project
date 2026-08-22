import jwt
from typing import List
from fastapi import HTTPException, Header
from core import TokenGenerator, ServerSettings, AuthString, EncryptionUtility
from data import UserCreate, UserLogin, UserModel
from repository.models.auth_response import AuthResponse, GetUser

setting = ServerSettings()


class AuthenticationMiddleware:
    @staticmethod
    def auth_middleware(
        data: UserModel | None,
        x_auth_token: str | None = Header(default=None, alias="X-Auth-Token"),
    ):
        token = TokenGenerator()

        try:
            if data is None:
                raise HTTPException(
                    status_code=401,
                    detail=AuthString.USER_NOT_FOUND,
                )

            if not x_auth_token:
                raise HTTPException(
                    status_code=401,
                    detail=AuthString.NO_TOKEN.value,
                )

            verify_token = token.verify_token(
                setting.JWT_SECRET_KEY,
                x_auth_token,
            )

            if not verify_token:
                raise HTTPException(
                    status_code=401,
                    detail=AuthString.TOKEN_VERIFICATION.value,
                )

            return AuthResponse(
                token=x_auth_token,
                id=str(data.id),
                name=str(data.name),
                email=str(data.email),
                mobnum=str(data.mobnum),
                password=str(data.password),
            )

        except jwt.PyJWTError:
            raise HTTPException(
                status_code=401,
                detail=AuthString.FAILED_AUTHORIZATION.value,
            )

    @staticmethod
    def register_middleware(response: List[UserModel], schema: UserCreate):
        try:
            if response:
                raise HTTPException(500, AuthString.EMAIL_ALREADY_EXISTS.value)
            if not schema.email and schema.password:
                raise HTTPException(500, AuthString.FIELD_EMPTY.value)
            encrypt_pw = EncryptionUtility.encrypt(schema.password)
            return encrypt_pw
        except Exception as e:
            raise Exception(f"{AuthString.MIDDLEWARE_ERROR.value} {e}")

    @staticmethod
    def login_middleware(result: UserModel | None, schema: UserLogin) -> AuthResponse:
        token: TokenGenerator = TokenGenerator()

        try:
            if not schema.email or not schema.password:
                raise HTTPException(401, AuthString.FIELD_EMPTY.value)
            if not result:
                raise HTTPException(401, AuthString.USER_NOT_FOUND.value)
            if not EncryptionUtility.verify_password(
                schema.password, str(result.password)
            ):
                raise HTTPException(404, AuthString.PASSWORD_INCORRECT.value)
            gen_token = token.create_token(
                setting.JWT_SECRET_KEY, data={"id": result.id}
            )
            return AuthResponse(
                token=gen_token,
                id=str(result.id),
                name=str(result.name),
                email=str(result.email),
                mobnum=str(result.mobnum),
                password=str(result.password),
            )

        except Exception as e:
            raise HTTPException(
                status_code=500, detail=f"{AuthString.MIDDLEWARE_ERROR.value}: {e}"
            )
