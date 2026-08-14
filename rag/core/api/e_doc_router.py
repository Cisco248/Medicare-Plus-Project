import logging
from fastapi import APIRouter, HTTPException, Request as FastAPIRequest, status

from data import Request

e_doc_router = APIRouter(tags=["E Doc"])
logger = logging.getLogger("E-Doc-Ask")


@e_doc_router.post("/e-doc", status_code=status.HTTP_200_OK)
def generate(model: Request, request: FastAPIRequest):
    """Answer an E-Doc question using the already initialized knowledge index."""
    try:
        return request.app.state.rag.invoke(model.question)
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc
