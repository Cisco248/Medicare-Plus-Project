<<<<<<< Updated upstream
import logging
import os
from typing import List
from langchain_chroma import Chroma
from langchain_core.documents import Document
from core import RAGSettings
from .client import ChromaClient

logger = logging.getLogger(__name__)
settings = RAGSettings()


class LocalDatabase:
    @staticmethod
    def init(documents: List[Document]) -> None:
        client = ChromaClient().build()

        if not os.path.exists(settings.VECTOR_DB_DIR):
            os.makedirs(settings.VECTOR_DB_DIR, exist_ok=True)
            logger.info(f"<--- VECTOR DB Created --->")

            client.from_documents(
                documents=documents,
                persist_directory=f"{settings.VECTOR_DB_DIR}",
                collection_name=settings.COLLECTION_NAME,
            )

        else:
            logger.info(f"<-- VECTOR DB Exists --->")
            client.add_documents(documents=documents)

        logger.info(f"VECTOR DB {len(documents)} Chunks Stored.")

    @staticmethod
    def get() -> Chroma:
        client = ChromaClient().build()
        return client
=======
import logging
import os
from typing import List
from langchain_chroma import Chroma
from langchain_core.documents import Document
from core import RAGSettings
from .client import ChromaClient

logger = logging.getLogger(__name__)
settings = RAGSettings()


class LocalDatabase:
    @staticmethod
    def init(documents: List[Document]) -> None:
        client = ChromaClient().build()

        if not os.path.exists(settings.VECTOR_DB_DIR):
            os.makedirs(settings.VECTOR_DB_DIR, exist_ok=True)
            logger.info(f"<--- VECTOR DB Created --->")

            client.from_documents(
                documents=documents,
                persist_directory=f"{settings.VECTOR_DB_DIR}",
                collection_name=settings.COLLECTION_NAME,
            )

        else:
            logger.info(f"<-- VECTOR DB Exists --->")
            client.add_documents(documents=documents)

        logger.info(f"VECTOR DB {len(documents)} Chunks Stored.")

    @staticmethod
    def get() -> Chroma:
        client = ChromaClient().build()
        return client
>>>>>>> Stashed changes
