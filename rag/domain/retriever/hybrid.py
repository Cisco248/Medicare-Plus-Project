import logging
import re
from typing import List, Any
from langchain_core.documents import Document
from langchain_core.retrievers import BaseRetriever
from langchain_community.retrievers import BM25Retriever
from langchain_chroma import Chroma
from langchain_core.callbacks import CallbackManagerForRetrieverRun
from pydantic import ConfigDict

logger = logging.getLogger(__name__)

_STOP_WORDS = {
    "a",
    "an",
    "and",
    "are",
    "as",
    "at",
    "be",
    "by",
    "for",
    "from",
    "how",
    "in",
    "is",
    "it",
    "of",
    "on",
    "or",
    "that",
    "the",
    "this",
    "to",
    "was",
    "what",
    "when",
    "where",
    "which",
    "who",
    "why",
    "with",
}


class HybridRetriever(BaseRetriever):
    model_config = ConfigDict(arbitrary_types_allowed=True)

    vector_store: Any
    bm25_retriever: Any
    k: int = 3
    vector_candidate_k: int = 8
    similarity_threshold: float = 0.55
    bm25_weight: float = 0.35
    vector_weight: float = 0.65
    bm25_min_match_ratio: float = 0.2
    rrf_k: int = 60

    def _get_relevant_documents(
        self, query: str, *, run_manager: CallbackManagerForRetrieverRun
    ) -> List[Document]:
        return self.search(query)

    @staticmethod
    def _document_key(document: Document) -> str:
        return str(
            document.metadata.get("chunk_id")
            or document.metadata.get("id")
            or document.page_content
        )

    @staticmethod
    def _tokens(text: str) -> set[str]:
        return {
            token
            for token in re.findall(r"[a-z0-9]+", text.lower())
            if len(token) > 1 and token not in _STOP_WORDS
        }

    @staticmethod
    def _matches_filter(
        document: Document, metadata_filter: dict[str, Any] | None
    ) -> bool:
        if not metadata_filter:
            return True
        return all(
            document.metadata.get(key) == value
            for key, value in metadata_filter.items()
        )

    def search(
        self,
        query: str,
        metadata_filter: dict[str, Any] | None = None,
        k: int | None = None,
    ) -> List[Document]:
        """Return thresholded vector + lexical results ranked with weighted RRF."""
        result_limit = max(1, min(k or self.k, self.vector_candidate_k))
        query_tokens = self._tokens(query)

        vector_results = self.vector_store.similarity_search_with_relevance_scores(
            query,
            k=self.vector_candidate_k,
            filter=metadata_filter,
        )
        accepted_vectors = [
            (document, float(similarity))
            for document, similarity in vector_results
            if similarity >= self.similarity_threshold
            and self._matches_filter(document, metadata_filter)
        ]

        bm25_results = self.bm25_retriever.invoke(query)
        accepted_bm25: list[tuple[Document, float]] = []
        for document in bm25_results:
            if not self._matches_filter(document, metadata_filter):
                continue
            document_tokens = self._tokens(document.page_content)
            match_ratio = (
                len(query_tokens & document_tokens) / len(query_tokens)
                if query_tokens
                else 0.0
            )
            if match_ratio >= self.bm25_min_match_ratio:
                accepted_bm25.append((document, match_ratio))

        doc_scores: dict[str, dict[str, Any]] = {}

        def add_result(
            document: Document,
            rank: int,
            weight: float,
            source: str,
            raw_score: float,
        ) -> None:
            key = self._document_key(document)
            entry = doc_scores.setdefault(
                key,
                {
                    "score": 0.0,
                    "document": document,
                    "sources": [],
                    "vector_similarity": None,
                    "lexical_match": None,
                },
            )
            entry["score"] += weight / (self.rrf_k + rank)
            entry["sources"].append(source)
            if source == "vector":
                entry["vector_similarity"] = raw_score
            else:
                entry["lexical_match"] = raw_score

        for rank, (document, similarity) in enumerate(accepted_vectors):
            add_result(document, rank, self.vector_weight, "vector", similarity)
        for rank, (document, match_ratio) in enumerate(accepted_bm25):
            add_result(document, rank, self.bm25_weight, "bm25", match_ratio)

        sorted_entries = sorted(
            doc_scores.values(), key=lambda item: item["score"], reverse=True
        )
        output: list[Document] = []
        max_rrf_score = 1.0 / self.rrf_k
        for entry in sorted_entries[:result_limit]:
            metadata = dict(entry["document"].metadata)
            metadata["retrieval_score"] = min(1.0, entry["score"] / max_rrf_score)
            metadata["retrieval_sources"] = entry["sources"]
            if entry["vector_similarity"] is not None:
                metadata["vector_similarity"] = entry["vector_similarity"]
            if entry["lexical_match"] is not None:
                metadata["lexical_match"] = entry["lexical_match"]
            output.append(
                Document(
                    page_content=entry["document"].page_content,
                    metadata=metadata,
                )
            )

        logger.info(
            "Hybrid retrieval returned %d documents (%d vector, %d lexical).",
            len(output),
            len(accepted_vectors),
            len(accepted_bm25),
        )
        return output

    @classmethod
    def build(
        cls,
        vector_store: Chroma,
        documents: List[Document],
        k: int = 3,
        vector_candidate_k: int = 8,
        similarity_threshold: float = 0.55,
        bm25_weight: float = 0.35,
        bm25_min_match_ratio: float = 0.2,
        rrf_k: int = 60,
    ):
        if not documents:
            raise ValueError("At least one document is required for hybrid retrieval.")
        bm25_retriever = BM25Retriever.from_documents(documents)
        bm25_retriever.k = vector_candidate_k
        logger.info("Initialized hybrid retriever.")
        return cls(
            vector_store=vector_store,
            bm25_retriever=bm25_retriever,
            k=k,
            vector_candidate_k=vector_candidate_k,
            similarity_threshold=similarity_threshold,
            bm25_weight=bm25_weight,
            vector_weight=1.0 - bm25_weight,
            bm25_min_match_ratio=bm25_min_match_ratio,
            rrf_k=rrf_k,
        )
