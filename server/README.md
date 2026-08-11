# Medicare+ API (FastAPI)

## Structure

```
server/
├── main.py              # App entry + middleware
├── api/
│   ├── router.py        # Route aggregation
│   └── routes/          # Endpoint modules
├── core/
│   └── config.py        # Environment settings
├── res_models/          # Standard API response helpers
└── services/            # Business logic layer
```

## Run locally

```bash
cd server
uv sync
uv run python main.py
```

API docs: [http://localhost:8000/docs](http://localhost:8000/docs)
