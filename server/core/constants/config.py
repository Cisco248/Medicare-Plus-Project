import os

DB_URL = os.getenv("DB_URL", "your-url-link")

APP_NAME: str = "Medicare Plus API"
APP_VERSION: str = "1.0.0"
DEBUG: bool = os.getenv("DEBUG", "true").lower() == "true"
HOST: str = os.getenv("HOST", "0.0.0.0")
PORT: int = int(os.getenv("PORT", "8000"))
CORS_ORIGIN: list[str] = os.getenv("CORS_ORIGINS", "http://localhost:3000").split()

JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY", "your-secret-key")
