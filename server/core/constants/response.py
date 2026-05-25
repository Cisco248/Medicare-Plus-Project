from enum import Enum


class _ResponseStatus(Enum):
    SUCCESS = "Success"
    ERROR = "Error"
    NOT_FOUND = "Not Found"
    UNAUTHORIZED = "Unauthorized"
    FORBIDDEN = "Forbidden"


class _ResponseCode(Enum):
    SUCCESS = 200
    CREATED = 201
    BAD_REQUEST = 400
    UNAUTHORIZED = 401
    FORBIDDEN = 403
    NOT_FOUND = 404
    INTERNAL_SERVER_ERROR = 500


class ResponseMessage:
    def __init__(
        self, status: _ResponseStatus, code: _ResponseCode, message: str
    ) -> None:
        self.status = status
        self.code = code
        self.message = message

    def __str__(self) -> str:
        return (
            f"Response(status={self.status.value}, code={self.code.value}, message={self.message})"
        )
