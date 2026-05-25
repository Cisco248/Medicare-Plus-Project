from dataclasses import dataclass, field
import enum


class StatusCode(enum.IntEnum):
    OK = 200
    INTERNAL_SERVER_ERROR = 500


@dataclass
class RootResponse:
    status_code: StatusCode
    message: str
    kwargs: dict = field(default_factory=dict)

    @property
    async def res(cls) -> dict:
        return {
            "Status Code": cls.status_code.value,
            "Title": "Medicare+ API",
            "Description": "API for Medicare+ application",
            "Version": "V1.0.0",
            "Message": cls.message,
        }
