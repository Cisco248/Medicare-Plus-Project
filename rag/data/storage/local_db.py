import hashlib
import logging
from typing import List
from langchain_chroma import Chroma
from langchain_core.documents import Document
from langchain_core.embeddings import Embeddings
from .client import ChromaClient

logger = logging.getLogger(__name__)


class LocalDatabase:
    @staticmethod
    def chunk_id(document: Document) -> str:
        source = str(document.metadata.get("source", ""))
        page = str(document.metadata.get("page", ""))
        chunk_index = str(document.metadata.get("chunk_index", ""))
        payload = "\x1f".join(
            (source, page, chunk_index, document.page_content.strip())
        )
        return hashlib.sha256(payload.encode("utf-8")).hexdigest()

    @staticmethod
    def sync(documents: List[Document], embedding: Embeddings) -> tuple[Chroma, str]:
        """Synchronize the collection and embed only new or changed chunks."""
        vector_store = ChromaClient(embedding).build()
        prepared: list[Document] = []
        current_ids: list[str] = []

        for document in documents:
            chunk_id = LocalDatabase.chunk_id(document)
            metadata = dict(document.metadata)
            metadata["chunk_id"] = chunk_id
            prepared.append(
                Document(page_content=document.page_content, metadata=metadata)
            )
            current_ids.append(chunk_id)

        existing_result = vector_store.get(include=[])
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
            vector_store.add_documents(
                documents=missing_documents,
                ids=ordered_missing_ids,
            )

        if stale_ids:
            vector_store.delete(ids=sorted(stale_ids))

        index_version = hashlib.sha256(
            "|".join(sorted(current_id_set)).encode("utf-8")
        ).hexdigest()[:16]
        logger.info(
            "Chroma synchronized: %d total, %d added, %d removed.",
            len(current_ids),
            len(missing_ids),
            len(stale_ids),
        )
        return vector_store, index_version
