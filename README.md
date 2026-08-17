# Medicare+ Application

## Table of Contents

- [Introduction](#introduction)
- [System Overview](docs/system_architecture.md)
- [Key Features](#key-features)
- [Technology Stacks](#technology-stack)
- [Prerequisites](#prerequisites)
- [Project APIs](docs/api.md)
- [Installation](docs/installation.md)
- [Security](#authentication--security)
- [Demo](#demo)
- [Future Enhancement](#future-enhancements)
- [Docker Container Service](#docker-service-addresses)
- [Screenshot](#screenshots)

## Introduction

**Medicare+** is a digital healthcare platform designed to support patients and healthcare professionals through continuous health monitoring, medical data management, intelligent health analysis, and digital healthcare services.

The application combines **mobile health monitoring, wearable/Health Connect data, AI-powered analysis, Retrieval-Augmented Generation (RAG), medical document management, e-pharmacy services, medication reminders, appointments, and digital prescriptions** into a unified healthcare platform.

The system is designed around a patient-centered architecture where health information can be collected from multiple sources and processed to provide meaningful insights to both patients and healthcare providers.

### Main Objectives

- Collect and manage patient health information digitally.
- Monitor health and activity information from supported devices.
- Store and track medical reports and documents.
- Provide AI-assisted health summaries and insights.
- Use RAG technology to generate context-aware responses from available health information.
- Support digital prescriptions and medication management.
- Provide e-pharmacy functionality for purchasing medicines.
- Support appointment and clinic-related information.
- Improve communication between patients and healthcare providers.
- Provide a scalable architecture for future healthcare services.

---

## Key Features

## 3.1 Patient Profile

Patients can manage their personal and healthcare-related information.

Features include:

- Personal information
- Patient identification information
- Clinical history
- Medical information
- Profile management
- Account settings

---

### 3.2 Health Monitoring

The application can collect health and activity information from supported health data sources.

Examples include:

- Steps
- Calories
- Physical activity
- Heart-related measurements where supported
- Sleep-related information where supported
- Other Health Connect-compatible data

The collected information can be processed by the backend and used for health summaries and analytics.

---

### 3.3 Health Dashboard

The dashboard provides a centralized view of the patient's current health information.

Typical dashboard components include:

- Daily activity
- Health statistics
- Recent medical information
- Health summaries
- Medication information
- Upcoming appointments
- Recent reports
- Important notifications

---

### 3.4 Medical Reports & Documents

Patients can upload and manage medical documents.

Supported use cases include:

- Uploading medical reports
- Viewing uploaded documents
- Tracking medical documents
- Storing report metadata
- Retrieving previous reports
- Processing documents for AI/RAG workflows

The document management functionality provides a centralized location for patient medical records.

---

### 3.5 AI Health Summary

The application can collect relevant health information and send it to the AI/RAG layer for generating a summarized interpretation.

The workflow can be represented as:

```text
Health Data
    │
    ▼
Data Collection
    │
    ▼
Backend Processing
    │
    ▼
RAG Retrieval
    │
    ▼
LLM Processing
    │
    ▼
Health Summary
    │
    ▼
Mobile Application
```

The generated information is intended to assist users in understanding their available health data and should not replace professional medical diagnosis.

---

### 3.6 RAG-Based Healthcare Assistant

Medicare+ includes a Retrieval-Augmented Generation architecture.

The RAG system can retrieve relevant information from available healthcare documents and data before generating an AI response.

### RAG Pipeline

```text
Medical Documents
       │
       ▼
Text Extraction
       │
       ▼
Text Chunking
       │
       ▼
Embeddings
       │
       ▼
Vector Database
       │
       ▼
Retriever
       │
       ▼
Relevant Context
       │
       ▼
LLM
       │
       ▼
Generated Response
```

### Main RAG Components

- Document ingestion
- Text extraction
- Text splitting
- Embedding generation
- Vector storage
- Hybrid retrieval
- Context construction
- LLM response generation

The system can use technologies such as:

- LangChain
- Chroma
- Hugging Face embeddings
- Sentence Transformers
- Ollama or another compatible LLM service

---

### 3.7 E-Doctor

The E-Doctor functionality supports digital interaction between patients and healthcare services.

Potential functionality includes:

- Doctor information
- Patient clinical information
- Appointment information
- Digital prescriptions
- Medical history
- Healthcare communication

---

### 3.8 E-Pharmacy

The E-Pharmacy module provides a digital medicine-shopping workflow.

Features include:

- Browse medicines
- Search medicines
- View medicine details
- Add medicines to cart
- Update quantities
- Remove medicines
- View cart
- Calculate total
- Demo checkout
- Order confirmation

The current purchasing workflow can be implemented as a **demonstration purchase flow** rather than a production payment gateway.

---

### 3.9 Medication Reminders

The application can help patients keep track of prescribed medication schedules.

Possible information includes:

- Medicine name
- Dosage
- Frequency
- Reminder time
- Prescription information
- Medication status

---

### 3.10 Appointment Management

Patients can manage healthcare appointments.

Features may include:

- View appointments
- Appointment details
- Appointment date and time
- Doctor information
- Clinic information
- Appointment status

---

### 3.11 Notifications

The application provides notifications for important healthcare events.

Examples:

- Medication reminders
- Appointment reminders
- Clinic announcements
- Health-related alerts
- System notifications

---

## Technology Stack

### Frontend

- Flutter
- Dart
- Riverpod
- Dio
- GoRouter
- Flutter Secure Storage
- Shared Preferences
- Health Connect integration

### Backend

- Python
- FastAPI
- SQLAlchemy
- Pydantic
- MySQL
- Uvicorn
- `uv` for Python dependency and environment management

### AI / RAG

- Python
- LangChain
- Chroma
- Hugging Face
- Sentence Transformers
- Embeddings
- LLM integration
- Ollama where applicable

### Development & Deployment

- Git
- GitHub
- Docker
- Docker Compose
- Linux/Ubuntu
- Android Emulator / Physical Android Device

---

## Prerequisites

Before installing Medicare+, make sure the development environment contains:

### Required

- Python 3.11 or newer
- Flutter SDK
- Dart SDK
- Android Studio
- Android SDK
- Android Emulator or physical Android device
- Docker

### RAG System Requirements

Install the following software:

- Python 3.11 or newer
- uv
- Git

### Back-End Server Requirements

Install the following software:

- Python 3.11 or newer
- uv
- MySQL

---

## Authentication & Security

The application should protect patient information through appropriate authentication and authorization mechanisms.

Security considerations include:

- User authentication
- Password protection
- Token-based authorization
- Secure local storage
- HTTPS in production
- API authorization
- Input validation
- Database access control
- Protection of sensitive medical documents
- Secure environment variables

Sensitive credentials must never be hard-coded into the application.

---

## Demo

The application can be demonstrated using the following workflow.

## Demo 1 — Authentication

1. Launch the application.
2. Register a user account.
3. Log in.
4. Verify authentication state.
5. Navigate to the dashboard.

## Demo 2 — Health Monitoring

1. Open the Health Dashboard.
2. Connect/use Health Connect.
3. Grant required permissions.
4. Read available health information.
5. Display activity data.
6. Send relevant data to the backend.

## Demo 3 — Medical Reports

1. Open Medical Reports.
2. Select a document.
3. Upload the report.
4. View the uploaded report.
5. Verify document tracking.

## Demo 4 — AI Health Summary

1. Open the health summary widget.
2. Collect available health information.
3. Send the relevant context to the backend/RAG system.
4. Retrieve relevant information.
5. Generate an AI-based summary.
6. Display the result in the application.

## Demo 5 — E-Pharmacy

1. Open E-Pharmacy.
2. Search for a medicine.
3. View medicine details.
4. Add the medicine to the cart.
5. Change the quantity.
6. View the cart total.
7. Continue to checkout.
8. Complete the demonstration purchase.
9. Display the order confirmation.

## Demo 6 — Appointments

1. Open Appointments.
2. View available appointments.
3. Select an appointment.
4. View appointment details.
5. Confirm the appointment.

---

## Future Enhancements

Potential future improvements include:

- Real payment gateway integration
- Real pharmacy order fulfillment
- Doctor-to-patient communication
- Video consultations
- Advanced predictive analytics
- Real-time IoT monitoring
- MQTT-based sensor integration
- Automated medical-report OCR
- Multilingual AI assistant
- Sinhala/Tamil/English healthcare support
- Advanced clinical dashboards
- Emergency health alerts
- Cloud deployment
- Role-based access control
- Audit logging
- Advanced analytics
- Production-grade monitoring

---

## Demo Account

For demonstration purposes, a dedicated test account can be configured.

```text
Username: demo@example.com
Password: <demo-password>
```

> Replace these values with the actual demo credentials before publishing the documentation. Never publish real user credentials.

---

## Docker Service Addresses

When services run in the same Docker network, use service names:

| Service | Address              |
| ------- | -------------------- |
| FastAPI | `backend-server:8080`|
| MySQL   | `mysql-server:3306`  |
| RAG     | `rag-system:8000`    |
| Chroma  | `chroma-server:8000` |

---

## Screenshots

Recommended screenshots for the project documentation:

1. Login screen
2. Registration screen
3. Home dashboard
4. Health monitoring dashboard
5. Health summary
6. Medical reports
7. E-Doctor
8. E-Pharmacy
9. Shopping cart
10. Demo checkout
11. Appointments
12. Prescription view
13. Medication reminders
14. Profile
15. Settings
16. RAG/AI response

---
