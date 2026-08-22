import os
from pathlib import Path
from pydantic_settings import BaseSettings, SettingsConfigDict

BASE_DIR = Path(__file__).resolve().parents[2]


class ServerSettings(BaseSettings):
    model_config = SettingsConfigDict(env_file=BASE_DIR / ".env", extra="ignore")

    # Database Configurations
    DB_HOST: str = os.getenv("MYSQL_HOST", "localhost")
    DB_PORT: int = int(os.getenv("MYSQL_PORT", 3306))
    DB_USER: str = os.getenv("MYSQL_USER", "root")
    DB_PASSWORD: str = os.getenv("MYSQL_PASSWORD", "password")
    DB_NAME: str = os.getenv("MYSQL_DATABASE", "db_name")
    ECO: bool = False
    Pool_Pre_Ping: bool = True

    # Server Configurations
    APP_NAME: str = os.getenv("APP_NAME", "app_name")
    APP_VERSION: str = os.getenv("APP_VERSION", "app_version")
    APP_HOST: str = os.getenv("HOST", "0.0.0.0")
    APP_PORT: int = int(os.getenv("PORT", 8000))
    DEBUG: bool = os.getenv("DEBUG", "true").lower() == "true"
    CORS_ORIGIN: list[str] = os.getenv("CORS_ORIGINS", "").split()

    # Rag URL
    RAG_HOST: str = os.getenv("RAG_HOST", "loacalhost")
    RAG_PORT: int = int(os.getenv("RAG_PORT", 8081))

    # JWT Tokens
    JWT_SECRET_KEY: str = os.getenv("JWT_SECRET_KEY", "secret-key")

    # Patient document storage (local disk)
    DOCUMENT_STORAGE_PATH: str = os.getenv(
        "DOCUMENT_STORAGE_PATH", f"{BASE_DIR}/uploads/documents"
    )

    # Base Models Paths Configurations
    HYPERTENSION_PATH: str = f"{BASE_DIR}/artifacts/base/hypertension"
    HYPERTENSION_MODEL_PATH: str = f"{BASE_DIR}/artifacts/base/hypertension/risk_classifier.pkl"
    HYPERTENSION_FEATURE_PATH: str = f"{BASE_DIR}/artifacts/base/hypertension/feature_names.pkl"
    HYPERTENSION_LABEL_PATH: str = f"{BASE_DIR}/artifacts/base/hypertension/risk_labels.pkl"

    BLOOD_PRESSURE_PATH: str = f"{BASE_DIR}/artifacts/base/hypertension"

    # Diabetes (helper model) artifact paths
    DIABETES_PATH: str = f"{BASE_DIR}/artifacts/base/diabetes"
    DIABETES_MODEL_PATH: str = f"{BASE_DIR}/artifacts/base/diabetes/diabetes_best_model.pkl"
    DIABETES_SCALER_PATH: str = f"{BASE_DIR}/artifacts/base/diabetes/scaler.pkl"
    DIABETES_FEATURE_PATH: str = f"{BASE_DIR}/artifacts/base/diabetes/feature_cols.pkl"
