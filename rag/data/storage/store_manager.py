import logging
from typing import List
from langchain_chroma import Chroma
from langchain_core.documents import Document
from langchain_core.embeddings import Embeddings

from .local_db import LocalDatabase

logger = logging.getLogger(__name__)


class VectorStoreManager:
    @staticmethod
    def manager(documents: List[Document], embedding: Embeddings) -> tuple[Chroma, str]:
        try:
            logger.info("Synchronizing vector store.")
            return LocalDatabase.sync(documents, embedding)
        except Exception:
            logger.exception("Vector store synchronization failed.")
            raise
