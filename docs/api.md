# APIs Checkups

> The Flutter application communicates with the backend through HTTP APIs. The application can use **Dio** as the HTTP client.

Typical communication flow:

```text
Flutter Client
      │
      │ HTTP / HTTPS
      ▼
Dockerized Services
      │
      ├── MySQL
      |
      ├── Backend Server
      |
      ├── Chroma DB
      │
      ├── RAG System
      │
      └── External
```

## Server APIs

Common API operations include:

```text
POST   /auth/login
POST   /auth/register

GET    /health
```

The exact endpoints should be based on the implemented backend routes.

---

## RAG System APIs

common API operations include:

```text
POST   /ask
POST   /knowledge

GET    /health
```
