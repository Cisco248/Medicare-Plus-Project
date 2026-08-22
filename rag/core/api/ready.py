from fastapi import HTTPException, Request, status


def require_ready(request: Request):
    rag = getattr(request.app.state, "rag", None)
    if rag is None or not getattr(rag, "ready", False):
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="The RAG knowledge index is not ready.",
        )
    return rag
