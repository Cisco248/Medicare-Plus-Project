import logging
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


def setup_rag_system(files: List[str] | None = None, urls: List[str] | None = None):
    # Setup Document Loader
    loader = DocumentLoader(documents=files, urls=urls)
    docs = loader.load()
    # Load Embedding Model
    embeddor = DocumentEmbeddor()
    model = embeddor.load()
    # Setup Text Splitter
    splitter = DocumentTextSplitters(
        model,
        chunk_size=settings.CHUNK_SIZE,
        chunk_overlap=settings.CHUNK_OVERLAP,
    )
    chunks = splitter.load(docs)
    # Store chunks in vector storage
    storage_manager = VectorStoreManager(chunks, model)
    vector_store, index_version = storage_manager.manager()
    # Setup hybrid retriever
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
