import logging
from typing import List
from langchain_chroma import Chroma
from langchain_core.documents import Document
from dotenv import load_dotenv

from .local_db import LocalDatabase

load_dotenv()
logger = logging.getLogger(__name__)


class VectorStoreManager:
    @staticmethod
    def manager(documents: List[Document]) -> Chroma:
        try:
            logger.info(f"VECTOR STORE MANAGER Execution Stared!")
            db = LocalDatabase()
            db.init(documents)
            return db.get()
        except Exception as e:
            logger.error(f"VECTOR STORE MANAGER: {e}")
            raise
 