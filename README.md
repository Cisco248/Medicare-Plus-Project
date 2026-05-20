# Medicare-Plus-Project

Final Year Project — Medicare+ healthcare platform.

## Monorepo layout

```
Medicare-Plus-Project/
├── app/                 # Next.js frontend
├── server/              # FastAPI backend
└── ocr-service/         # OCR microservice
```

## App (Next.js)

Feature-based modules under `app/app/`:

| Layer | Role |
|-------|------|
| `page.tsx` | Route entry (Next.js App Router) |
| `presentation/` | UI components |
| `data/` | API / data access (repositories) |
| `utils/` | Validation and helpers |

Shared code: `app/lib/` (API client, config, types), `app/shared/` (reusable UI).

```bash
cd app
npm install
cp .env.example .env.local
npm run dev
```

- Landing: [http://localhost:3000/landing](http://localhost:3000/landing)
- Auth: [http://localhost:3000/auth](http://localhost:3000/auth)

## Server (FastAPI)

```bash
cd server
uv sync
cp .env.example .env
uv run python main.py
```

- API: [http://localhost:8000](http://localhost:8000)
- Health: [http://localhost:8000/health](http://localhost:8000/health)

## Environment

| Service | Variable | Default |
|---------|----------|---------|
| App | `NEXT_PUBLIC_API_URL` | `http://localhost:8000` |
| Server | `PORT` | `8000` |
| Server | `CORS_ORIGINS` | `http://localhost:3000` |
