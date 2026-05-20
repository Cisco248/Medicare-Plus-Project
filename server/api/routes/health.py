from fastapi import APIRouter

from res_models import StatusCode, get_response_json

router = APIRouter(tags=["Health"])


@router.get("/", status_code=200)
def read_root():
    return get_response_json(
        status_code=StatusCode.OK,
        message="Welcome to the Medicare+ API!",
    )


@router.get("/health", status_code=200)
def health_check():
    return get_response_json(
        status_code=StatusCode.OK,
        message="API is healthy.",
    )
