from dataclasses import dataclass
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


class ResponseMessage(BaseModel):
    status: _ResponseStatus = _ResponseStatus.SUCCESS
    code: _ResponseCode = _ResponseCode.SUCCESS
    title: str = "Medicare+ API"
    description: str = "API for Medicare+ application"
    version: str = "V1.0.0"
    token: str = "None"
    body: Any = None
