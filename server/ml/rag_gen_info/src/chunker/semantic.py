from langchain.embeddings import Embeddings
from langchain_experimental.text_splitter import SemanticChunker


class SemanticTextSplitter:

    def __init__(
        self,
        embedding: Embeddings,
        breakpoint_threshold_amount: int = 90,
    ) -> None:
        self.embedding = embedding
        self.breakpoint_threshold_amount = breakpoint_threshold_amount

    def split(self):
        return SemanticChunker(
            embeddings=self.embedding,
            breakpoint_threshold_type="percentile",
            breakpoint_threshold_amount=self.breakpoint_threshold_amount,
        )
