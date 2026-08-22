from langchain_core.documents import Document


class RetrievalResultFormatter:
    def __init__(self, rrf_k: int = 60) -> None:
        self.rrf_k = rrf_k

    def format(
        self,
        entries: list[dict],
    ) -> list[Document]:

        max_rrf_score = 1.0 / (self.rrf_k + 1)
        results = []
        for entry in entries:
            metadata = dict(entry["document"].metadata)
            metadata["retrieval_score"] = min(
                1.0,
                entry["score"] / max_rrf_score,
            )
            metadata["retrieval_sources"] = entry["sources"]
            if entry["vector_similarity"] is not None:
                metadata["vector_similarity"] = entry["vector_similarity"]
            if entry["lexical_match"] is not None:
                metadata["lexical_match"] = entry["lexical_match"]
            results.append(
                Document(
                    page_content=entry["document"].page_content,
                    metadata=metadata,
                )
            )
        return results
