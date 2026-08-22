import logging
from typing import Any

from langchain_core.documents import Document
from langchain_core.retrievers import BaseRetriever
from langchain_core.callbacks import CallbackManagerForRetrieverRun
from pydantic import ConfigDict

from .query_processor import QueryProcessor
from .vector_retriever import VectorRetriever
from .bm25_retriever import BM25SearchRetriever
from .metadata_filter import MetadataFilter
from .rff_ranker import RRFRanker
from .result_formatter import RetrievalResultFormatter

logger = logging.getLogger(__name__)

_SAFETY_BOOST = 1.5


def _source_path(document: Document) -> str:
    return str(document.metadata.get("source", "")).replace("\\", "/")


def _boost_safety(entries: list[dict]) -> list[dict]:
    for entry in entries:
        if "safety/" in _source_path(entry["document"]):
            entry["score"] *= _SAFETY_BOOST
    return sorted(entries, key=lambda item: item["score"], reverse=True)


class HybridRetriever(BaseRetriever):
    model_config = ConfigDict(arbitrary_types_allowed=True)
    vector_store: Any
    k: int = 3
    vector_retriever: Any
    bm25_retriever: Any
    ranker: RRFRanker
    result_formatter: RetrievalResultFormatter
    query_processor: QueryProcessor
    metadata_filter: MetadataFilter

    def _get_relevant_documents(
        self,
        query: str,
        *,
        run_manager: CallbackManagerForRetrieverRun,
    ) -> list[Document]:
        return self.search(query)

    def search(
        self,
        query: str,
        metadata_filter: dict | None = None,
        k: int | None = None,
    ) -> list[Document]:

        result_limit = max(1, min(k or self.k, self.vector_retriever.candidate_k))
        vector_results = self.vector_retriever.search(
            query=query, metadata_filter=metadata_filter
        )

        bm25_results = self.bm25_retriever.search(
            query=query, metadata_filter=metadata_filter
        )

        ranked = self.ranker.rank(
            vector_results=vector_results,
            bm25_results=bm25_results,
            result_limit=max(result_limit * 3, result_limit),
        )
        ranked = _boost_safety(ranked)[:result_limit]
        results = self.result_formatter.format(ranked)

        logger.info(
            "Hybrid retrieval returned %d documents.",
            len(results),
        )

        return results

    @classmethod
    def build(
        cls,
        vector_store: Any,
        documents: list[Document],
        k: int = 3,
        vector_candidate_k: int = 8,
        similarity_threshold: float = 0.55,
        bm25_weight: float = 0.35,
        bm25_min_match_ratio: float = 0.2,
        rrf_k: int = 60,
    ) -> "HybridRetriever":

        if not documents:
            raise ValueError("At least one document is required.")

        query_processor = QueryProcessor()

        vector_retriever = VectorRetriever(
            vector_store=vector_store,
            candidate_k=vector_candidate_k,
            similarity_threshold=similarity_threshold,
        )

        bm25_retriever = BM25SearchRetriever(
            documents=documents,
            candidate_k=vector_candidate_k,
            min_match_ratio=bm25_min_match_ratio,
            query_processor=query_processor,
        )

        ranker = RRFRanker(
            vector_weight=1.0 - bm25_weight,
            bm25_weight=bm25_weight,
            rrf_k=rrf_k,
        )

        formatter = RetrievalResultFormatter(
            rrf_k=rrf_k,
        )

        return cls(
            vector_store=vector_store,
            k=k,
            vector_retriever=vector_retriever,
            bm25_retriever=bm25_retriever,
            ranker=ranker,
            result_formatter=formatter,
            query_processor=query_processor,
            metadata_filter=MetadataFilter(),
        )
