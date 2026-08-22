# System Overview

The overall architecture can be summarized as:

```text
                         Medicare+
                            │
             ┌──────────────┼──────────────┐
             │              │              │
          Flutter        FastAPI          RAG
          Client         Backend          System
             │              │              │
             │              ├───────┐      │
             │              │       │      │
             │           Database   APIs    │
             │                      │       │
             │                      └───────┤
             │                              │
             └──────────── Health Data ─────┘
                            │
                       Health Connect
                            │
                         Wearables
```

This architecture separates the presentation, business logic, data storage, and AI processing responsibilities, making the application easier to maintain and extend.

---

Medicare+ consists of several major components:

```text
                    Medicare+ Platform
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
   Mobile Client       Backend Server       RAG System
        │                  │                  │
        │             Business Logic      AI / Retrieval
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                    Database / Storage
                           │
                External Services / APIs
```

## Major Components

| Component           | Responsibility                                          |
| ------------------- | ------------------------------------------------------- |
| Mobile Client       | Patient-facing mobile application                       |
| Backend Server      | API, authentication, business logic and data processing |
| Database            | Persistent application and patient data                 |
| RAG System          | Context-aware retrieval and AI-generated responses      |
| Health Connect      | Health and activity data integration                    |
| OCR                 | Extraction of information from medical documents        |
| E-Pharmacy          | Medicine browsing and demo purchasing                   |
| Notification System | Medication and healthcare reminders                     |

---

## Project Structure

A typical project structure is organized into separate client, server, and RAG components.

```text
Medicare+/
│
├── client/
│   ├── android/
│   ├── ios/
│   ├── lib/
│   │   ├── core/
│   │   ├── feature/
│   │   ├── routing/
│   │   ├── services/
│   │   └── main.dart
│   ├── assets/
│   └── pubspec.yaml
│
├── server/
│   ├── app/
│   ├── models/
│   ├── schemas/
│   ├── services/
│   ├── routes/
│   ├── database/
│   ├── main.py
│   └── pyproject.toml
│
├── rag/
│   ├── ingestion/
│   ├── embeddings/
│   ├── retrievers/
│   ├── vectorstore/
│   ├── services/
│   ├── models/
│   ├── main.py
│   └── pyproject.toml
│
├── docker-compose.yml
└── README.md
```

The exact structure may vary according to the final implementation.

---

## RAG System Overview

The backend system uses **Python, FastAPI, SQLAlchemy, MySQL, and the RAG service**.

The Python dependencies are managed using **uv**.

The overall architecture is:

```text
Flutter Application
        │
        │ REST API
        ▼
┌─────────────────────┐
│     FastAPI Server  │
│       :8000         │
└──────────┬──────────┘
           │
           ▼
    ┌─────────────┐
    │ RAG System  │
    |   :8000     │
    └──────┬──────┘
           │
     ┌─────┴─────┐
     ▼           ▼
   Chroma        LLM
```

---

## Back-End Server Overview

> The backend system uses **Python, FastAPI, SQLAlchemy, MySQL, and the RAG service**. The Python dependencies are managed using **uv**.

The overall architecture is:

```text
Flutter Application
        │
        │ REST API
        ▼
┌─────────────────────┐
│     FastAPI Server  │
│       :8000         │
└──────────┬──────────┘
           │
     ┌─────┴──────────┐
     │                │
     ▼                ▼
┌───────────┐   ┌─────────────┐
│   MySQL   │   │ RAG System  │
│   :3306   │   │    :8001    │
└───────────┘   └──────┬──────┘
                       │
                 ┌─────┴─────┐
                 ▼           ▼
              Chroma        LLM
```

---
