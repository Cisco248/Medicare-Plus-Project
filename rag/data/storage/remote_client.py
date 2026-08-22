import logging
import chromadb
from langchain_chroma import Chroma
from langchain_core.embeddings import Embeddings

from core.configs.configuration import RAGSettings

logger = logging.getLogger(__name__)
settings = RAGSettings()


class RemoteClient:
    def __init__(self, embeddings: Embeddings | None = None) -> None:
        self.embeddings = embeddings
        self.client = None

    def build(self) -> Chroma:
        try:
            self.client = chromadb.HttpClient(
                host=settings.CHROMA_HOST, port=settings.CHROMA_PORT
            )
            return Chroma(
                client=self.client,
                collection_name=settings.COLLECTION_NAME,
                embedding_function=self.embeddings,
                collection_metadata={"hnsw:space": "cosine"},
            )
        except Exception:
            logger.exception("Cannot connect to the Chroma database.")
            raise

    def health(self) -> bool:
        try:
            if self.client is not None:
                return bool(self.client.heartbeat() and self.client.get_version())
            self.build().get(limit=1, include=[])
            return True
        except Exception:
            return False
