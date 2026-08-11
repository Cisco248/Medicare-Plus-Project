import logging
from fastapi import APIRouter, status

from data import (
    DocumentLoader,
    DocumentEmbeddor,
    DocumentTextSplitters,
    VectorStoreManager,
)
from domain import RAGChainManager, HybridRetriever
from core import RAGSettings

e_doc_router = APIRouter(tags=["E Doc"])
logger = logging.getLogger("E-Doc-Ask")
settings = RAGSettings()


@e_doc_router.post("/e-doc", status_code=status.HTTP_200_OK)
def generate(model):
    documents = DocumentLoader.load("file_path")
    embeddor = DocumentEmbeddor.load_embedding(documents)
    chunks = DocumentTextSplitters.chunk(
        documents,
        embeddor,
        is_semantic=False,
        chunk_size=settings.CHUNK_SIZE,
        chunk_overlap=settings.CHUNK_OVERLAP,
    )

    vector_store = VectorStoreManager.manager(chunks)
    retriever = HybridRetriever.build(vector_store, chunks, settings.RETRIEVER_K)
    response = RAGChainManager.build_chain(retriever)

    # We have to implement the code
    return response.invoke(model)
