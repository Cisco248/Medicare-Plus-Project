import logging
from fastapi import APIRouter, HTTPException, Request as FastAPIRequest, status

from core.api.ready import require_ready
from data import EDocRequest, compose_edoc_question

e_doc_router = APIRouter(tags=["E Doc"])
logger = logging.getLogger("E-Doc-Ask")


@e_doc_router.post("/e-doc", status_code=status.HTTP_200_OK)
def generate(model: EDocRequest, request: FastAPIRequest):
    pipeline = require_ready(request)
    try:
        question = compose_edoc_question(model)
        return pipeline.invoke(question)
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc
