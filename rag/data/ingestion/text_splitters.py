import logging
from typing import List
from langchain_core.documents import Document
from langchain.embeddings import Embeddings
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
        if not embedding:
            raise
        if is_semantic:
            splitter = SemanticChunker(
                embeddings=embedding,
                breakpoint_threshold_type="percentile",
                breakpoint_threshold_amount=90
                or kwargs.get("breakpoint_threshold_amount"),
            )
        else:
            splitter = RecursiveCharacterTextSplitter(
                chunk_size=400 or kwargs.get("chunk_size"),
                chunk_overlap=50 or kwargs.get("chunk_overlap"),
                separators=["\n\n", "\n", ". ", " ", ""],
            )

        chunks = splitter.split_documents(documents)
        logger.info(f"Generated {len(chunks)} Recursive Chunks.")
        return chunks
