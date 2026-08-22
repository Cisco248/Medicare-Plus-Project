import hashlib
import logging
from typing import List
from langchain_chroma import Chroma
from langchain_core.documents import Document
from langchain_core.embeddings import Embeddings

from core.configs.configuration import RAGSettings
from data.storage.client_manager import ClientFactory

logger = logging.getLogger(__name__)
settings = RAGSettings()


class VectorStoreManager:
    def __init__(self, documents: List[Document], embeddings: Embeddings) -> None:
        self.client = None
        self.docs = documents
        self.embeddings = embeddings

    def manager(self) -> tuple[Chroma, str]:
        try:
            logger.info("Synchronizing vector store.")
            client_manager = ClientFactory(self.embeddings)
            client = client_manager.manager()
            return self._sync(client)

        except Exception:
            logger.exception("Vector store synchronization failed.")
            raise

    def _sync(self, client: Chroma) -> tuple[Chroma, str]:
        prepared: list[Document] = []
        current_ids: list[str] = []

        for document in self.docs:
            chunk_id = self._chunk_id(document)
            metadata = dict(document.metadata)
            metadata["chunk_id"] = chunk_id
            prepared.append(
                Document(page_content=document.page_content, metadata=metadata)
            )
            current_ids.append(chunk_id)

        existing_result = client.get(include=[])
        existing_ids = set(existing_result.get("ids", []))
        current_id_set = set(current_ids)
        missing_ids = current_id_set - existing_ids
        stale_ids = existing_ids - current_id_set

        if missing_ids:
            missing_documents = [
                document
                for document, chunk_id in zip(prepared, current_ids)
                if chunk_id in missing_ids
            ]
            ordered_missing_ids = [
                chunk_id for chunk_id in current_ids if chunk_id in missing_ids
            ]
            client.add_documents(
                documents=missing_documents,
                ids=ordered_missing_ids,
            )

        if stale_ids:
            client.delete(ids=sorted(stale_ids))

        index_version = hashlib.sha256(
            "|".join(sorted(current_id_set)).encode("utf-8")
        ).hexdigest()[:16]
        logger.info(
            "Chroma synchronized: %d total, %d added, %d removed.",
            len(current_ids),
            len(missing_ids),
            len(stale_ids),
        )
        return client, index_version

    def _chunk_id(self, document: Document) -> str:
        source = str(document.metadata.get("source", ""))
        page = str(document.metadata.get("page", ""))
        chunk_index = str(document.metadata.get("chunk_index", ""))
        payload = "\x1f".join(
            (source, page, chunk_index, document.page_content.strip())
        )
        return hashlib.sha256(payload.encode("utf-8")).hexdigest()
