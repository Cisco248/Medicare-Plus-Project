import os
from pathlib import Path
from pydantic_settings import BaseSettings, SettingsConfigDict

BASE_DIR = Path(__file__).resolve().parents[2]


class RAGSettings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=BASE_DIR / ".env",
        extra="ignore",
        env_file_encoding="utf-8",
    )

    # RAG System Configurations
    APP_NAME: str = os.getenv("APP_NAME", "")
    APP_VERSION: str = os.getenv("APP_VERSION", "")
    FILE_LOCATION: str = f"{BASE_DIR}/docs/sample.pdf"
    ARTIFACT_PATH: Path = BASE_DIR / "temp"

    # OpenAI Configurations
    OPENAI_API_KEY: str = os.getenv("OPENAI_API_KEY", "")
    LLM_MODEL_NAME: str = "gpt-4o-mini"
    EMBEDDING_MODEL_NAME: str = "text-embedding-3-small"
    LLM_TEMPERATURE: float = 0.2
    MAX_OUTPUT_TOKENS: int = 500

    # Chroma Configurations
    CHROMA_HOST: str = os.getenv("CHROMA_HOST", "")
    CHROMA_PORT: int = int(os.getenv("CHROMA_PORT", 3000))
    COLLECTION_NAME: str = os.getenv("COLLECTION_NAME", "")
    VECTOR_DB_DIR: Path = ARTIFACT_PATH / "db"

    # Retrivel Configurations
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


set = RAGSettings()
print(set.CHROMA_PORT)
