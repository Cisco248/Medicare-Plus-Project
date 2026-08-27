import os
from pathlib import Path
from pydantic_settings import BaseSettings, SettingsConfigDict

BASE_DIR = Path(__file__).resolve().parents[2]


class ServerSettings(BaseSettings):
    model_config = SettingsConfigDict(env_file=BASE_DIR / ".env", extra="ignore")

    # Database Configuration.
    DB_HOST: str = os.getenv("MYSQL_HOST", "mysql-server")
    DB_PORT: int = int(os.getenv("MYSQL_PORT", 3306))
    DB_USER: str = os.getenv("MYSQL_USER", "root")
    DB_PASSWORD: str = os.getenv("MYSQL_PASSWORD", "password")
    DB_NAME: str = os.getenv("MYSQL_DATABASE", "db_name")
    ECO: bool = False
    Pool_Pre_Ping: bool = True

    # Server Configuration.
    APP_NAME: str = os.getenv("APP_NAME", "app_name")
    APP_VERSION: str = os.getenv("APP_VERSION", "app_version")
    APP_HOST: str = os.getenv("HOST", "0.0.0.0")
    APP_PORT: int = int(os.getenv("PORT", 8080))
    DEBUG: bool = os.getenv("DEBUG", "true").lower() == "true"
    CORS_ORIGIN: list[str] = os.getenv("CORS_ORIGINS", "").split()

    # Rag URL
    RAG_HOST: str = os.getenv("RAG_HOST", "loacalhost")
    RAG_PORT: int = int(os.getenv("RAG_PORT", 8081))
    RAG_BASE_URL: str = os.getenv("RAG_BASE_URL", "")

    # JWT Tokens
    JWT_SECRET_KEY: str = os.getenv("JWT_SECRET_KEY", "secret-key")

    # Patient document storage (local disk)
    DOCUMENT_STORAGE_PATH: str = os.getenv(
        "DOCUMENT_STORAGE_PATH", f"{BASE_DIR}/uploads/documents"
    )

    MODEL_DIR: Path = Path(os.getenv("MODEL_DIR", "./artifact"))
    BUCKET_NAME: str = os.getenv("BUCKET_NAME", "medicare-plus-models")

    HYPERTENSION_MODEL_PATH: str = f"{MODEL_DIR}/base/hypertension/risk_classifier.pkl"
    HYPERTENSION_FEATURE_PATH: str = f"{MODEL_DIR}/base/hypertension/feature_names.pkl"
    HYPERTENSION_LABEL_PATH: str = f"{MODEL_DIR}/base/hypertension/risk_labels.pkl"

    DIABETES_MODEL_PATH: str = f"{MODEL_DIR}/base/diabetes/model.pkl"
    DIABETES_SCALER_PATH: str = f"{MODEL_DIR}/base/diabetes/scaler.pkl"
    DIABETES_FEATURE_PATH: str = f"{MODEL_DIR}/base/diabetes/features.pkl"

    HEART_DISEASE_MODEL_PATH: str = f"{MODEL_DIR}/base/heart_disease/model.pkl"
    HEART_DISEASE_SCALER_PATH: str = f"{MODEL_DIR}/base/heart_disease/scaler.pkl"
    HEART_DISEASE_FEATURE_PATH: str = f"{MODEL_DIR}/base/heart_disease/features.json"
    HEART_DISEASE_INFO_PATH: str = f"{MODEL_DIR}/base/heart_disease/model.json"

    HAR_MODEL_PATH: str = f"{MODEL_DIR}/har/model.pkl"

    @property
    def rag_url(self) -> str:
        if self.RAG_BASE_URL:
            return self.RAG_BASE_URL.rstrip("/")
        return f"{self.RAG_HOST.rstrip('/')}:{self.RAG_PORT}"
