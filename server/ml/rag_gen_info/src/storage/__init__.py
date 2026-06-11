import logging
from typing import List
from langchain_chroma import Chroma
from langchain_core.documents import Document
from dotenv import load_dotenv

from embeddor import DocumentEmbeddor
from .local_db import LocalDB

load_dotenv()

logger = logging.getLogger(__name__)


class VectorStoreManager:
    def __init__(self):
        self.embeddings = DocumentEmbeddor().init_embeddor()

    def manager(self, documents: List[Document]) -> Chroma:
        try:
            logger.info(f"[VECTOR STORE MANAGER]: Execution Stared!")
            db = LocalDB(documents, self.embeddings)
            db.init_db()
            vec_db = db.get_db()
            logger.info(f"[VECTOR STORE MANAGER]: Execution Completed!")
            return vec_db
        except Exception as e:
            logger.error(f"[VECTOR STORE MANAGER]: {e}")
            raise
