import jwt
from fastapi import Header
from datetime import datetime, timedelta


class TokenGenerator:
    def __init__(self):
        self.x_auth_token = Header()

    def create_token(
        self,
        secret_key: str,
        data: dict,
        algorithm: str = "HS256",
        expire: timedelta = timedelta(hours=2),
    ) -> str:
        payload = {
            "id": data.get("id"),
            "exp": datetime.utcnow() + expire,
        }
        return jwt.encode(payload, secret_key, algorithm)

    def verify_token(self, secret_key: str, algorithm: str = "HS256"):
        return jwt.decode(
            self.x_auth_token,
            secret_key,
            algorithm,
            verify=True,
        )
