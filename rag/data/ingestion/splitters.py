import logging
from typing import List
from langchain.embeddings import Embeddings
from langchain_core.documents import Document
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_experimental.text_splitter import SemanticChunker

from data.ingestion.knowledge_metadata import context_prefix, metadata_for_source

logger = logging.getLogger(__name__)


class DocumentTextSplitters:
    def __init__(
        self, model: Embeddings | None = None, semantic: bool = False, **kwargs
    ) -> None:
        self.model = model
        self.semantic = semantic
        self.kwargs = kwargs

    def load(
        self,
        documents: List[Document],
    ) -> List[Document]:
        logger.info("Document Splitting Started!")
        if self.semantic:
            return self._semantic_chunker(documents)
        else:
            return self._recursive_text_splitter(documents)

    def _recursive_text_splitter(self, doc) -> List[Document]:
        splitter = RecursiveCharacterTextSplitter(
            chunk_size=self.kwargs.get("chunk_size", 500),
            chunk_overlap=self.kwargs.get("chunk_overlap", 50),
            separators=["\n## ", "\n# ", "\n\n", "\n", ". ", " ", ""],
        )
        chunks = splitter.split_documents(doc)
        source_chunk_indexes: dict[str, int] = {}
        for chunk in chunks:
            source = str(chunk.metadata.get("source", "unknown"))
            chunk_index = source_chunk_indexes.get(source, 0)
            chunk.metadata["chunk_index"] = chunk_index
            source_chunk_indexes[source] = chunk_index + 1
            self._stamp_chunk(chunk)
        logger.info("Generated %d chunks.", len(chunks))
        return chunks

    @staticmethod
    def _stamp_chunk(chunk: Document) -> None:
        source = str(chunk.metadata.get("source", ""))
        extra = metadata_for_source(source)
        for key, value in extra.items():
            chunk.metadata.setdefault(key, value)
        prefix = context_prefix(
            {
                key: str(chunk.metadata[key])
                for key in (
                    "disease",
                    "parameter",
                    "model",
                    "category",
                    "topic",
                )
                if key in chunk.metadata
            }
        )
        text = chunk.page_content.strip()
        if prefix and not text.startswith("Medicare Plus educational knowledge."):
            chunk.page_content = f"{prefix}\n\n{text}"

    def _semantic_chunker(self, doc) -> List[Document]:
        if self.model is None:
            raise ValueError("An embedding model is required for semantic chunking.")
        splitter = SemanticChunker(
            embeddings=self.model,
            breakpoint_threshold_type="percentile",
            breakpoint_threshold_amount=self.kwargs.get(
                "breakpoint_threshold_amount", 90
            ),
        )
        chunks = splitter.split_documents(doc)
        source_chunk_indexes: dict[str, int] = {}
        for chunk in chunks:
            source = str(chunk.metadata.get("source", "unknown"))
            chunk_index = source_chunk_indexes.get(source, 0)
            chunk.metadata["chunk_index"] = chunk_index
            source_chunk_indexes[source] = chunk_index + 1
            self._stamp_chunk(chunk)
        logger.info("Generated %d chunks.", len(chunks))
        return chunks
