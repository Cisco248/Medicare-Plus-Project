import os
from pathlib import Path
from pydantic_settings import BaseSettings, SettingsConfigDict

BASE_DIR = Path(__file__).resolve().parents[2]


class RAGSettings(BaseSettings):
    model_config = SettingsConfigDict(env_file=BASE_DIR / ".env", extra="ignore")

    FILE_LOCATION: Path = BASE_DIR / "docs"
    ARTIFACT_PATH: Path = BASE_DIR / "temp"

    # API Keys
    OPENAI_API_KEY: str = os.getenv("OPENAI_API_KEY", "")

    # OpenAI model parameters. These defaults follow Documentation.md.
    EMBEDDING_MODEL_NAME: str = "text-embedding-3-small"
    LLM_MODEL_NAME: str = "gpt-4o-mini"
    LLM_TEMPERATURE: float = 0.2
    MAX_OUTPUT_TOKENS: int = 400

    # Chroma uses local persistence by default. Set CHROMA_HOST to use a
    # separately deployed Chroma HTTP server.
    CHROMA_HOST: str = os.getenv("CHROMA_HOST", "")
    CHROMA_PORT: int = int(os.getenv("CHROMA_PORT", "8000"))
    VECTOR_DB_DIR: Path = ARTIFACT_PATH / "db"
    COLLECTION_NAME: str = "medicare_knowledge"

    # Chunking and hybrid retrieval.
    CHUNK_SIZE: int = 500
    CHUNK_OVERLAP: int = 50
    VECTOR_CANDIDATE_K: int = 8
    RETRIEVER_K: int = 3
    SIMILARITY_THRESHOLD: float = 0.55
    BM25_WEIGHT: float = 0.35
    BM25_MIN_MATCH_RATIO: float = 0.2
    RRF_K: int = 60

    # Per-request cost controls.
    MAX_REQUEST_TOKENS: int = 4000
    MAX_CONTEXT_TOKENS: int = 2500
    MAX_QUERY_CHARS: int = 4000
    RESPONSE_CACHE_SIZE: int = 128
    RESPONSE_CACHE_TTL_SECONDS: int = 300
