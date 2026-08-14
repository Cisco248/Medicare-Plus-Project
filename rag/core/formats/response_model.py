from enum import Enum
from typing import Any

from pydantic import BaseModel


class _ResponseStatus(Enum):
    SUCCESS = "Success"
    ERROR = "Error"
    NOT_FOUND = "Not Found"
    UNAUTHORIZED = "Unauthorized"
    FORBIDDEN = "Forbidden"


class _ResponseCode(Enum):
    SUCCESS = 200
    BAD_REQUEST = 400
    UNAUTHORIZED = 401
    FORBIDDEN = 403
    NOT_FOUND = 404
    INTERNAL_SERVER_ERROR = 500


class ResponseModel(BaseModel):
    status_code: _ResponseCode
    status: _ResponseStatus
    title: str = "Medicare+ RAG API"
    description: str = "Medicare Retrieve Augmented Generative System"
    version: str = "V1.0"
    message: str | None
    body: Any | None
