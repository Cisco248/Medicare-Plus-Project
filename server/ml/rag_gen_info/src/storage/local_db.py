import logging
import os
from typing import List
from langchain.embeddings import Embeddings
from langchain_chroma import Chroma
from langchain_core.documents import Document
from constants import Settings

logger = logging.getLogger(__name__)


class LocalDB:

    def __init__(
        self,
        documents: List[Document],
        embeded_text,
    ) -> None:
        self.documents = documents
        self.embeded_text = embeded_text
        self.client = Chroma(
            persist_directory=Settings.VECTOR_DB_DIR,
            embedding_function=self.embeded_text,
            collection_name=Settings.COLLECTION_NAME,
        )

    def init_db(self) -> None:
        if os.path.exists(Settings.VECTOR_DB_DIR):
            logger.info(f"[VECTOR DB]: DB Exists!")
            self.client.add_documents(documents=self.documents)
        else:
            logger.info(f"[VECTOR DB]: Created Successfully!")
            self.client.from_documents(
                documents=self.documents,
                embedding=self.embeded_text,
                persist_directory=Settings.VECTOR_DB_DIR,
                collection_name=Settings.COLLECTION_NAME,
            )
        logger.info(f"[VECTOR DB]: {len(self.documents)} Chunks Stored.")

    def get_db(self) -> Chroma:
        return self.client
