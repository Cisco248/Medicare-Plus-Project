import logging
from pathlib import Path

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
SUPPORTED_EXTENSIONS = {".txt", ".pdf", ".docx"}


def _knowledge_files(location: str | Path | None) -> list[Path]:
    requested = Path(location) if location is not None else settings.FILE_LOCATION
    if requested.is_file() and requested.suffix.lower() in SUPPORTED_EXTENSIONS:
        return [requested]

    directory = requested if requested.is_dir() else settings.FILE_LOCATION
    if not directory.exists():
        return []
    return sorted(
        path
        for path in directory.rglob("*")
        if path.is_file() and path.suffix.lower() in SUPPORTED_EXTENSIONS
    )


def setup_rag_system(file_path: str | Path | None = None):
    files = _knowledge_files(file_path)
    if not files:
        logger.warning(
            "No supported knowledge files found in %s; RAG starts not ready.",
            settings.FILE_LOCATION,
        )
        return RAGChainManager.build_chain(None, index_version="empty")

    documents = []
    for path in files:
        loaded = DocumentLoader.load(str(path))
        for document in loaded:
            document.metadata["source"] = str(path)
        documents.extend(loaded)

    embeddor = DocumentEmbeddor.load_embedding()
    chunks = DocumentTextSplitters.chunk(
        documents,
        embeddor,
        is_semantic=False,
        chunk_size=settings.CHUNK_SIZE,
        chunk_overlap=settings.CHUNK_OVERLAP,
    )

    vector_store, index_version = VectorStoreManager.manager(chunks, embeddor)
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
