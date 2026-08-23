import logging
import logging.config
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request
from core import LOGGER, RAGSettings
from core.api import router, health_router, e_doc_router, knowledge_router, har_router
from data import load_knowledge_urls
from domain import setup_rag_system

logging.config.dictConfig(LOGGER)
logger = logging.getLogger(__name__)
settings = RAGSettings()


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("Starting RAG system...")
    app.state.rag = setup_rag_system(
        files=[settings.FILE_LOCATION],
        urls=load_knowledge_urls(settings.KNOWLEDGE_URLS_FILE),
    )
    logger.info("RAG system initialized (ready=%s)", app.state.rag.ready)
    yield

    logger.info("Shutting down RAG system...")
    app.state.rag = None


app = FastAPI(title=settings.APP_NAME, version=settings.APP_VERSION, lifespan=lifespan)


def get_rag(request: Request):
    return request.app.state.rag


app.include_router(router, prefix="/api")
app.include_router(e_doc_router, prefix="/api")
app.include_router(knowledge_router, prefix="/api")
app.include_router(har_router, prefix="/api")
app.include_router(health_router)

# artifacts/base/diabetes/model.pkl'
