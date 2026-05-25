import os

DB_URL = "mysql+pymysql://root:root123@127.0.0.1:3306/medicare_plus"
DB_QUERY = "CREATE SCHEMA IF NOT EXISTS medicare_plus;"

app_name: str = "Medicare Plus API"
app_version: str = "1.0.0"
debug: bool = os.getenv("DEBUG", "true").lower() == "true"
host: str = os.getenv("HOST", "0.0.0.0")
port: int = int(os.getenv("PORT", "8000"))
cors_origins: list[str] = os.getenv("CORS_ORIGINS", "http://localhost:3000").split()

JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY", "your-secret-key")
