# Installation

---

## Install uv

### Linux / macOS

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Restart the terminal or reload the shell configuration.

Verify:

```bash
uv --version
```

### Windows

Using PowerShell:

```powershell
irm https://astral.sh/uv/install.ps1 | iex
```

Verify:

```powershell
uv --version
```

---

## Project Setup

Clone the project:

```bash
git clone <repository-url>
```

Navigate to the server:

```bash
cd Medicare-Plus-Project/server
```

The server should contain:

```text
server/
├── pyproject.toml
├── uv.lock
├── .env
├── .gitignore
│
└── server/
    ├── main.py
    ├── artifacts/
    ├── core/
    ├── models/
    ├── schemas/
    ├── repositories/
    ├── services/
    └── routes/
```

---

## Install Dependencies Using uv

If the project already contains:

```text
pyproject.toml
uv.lock
```

run:

```bash
uv sync
```

`uv` will create and manage the project's virtual environment and install the dependencies specified by the project configuration and lock file.

Do not manually run:

```bash
pip install ...
```

for project dependencies.

---

## Environment Configuration

Create:

```text
.env
```

Example:

```env
# Server Configuration
APP_NAME="Medicare Plus API"
APP_VERSION="1.0.0"
APP_ENV="development"
DEBUG=true
HOST="0.0.0.0"
PORT=8080
CORS_ORIGIN="http://localhost:3000"

# Database Configuration
MYSQL_HOST="mysql-server"
MYSQL_PORT=3306
MYSQL_DATABASE="medicare_plus"
MYSQL_USER="root"
MYSQL_PASSWORD="root123"

# RAG System Configuration
RAG_HOST="rag-server"
RAG_PORT=8000

# Token Configuration
JWT_SECRET_KEY='8f4c2b1e9a7d6c5b3f8a1d2e4c6b7a9f0e1d3c5b7a9f2e4d6c8b1a3f5e7d9c2'

```

Do not commit `.env`.

Add this to `.gitignore`:

```text
.env
.venv/
__pycache__/
*.pyc
```

The `uv.lock` file **should normally be committed**.

---

## Run FastAPI Using uv

### Local Deployment

```bash
uv run main.py
```

### Docker Deployment

```bash
docker build -t backend-server .
docker run -p 8000:8080 backend-server
```

The API is available at:

```text
http://localhost:8000
```

Swagger:

```text
http://localhost:8000/docs
```

---

## FastAPI Configuration

Create:

```text
server/core/configs/server_configuration.py
```

Example:

```python
class ServerSettings(BaseSettings):
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
    DIABETES_PATH: str = f"{BASE_DIR}/artifacts/base/diabetes"
    BLOOD_PRESSURE_PATH: str = f"{BASE_DIR}/artifacts/base/blood_pressure"

```

---

## Set up Models in Server Path

* Firstly, You have to download models in the google drive path.

### Folder Structure

```bash
└── server/
    └── artifacts/
        └── base/
            ├── hypertension/
                ├── model.pkl
                └── labels.pkl
                └── feature.pkl

            ├── diabetes/
                ├── model.pkl
                └── labels.pkl
                └── feature.pkl

            └── blood_pressure/
                ├── model.pkl
                └── labels.pkl
                └── feature.pkl

        └── har/
            ├── model.pkl
            └── labels.pkl
            └── feature.pkl
```

### Copy Files to Paths

* Copy/Paste the following folder path and rename following naming structures.

`server/artifacts/base/hypertension`
`server/artifacts/base/diabetes`
`server/artifacts/base/blood_pressure`

---

## Docker Compose Run

```bash
cd Medicare-Plus-Project
```

```bash
docker build -t backend-server .
```

---

## Troubleshooting

### `Connection refused`

Check whether the target service is running.

For FastAPI:

```bash
curl http://localhost:8080/health
```

---

## FastAPI cannot connect to MySQL

Check:

```env
MYSQL_HOST
MYSQL_PORT
MYSQL_DATABASE
MYSQL_USER
MYSQL_PASSWORD
```

If using Docker, ensure:

```env
MYSQL_HOST=mysql-server
```

not:

```env
MYSQL_HOST=localhost
```

---

## FastAPI cannot connect to RAG

Local:

```env
RAG_BASE_URL=http://localhost:8000
```

Docker:

```env
RAG_BASE_URL=http://rag-system:8000
```

Check:

```bash
curl http://localhost:8000/health
```

---

## Flutter cannot connect to FastAPI

Android emulator:

```text
http://10.0.2.2:8000
```

Physical device:

```text
http://<COMPUTER-LAN-IP>:8000
```

Ensure FastAPI is running with:

```bash
--host 0.0.0.0
```

---
