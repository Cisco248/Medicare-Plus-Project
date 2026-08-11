from core import RAGSettings
from .chain_manager import RAGChainManager
from domain.retriever import HybridRetriever
from data import (
    DocumentLoader,
    DocumentEmbeddor,
    DocumentTextSplitters,
    VectorStoreManager,
)

settings = RAGSettings()


def setup_rag_system(file_path: str):
    documents = DocumentLoader.load(file_path)
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

    return RAGChainManager.build_chain(retriever)
