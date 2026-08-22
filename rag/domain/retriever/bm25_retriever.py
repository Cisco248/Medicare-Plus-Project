from langchain_community.retrievers import BM25Retriever
from langchain_core.documents import Document


class BM25SearchRetriever:

    def __init__(
        self,
        documents: list[Document],
        candidate_k: int = 8,
        min_match_ratio: float = 0.2,
        query_processor=None,
    ) -> None:

        self.retriever = BM25Retriever.from_documents(documents)
        self.retriever.k = candidate_k

        self.candidate_k = candidate_k
        self.min_match_ratio = min_match_ratio
        self.query_processor = query_processor

    def search(
        self,
        query: str,
        metadata_filter: dict | None = None,
    ) -> list[tuple[Document, float]]:

        query_tokens = self.query_processor.tokens(query)

        if not query_tokens:
            return []

        results = self.retriever.invoke(query)

        accepted: list[tuple[Document, float]] = []

        for document in results:

            document_tokens = self.query_processor.tokens(document.page_content)

            match_ratio = len(query_tokens & document_tokens) / len(query_tokens)

            if match_ratio < self.min_match_ratio:
                continue

            if metadata_filter:
                if not all(
                    document.metadata.get(key) == value
                    for key, value in metadata_filter.items()
                ):
                    continue

            accepted.append((document, match_ratio))

        return accepted
