from fastapi import HTTPException, Header
import jwt

from core.utils.token_generator import TokenGenerator
from core.constants.config import JWT_SECRET_KEY


def auth_middleware(x_auth_token=Header()):
    try:
        if not x_auth_token:
            raise HTTPException(status_code=401, detail="No auth token, Access Denied!")

        verify_token = TokenGenerator(JWT_SECRET_KEY).verify_token(x_auth_token)

        if not verify_token:
            raise HTTPException(
                status_code=401,
                detail="Token verification failed, Authorization Error!",
            )

        uid = verify_token.get("id")
        return {"uid": uid, "token": x_auth_token}

    except jwt.PyJWTError:
        raise HTTPException(
            status_code=401, detail="Authorization Failed, Token is Not Valid"
        )
