import logging
from typing import List
from langchain_core.documents import Document
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_experimental.text_splitter import SemanticChunker

logger = logging.getLogger(__name__)


class DocumentTextSplitters:
    @staticmethod
    def chunk(
        documents: List[Document],
        embedding,
        is_semantic: bool = True,
        **kwargs,
    ) -> List[Document]:
        logger.info("Document Splitting Started!")
        if is_semantic:
            if embedding is None:
                raise ValueError(
                    "An embedding model is required for semantic chunking."
                )
            splitter = SemanticChunker(
                embeddings=embedding,
                breakpoint_threshold_type="percentile",
                breakpoint_threshold_amount=kwargs.get(
                    "breakpoint_threshold_amount", 90
                ),
            )
        else:
            splitter = RecursiveCharacterTextSplitter(
                chunk_size=kwargs.get("chunk_size", 500),
                chunk_overlap=kwargs.get("chunk_overlap", 50),
                separators=["\n\n", "\n", ". ", " ", ""],
            )

        chunks = splitter.split_documents(documents)
        source_chunk_indexes: dict[str, int] = {}
        for chunk in chunks:
            source = str(chunk.metadata.get("source", "unknown"))
            chunk_index = source_chunk_indexes.get(source, 0)
            chunk.metadata["chunk_index"] = chunk_index
            source_chunk_indexes[source] = chunk_index + 1

        logger.info("Generated %d chunks.", len(chunks))
        return chunks
