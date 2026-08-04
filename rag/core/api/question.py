from fastapi import APIRouter
from data import Request
from core import RAGSettings
from domain import setup_rag_system

router = APIRouter()
settings = RAGSettings()


@router.post("/ask", status_code=200, tags=["RAG System"])
async def ask_question(req: Request):
    return setup_rag_system(f"{settings.FILE_LOCATION}/sample.pdf").invoke(req.question)
