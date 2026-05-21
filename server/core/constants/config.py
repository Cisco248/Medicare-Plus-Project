import os

DB_URL = "mysql+pymysql://root:ADITHYA345%40abc@127.0.0.1:3306/medicare+"

app_name: str = "Medicare Plus API"
app_version: str = "1.0.0"
debug: bool = os.getenv("DEBUG", "true").lower() == "true"
host: str = os.getenv("HOST", "0.0.0.0")
port: int = int(os.getenv("PORT", "8000"))
cors_origins: list[str] = os.getenv("CORS_ORIGINS", "http://localhost:3000").split()
