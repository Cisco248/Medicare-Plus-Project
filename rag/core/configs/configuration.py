import os
from pathlib import Path
from pydantic_settings import BaseSettings, SettingsConfigDict

BASE_DIR = Path(__file__).resolve().parents[2]


class RAGSettings(BaseSettings):
    model_config = SettingsConfigDict(env_file=BASE_DIR / ".env", extra="ignore")
    FILE_LOCATION: Path = BASE_DIR / "docs"
    ARTIFAT_PATH: Path = BASE_DIR / "temp"
    # API Keys
    OPENAI_API_KEY: str = os.getenv("OPENAI_API_KEY", "")
    GROQ_API_KEY: str = os.getenv("GROQ_API_KEY", "")
    # Embedded Model Params
    EMBEDDING_PATH: Path = ARTIFAT_PATH / "embedding"
    EMBEDDING_MODEL_BASE_URL: str = "http://llm-model:11434/"
    EMBEDDING_MODEL_NAME: str = "paraphrase-multilingual"
    # LLM Params
    LLM_BASE_URL: str = "http://llm-model:11434/"
    LLM_MODEL_NAME: str = "qwen3:0.6b"
    # Vector DB Param
    CHROMA_API: str = os.getenv("CHROMA_API_KEY", "")
    CHROMA_PORT: int = 3000
    CHROMA_HOST: str = "chroma-server"
    VECTOR_DB_DIR: Path = ARTIFAT_PATH / "db"
    COLLECTION_NAME: str = "enterprise_hybrid_search"
    # Retriever Params
    CHUNK_SIZE: int = 400
    CHUNK_OVERLAP: int = 50
    RETRIEVER_K: int = 4


# "groq/compound"
# "https://api.groq.com/openai/v1"
