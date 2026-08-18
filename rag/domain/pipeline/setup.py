import logging
from pathlib import Path
from typing import List

from core.configs.configuration import RAGSettings
from .chain_manager import RAGChainManager
from domain.retriever import HybridRetriever
from data import (
    DocumentLoader,
    DocumentEmbeddor,
    DocumentTextSplitters,
    VectorStoreManager,
)

settings = RAGSettings()
logger = logging.getLogger(__name__)


def _as_file_list(files: List[str] | str | Path | None) -> list[str] | None:
    if files is None:
        return None
    if isinstance(files, (str, Path)):
        return [str(files)]
    return [str(item) for item in files]


def setup_rag_system(
    files: List[str] | str | Path | None = None,
    urls: List[str] | None = None,
):
    try:
        loader = DocumentLoader(documents=_as_file_list(files), urls=urls)
        docs = loader.load()
        if not docs:
            logger.warning("No knowledge documents loaded; RAG is not ready.")
            return RAGChainManager.build_chain(None, index_version="empty")

        embeddor = DocumentEmbeddor()
        model = embeddor.load()
        splitter = DocumentTextSplitters(
            model,
            semantic=False,
            chunk_size=settings.CHUNK_SIZE,
            chunk_overlap=settings.CHUNK_OVERLAP,
        )
        chunks = splitter.load(docs)
        if not chunks:
            logger.warning("Knowledge documents produced no chunks; RAG is not ready.")
            return RAGChainManager.build_chain(None, index_version="empty")

        storage_manager = VectorStoreManager(chunks, model)
        vector_store, index_version = storage_manager.manager()
        retriever = HybridRetriever.build(
            vector_store,
            chunks,
            k=settings.RETRIEVER_K,
            vector_candidate_k=settings.VECTOR_CANDIDATE_K,
            similarity_threshold=settings.SIMILARITY_THRESHOLD,
            bm25_weight=settings.BM25_WEIGHT,
            bm25_min_match_ratio=settings.BM25_MIN_MATCH_RATIO,
            rrf_k=settings.RRF_K,
        )
        return RAGChainManager.build_chain(retriever, index_version=index_version)
    except Exception:
        logger.exception("RAG setup failed; serving in not-ready mode.")
        return RAGChainManager.build_chain(None, index_version="empty")
