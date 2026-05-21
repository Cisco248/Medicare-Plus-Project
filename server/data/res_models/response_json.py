import enum


class StatusCode(enum.IntEnum):
    OK = 200
    INTERNAL_SERVER_ERROR = 500


def get_response_json(status_code: StatusCode, message: str) -> dict:
    return {
        "Status Code": status_code,
        "Title": "Medicare+ API",
        "Description": "API for Medicare+ application",
        "Version": "V1.0.0",
        "Message": message,
    }
