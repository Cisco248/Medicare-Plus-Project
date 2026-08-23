from typing import Any
from langchain_core.documents import Document

from .document_identity import DocumentIdentity


class RRFRanker:
    def __init__(
        self,
        vector_weight: float = 0.65,
        bm25_weight: float = 0.35,
        rrf_k: int = 60,
    ) -> None:

        self.vector_weight = vector_weight
        self.bm25_weight = bm25_weight
        self.rrf_k = rrf_k

    def rank(
        self,
        vector_results: list[tuple[Document, float]],
        bm25_results: list[tuple[Document, float]],
        result_limit: int,
    ) -> list[dict[str, Any]]:

        scores: dict[str, dict[str, Any]] = {}

        self._add_results(
            scores,
            vector_results,
            self.vector_weight,
            "vector",
        )

        self._add_results(
            scores,
            bm25_results,
            self.bm25_weight,
            "bm25",
        )

        ranked = sorted(
            scores.values(),
            key=lambda item: item["score"],
            reverse=True,
        )

        return ranked[:result_limit]

    def _add_results(
        self,
        scores: dict[str, dict[str, Any]],
        results: list[tuple[Document, float]],
        weight: float,
        source: str,
    ) -> None:

        for rank, (document, raw_score) in enumerate(results, start=1):
            key = DocumentIdentity.get(document)
            entry = scores.setdefault(
                key,
                {
                    "document": document,
                    "score": 0.0,
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
