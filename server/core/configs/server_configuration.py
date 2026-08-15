import os
from pathlib import Path
from pydantic_settings import BaseSettings, SettingsConfigDict

BASE_DIR = Path(__file__).resolve().parents[2]


class ServerSettings(BaseSettings):
    model_config = SettingsConfigDict(env_file=BASE_DIR / ".env", extra="ignore")
    # DB Configs
    DB_URL: str = os.getenv("DB_URL", "your-url-link")
    ECO: bool = False
    Pool_Pre_Ping: bool = True
    # App Configs
    APP_NAME: str = "Medicare Plus API"
    APP_VERSION: str = "1.0.0"
    DEBUG: bool = os.getenv("DEBUG", "true").lower() == "true"
    HOST: str = os.getenv("HOST", "0.0.0.0")
    PORT: int = int(os.getenv("PORT", "8080"))
    CORS_ORIGIN: list[str] = os.getenv("CORS_ORIGINS", "http://localhost:3000").split()

    # Rag URL
    RAG_URL: str = "http://rag-server:8000"

    # JWT Tokens
    JWT_SECRET_KEY: str = os.getenv("JWT_SECRET_KEY", "your-secret-key")

    # Patient document storage (local disk)
    DOCUMENT_STORAGE_PATH: str = os.getenv(
        "DOCUMENT_STORAGE_PATH", f"{BASE_DIR}/uploads/documents"
    )

    HYPERTENSION_MODEL_PATH: str = f"{BASE_DIR}/artifacts/base/hypertension/model.pkl"
    HYPERTENSION_FEATURE_PATH: str = (
        f"{BASE_DIR}/artifacts/base/hypertension/features.pkl"
    )
    HYPERTENSION_LABEL_PATH: str = f"{BASE_DIR}/artifacts/base/hypertension/labels.pkl"
