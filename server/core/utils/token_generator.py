import jwt
from datetime import datetime, timedelta


class TokenGenerator:
    def __init__(self, secret_key: str, algorithm: str = "HS256"):
        self.secret_key = secret_key
        self.algorithm = algorithm

    def create_token(self, data: dict, expire: timedelta = timedelta(hours=2)) -> str:
        payload = {
            "id": data.get("id"),
            "exp": datetime.utcnow() + expire,
        }

        return jwt.encode(payload, self.secret_key, self.algorithm)
