import logging
from typing import List
from langchain_core.documents import Document

from .recursive import RecursiveTextSplitter
from .semantic import SemanticTextSplitter

logger = logging.getLogger(__name__)


class DocumentChunker:
    def __init__(
        self,
        is_semantic: bool = True,
        chunk_size: int = 400,
        chunk_overlap: int = 50,
        breakpoint_threshold_amount: int = 90,
    ):
        self.is_semantic = is_semantic
        self.chunk_size = chunk_size
        self.chunk_overlap = chunk_overlap
        self.breakpoint_threshold_amount = breakpoint_threshold_amount

    def chunk(
        self,
        documents: List[Document],
        embeddings,
    ) -> List[Document]:
        result = embeddings.embed_query("Hello world")
        print(len(result))
        if self.is_semantic:
            logger.info("[SEMANTIC CHUNKER]: Started!")
            splitter = SemanticTextSplitter(
                embeddings,
                self.breakpoint_threshold_amount,
            ).split()
        else:
            logger.info("[RECURSIVE CHUNKER]: Started!")
            splitter = RecursiveTextSplitter(
                self.chunk_size,
                self.chunk_overlap,
            ).split()

        chunks = splitter.split_documents(documents)
        logger.info(f"Generated {len(chunks)} Recursive Chunks.")
        return chunks
