# RAG Installation

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

## Setup RAG System

Navigate to the server:

```bash
cd Medicare-Plus-Project/rag
```

The server should contain:

```text
server/
├── pyproject.toml
├── uv.lock
├── .env
├── .gitignore
│
└── rag/
    ├── main.py
    ├── core/
    ├── docs/
    └── domain/
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
# RAG System Configurations
APP_NAME="RAG System API"
APP_VERSION="1.0.0"

# OpenAI Configuration
OPENAI_API_KEY=paste_your_api_key
LLM_MODEL="gpt-4o-mini"
LLM_TEMPERATURE=0.2
MAX_OUTPUT_TOKENS=500
EMBEDDING_MODEL="text-embedding-3-small"

# Database Configuration
CHROMA_API_KEY=paste_your_api_key
CHROMA_HOST="chroma-server"
CHROMA_PORT=3000
COLLECTION_NAME="medicare_knowledge"
```

The `uv.lock` file **should normally be committed**.

---

## Run FastAPI Using uv

### Local Deployment

```bash
cd rag
uvicorn main:app --host localhost --port 8000
```

### Docker Deployment

```bash
docker build -t rag-server .
docker run -p 8000:8000 rag-server
```

The API is available at:

### Check APIs in Browser

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
rag/core/configs/configuration.py
```

Example:

```python
class RAGSettings(BaseSettings):
        # RAG System Configurations
    APP_NAME: str = os.getenv("APP_NAME", "")
    APP_VERSION: str = os.getenv("APP_VERSION", "")
    FILE_LOCATION: Path = BASE_DIR / "docs"
    ARTIFACT_PATH: Path = BASE_DIR / "temp"

    # OpenAI Configurations
    OPENAI_API_KEY: str = os.getenv("OPENAI_API_KEY", "")
    LLM_MODEL_NAME: str = os.getenv("LLM_MODEL", "")
    EMBEDDING_MODEL_NAME: str = os.getenv("EMBEDDING_MODEL", "")
    LLM_TEMPERATURE: float = float(os.getenv("LLM_TEMPERATURE", 0.2))
    MAX_OUTPUT_TOKENS: int = int(os.getenv("MAX_OUTPUT_TOKENS", 400))

    # Chroma Configurations
    CHROMA_HOST: str = os.getenv("CHROMA_HOST", "")
    CHROMA_PORT: int = int(os.getenv("CHROMA_PORT", "3000"))
    COLLECTION_NAME: str = os.getenv("COLLECTION_NAME", "")
    VECTOR_DB_DIR: Path = ARTIFACT_PATH / "db"

    # Retrivel Configurations
    CHUNK_SIZE: int = 500
    CHUNK_OVERLAP: int = 50
    VECTOR_CANDIDATE_K: int = 8
    RETRIEVER_K: int = 3
    SIMILARITY_THRESHOLD: float = 0.55
    BM25_WEIGHT: float = 0.35
    BM25_MIN_MATCH_RATIO: float = 0.2
    RRF_K: int = 60

    # Per-request cost controls.
    MAX_REQUEST_TOKENS: int = 4000
    MAX_CONTEXT_TOKENS: int = 2500
    MAX_QUERY_CHARS: int = 4000
    RESPONSE_CACHE_SIZE: int = 128
    RESPONSE_CACHE_TTL_SECONDS: int = 300
```

---

## Docker Compose Run

```bash
cd Medicare-Plus-Project/rag
```

```bash
docker build -t rag-server .
```

---

## Troubleshooting

### `Connection refused`

Check whether the target service is running.

For FastAPI:

```bash
curl http://localhost:8000/health
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
