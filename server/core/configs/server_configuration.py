import os
from pathlib import Path
from pydantic_settings import BaseSettings, SettingsConfigDict

BASE_DIR = Path(__file__).resolve().parents[2]


class ServerSettings(BaseSettings):
    model_config = SettingsConfigDict(env_file=BASE_DIR / ".env", extra="ignore")

    # Database Configurations
    DB_HOST: str = os.getenv("MYSQL_HOST", "mysql-server")
    DB_PORT: int = int(os.getenv("MYSQL_PORT", 3306))
    DB_USER: str = os.getenv("MYSQL_USER", "root")
    DB_PASSWORD: str = os.getenv("MYSQL_PASSWORD", "password")
    DB_NAME: str = os.getenv("MYSQL_DATABASE", "db_name")
    # CLOUD_SQL_CONNECTION_NAME: str = ""
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
    HYPERTENSION_MODEL_PATH: str = f"{HYPERTENSION_PATH}/risk_classifier.pkl"
    HYPERTENSION_FEATURE_PATH: str = f"{HYPERTENSION_PATH}/feature_names.pkl"
    HYPERTENSION_LABEL_PATH: str = f"{HYPERTENSION_PATH}/risk_labels.pkl"

    DIABETES_PATH: str = f"{BASE_DIR}/artifacts/base/diabetes"
    DIABETES_MODEL_PATH: str = f"{DIABETES_PATH}/model.pkl"
    DIABETES_SCALER_PATH: str = f"{DIABETES_PATH}/scaler.pkl"
    DIABETES_FEATURE_PATH: str = f"{DIABETES_PATH}/features.pkl"

    HAR_PATH: str = f"{BASE_DIR}/artifacts/har"
    HAR_MODEL_PATH: str = f"{HAR_PATH}/model.pkl"

    HEART_DISEASE_PATH: str = f"{BASE_DIR}/artifacts/base/heart_disease"
    HEART_DISEASE_MODEL_PATH: str = f"{HEART_DISEASE_PATH}/model.pkl"
    HEART_DISEASE_SCALER_PATH: str = f"{HEART_DISEASE_PATH}/scaler.pkl"
    HEART_DISEASE_FEATURE_PATH: str = f"{HEART_DISEASE_PATH}/features.json"
    HEART_DISEASE_INFO_PATH: str = f"{HEART_DISEASE_PATH}/model.json"
