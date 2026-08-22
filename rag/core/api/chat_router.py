from fastapi import APIRouter, HTTPException, Request as FastAPIRequest, status
from core.api.ready import require_ready
from data import Request as AskRequest, SimilaritySearchRequest

router = APIRouter()


@router.post("/ask", status_code=200, tags=["RAG System"])
async def ask_question(req: AskRequest, request: FastAPIRequest):
    pipeline = require_ready(request)
    try:
        return pipeline.invoke(req.question)
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc


@router.post("/search", status_code=200, tags=["RAG System"])
async def similarity_search(req: SimilaritySearchRequest, request: FastAPIRequest):
    """Inspect retrieval quality without paying for an LLM generation call."""
    pipeline = require_ready(request)
    try:
        documents = pipeline.search(
            req.question,
            metadata_filter=req.metadata_filter,
            k=req.k,
        )
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc

    return {
        "query": req.question,
        "count": len(documents),
        "results": [
            {
                "content": document.page_content,
                "score": document.metadata.get("retrieval_score", 0.0),
                "vector_similarity": document.metadata.get("vector_similarity"),
                "lexical_match": document.metadata.get("lexical_match"),
                "sources": document.metadata.get("retrieval_sources", []),
                "metadata": {
                    key: value
                    for key, value in document.metadata.items()
                    if not key.startswith("retrieval_")
                    and key not in {"vector_similarity", "lexical_match"}
                },
            }
            for document in documents
        ],
    }


@router.get("/usage", status_code=200, tags=["Usage"])
async def usage(request: FastAPIRequest):
    return request.app.state.rag.usage_stats()
