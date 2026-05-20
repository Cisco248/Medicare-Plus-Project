# Medicare+ App (Next.js)

## Folder structure

```
app/
├── app/                      # App Router (routes)
│   ├── layout.tsx
│   ├── page.tsx              # redirects to /landing
│   ├── auth/
│   │   ├── page.tsx          # route: /auth
│   │   ├── presentation/     # UI components
│   │   ├── data/             # repositories (API calls)
│   │   └── utils/            # validation, helpers
│   └── landing/
│       ├── page.tsx          # route: /landing
│       ├── presentation/
│       ├── data/
│       └── utils/
├── lib/                      # shared app logic
│   ├── api/client.ts
│   ├── config.ts
│   └── types/api.ts
└── shared/                   # shared UI
    └── components/
```

## Getting started

```bash
npm install
cp .env.example .env.local
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) — home redirects to `/landing`.

Ensure the FastAPI server is running at `NEXT_PUBLIC_API_URL` (default `http://localhost:8000`).
