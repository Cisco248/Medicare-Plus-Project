import os
from dataclasses import dataclass
from langchain_core.prompts import ChatPromptTemplate


@dataclass
class Settings:
    # API Keys
    OPENAI_API_KEY: str = os.getenv("OPENAI_API_KEY", "")
    GROQ_API_TOKEN: str = os.getenv("GROQ_API_KEY", "")
    # Embedded Model Params
    EMBEDDING_MODEL_BASE_URL: str = "https://router.huggingface.co/v1"
    EMBEDDING_MODEL_NAME: str = "BAAI/bge-small-en-v1.5"
    # LLM Params
    LLM_BASE_URL: str = "https://api.groq.com/openai/v1"
    LLM_MODEL_NAME: str = "groq/compound"
    # Vector DB Param
    COLLECTION_NAME: str = "enterprise_hybrid_search"
    # Retriever Params
    CHUNK_SIZE: int = 400
    CHUNK_OVERLAP: int = 50
    VECTOR_DB_DIR: str = "./db"
    RETRIEVER_K: int = 4

    class Config:
        env_file = ".env"


settings = Settings()
