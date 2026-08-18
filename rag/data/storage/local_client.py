import logging
from langchain_chroma import Chroma
from langchain_core.embeddings import Embeddings

from core.configs.configuration import RAGSettings

logger = logging.getLogger(__name__)
settings = RAGSettings()


class LocalClient:
    def __init__(self, embeddings: Embeddings | None = None) -> None:
        self.embeddings = embeddings
        self.client = None

    def build(self):
        try:
            if self.client is None:
                self.client = Chroma(
                    persist_directory=str(settings.VECTOR_DB_DIR),
                    collection_name=settings.COLLECTION_NAME,
                    embedding_function=self.embeddings,
                    collection_metadata={"hnsw:space": "cosine"},
                )
            return self.client
        except Exception:
            logger.exception("Cannot connect to the Chroma database.")
            raise

    def health(self) -> bool:
        try:
            client = self.build()
            client.get(limit=1, include=[])
            return True
        except Exception as e:
            logger.exception(f"{e}")
            return False
