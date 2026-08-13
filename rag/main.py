import logging
import logging.config
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request
from core import LOGGER, RAGSettings, router, health_router, e_doc_router, knowledge_router
from domain import setup_rag_system

logging.config.dictConfig(LOGGER)
logger = logging.getLogger(__name__)
settings = RAGSettings()


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("Starting RAG system...")
    app.state.rag = setup_rag_system(f"{settings.FILE_LOCATION}/sample.pdf")
    logger.info("RAG system loaded successfully")
    yield

    logger.info("Shutting down RAG system...")
    app.state.rag = None


app = FastAPI(title="RAG System API", version="1.0", lifespan=lifespan)


def get_rag(request: Request):
    return request.app.state.rag


app.include_router(router, prefix="/api")
app.include_router(e_doc_router, prefix="/api")
app.include_router(knowledge_router, prefix="/api")
app.include_router(health_router)
