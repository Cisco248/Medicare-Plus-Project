import jwt
from typing import List
from fastapi import HTTPException, Header
from core import TokenGenerator, ServerSettings, AuthString, EncryptionUtility
from data import UserCreate, UserLogin, UserModel

setting = ServerSettings()


class AuthenticationMiddleware:
    @staticmethod
    def auth_middleware(x_auth_token=Header(), token=TokenGenerator()):
        try:
            verify_token = token.verify_token(setting.JWT_SECRET_KEY, x_auth_token)
            if not x_auth_token:
                raise HTTPException(401, AuthString.NO_TOKEN.value)
            if not verify_token:
                raise HTTPException(401, AuthString.TOKEN_VERIFICATION.value)
            return {
                "uid": verify_token.get("id"),
                "token": x_auth_token,
            }
        except jwt.PyJWTError:
            raise HTTPException(401, AuthString.FAILED_AUTHORIZATION.value)

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
    def login_middleware(
        response: UserModel | None,
        schema: UserLogin,
        token: TokenGenerator = TokenGenerator(),
    ):
        try:
            if not schema.email or not schema.password:
                raise HTTPException(401, AuthString.FIELD_EMPTY.value)
            if not response:
                raise HTTPException(401, AuthString.USER_NOT_FOUND.value)
            if not EncryptionUtility.verify_password(
                schema.password, str(response.password)
            ):
                raise HTTPException(404, AuthString.PASSWORD_INCORRECT.value)
            gen_token = token.create_token(
                setting.JWT_SECRET_KEY, data={"id": response.id}
            )
            return gen_token

        except Exception as e:
            raise HTTPException(
                status_code=500, detail=f"{AuthString.MIDDLEWARE_ERROR.value}: {e}"
            )
