from langchain_chroma import Chroma
from langchain_core.documents import Document


class VectorRetriever:

    def __init__(
        self,
        vector_store: Chroma,
        candidate_k: int = 8,
        similarity_threshold: float = 0.55,
    ) -> None:

        self.vector_store = vector_store
        self.candidate_k = candidate_k
        self.similarity_threshold = similarity_threshold

    def search(
        self,
        query: str,
        metadata_filter: dict | None = None,
    ) -> list[tuple[Document, float]]:

        results = self.vector_store.similarity_search_with_relevance_scores(
            query,
            k=self.candidate_k,
            filter=metadata_filter,
        )
        return [
            (document, float(score))
            for document, score in results
            if score >= self.similarity_threshold
        ]
