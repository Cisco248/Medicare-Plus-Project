import logging
from typing import List, Any
from langchain_core.documents import Document
from langchain_core.retrievers import BaseRetriever
from langchain_community.retrievers import BM25Retriever
from langchain_chroma import Chroma
from langchain_core.callbacks import CallbackManagerForRetrieverRun

logger = logging.getLogger(__name__)


class HybridRetriever(BaseRetriever):
    vector_retriever: Any
    bm25_retriever: Any
    k: int = 4
    bm25_weight: float = 0.5
    vector_weight: float = 0.5
    rrf_k: int = 60

    def _get_relevant_documents(
        self, query: str, *, run_manager: CallbackManagerForRetrieverRun
    ) -> List[Document]:
        logger.info(f"Performing hybrid search for query: '{query}'")

        bm25_results = self.bm25_retriever.invoke(query)
        vector_results = self.vector_retriever.invoke(query)

        doc_scores = {}

        def add_to_scores(results, weight):
            for rank, doc in enumerate(results):
                key = doc.page_content
                rrf_score = weight * (1.0 / (rank + self.rrf_k))
                if key in doc_scores:
                    doc_scores[key] = (doc_scores[key][0] + rrf_score, doc)
                else:
                    doc_scores[key] = (rrf_score, doc)

        add_to_scores(bm25_results, self.bm25_weight)
        add_to_scores(vector_results, self.vector_weight)

        sorted_docs = sorted(doc_scores.values(), key=lambda x: x[0], reverse=True)
        return [doc for _, doc in sorted_docs[: self.k]]

    @classmethod
    def build(
        cls,
        vector_store: Chroma,
        documents: List[Document],
        k: int = 4,
        bm25_weight: float = 0.5,
    ):
        logger.info("<--- Initialized Hybrid Retriever --->")
        vector_retriever = vector_store.as_retriever(search_kwargs={"k": k})
        bm25_retriever = BM25Retriever.from_documents(documents)
        bm25_retriever.k = k
        return cls(
            vector_retriever=vector_retriever,
            bm25_retriever=bm25_retriever,
            k=k,
            bm25_weight=bm25_weight,
            vector_weight=1.0 - bm25_weight,
        )
