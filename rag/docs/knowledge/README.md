# Medicare Plus Health Knowledge Base

## Purpose

This directory contains general, evidence-based source material for the MediCare Plus RAG chatbot, e-doc explanations, and daily summaries. It covers diabetes, hypertension, heart disease, cholesterol, health parameters used by the prediction models, diet, medicines (class-level), emergencies, and wearable daily-summary fields. It is not a clinical record, diagnostic tool, or substitute for professional care. Sample patient files and named patient values are not part of this collection.

## Folder map

- `diabetes/`, `hypertension/`, `heart_disease/`, and `cholesterol/`: condition definitions, types, causes, diagnosis, management, diet, medicines, complications, and warning signs.
- `parameters/`: one topic per e-doc/model feature (glucose, BMI, blood pressure, HbA1c, cholesterol, survey items, and related concepts such as insulin).
- `models/` and `e_doc/`: actual MediCare Plus model features, preprocessing, outputs, and form explanations.
- `combinations/` and `cross_disease/`: multi-parameter and multi-disease relationships.
- `faq/`: many natural-language question phrasings for retrieval.
- `medications/` and `diet/`: class-level medicine education and eating-pattern notes, including Sri Lankan/South Asian examples.
- `physical_activity/`: cross-condition activity concepts, sedentary behavior, and population guidelines.
- `daily_use_cases/`: interpreting one recorded day, steps, calories, and workout intensity.
- `heart_rate/`, `body_metrics/`, `monitoring/`, `wearables/`: daily-summary fields people actually record.
- `sleep/`: sleep and chronic disease, plus daily sleep tracking.
- `safety/`: emergency escalation and the medical disclaimer.
- `SOURCES.md`: governed source register (not ingested as knowledge).
- `VERSION.md`: scope and release history.
- `../knowledge_urls.txt`: live pages fetched at RAG startup.

## Intended RAG behavior

Retrieval should separate these concepts:

1. A **diagnosis** is established through appropriate clinical assessment, not inferred by the model.
2. A **risk factor** changes probability but does not prove disease.
3. A **symptom** is a reported experience and may have many causes.
4. A **trend** is a repeated change relative to a defined period or personal baseline.
5. A **model prediction** is a classifier output, not a diagnosis.
6. A **reference range**, **diagnostic threshold**, **risk category**, and **emergency threshold** are not the same.
7. **Missing data** means unknown, never normal or absent.
8. **Dynamic patient values** belong in the live question or `patient_context` field, not in these static files.

Clinical diagnoses and validated clinical or laboratory measurements take priority over wearable estimates. Steps, active minutes, sleep, calories, and heart rate can add lifestyle context but cannot diagnose diabetes, hypertension, abnormal cholesterol, or a sleep disorder. One measurement should not be presented as a persistent condition.

If the knowledge base covers the topic, the chatbot should give a useful educational answer. It should not reply “I don’t know” for definitions, diet patterns, parameter meaning, or documented model features. It should still refuse to invent missing numbers, diagnoses, or doses.

## Metadata and content conventions

Each Markdown file uses a descriptive H1 title and self-contained H2 question sections suitable for chunk retrieval. Ingestion adds path-derived metadata (`disease`, `category`, `parameter`, `topic`, `model`) and a short context prefix on every chunk. Source links appear in each topic file; the full source title, organization, access date, and governance record are maintained in `SOURCES.md`.

RAG output should identify the measurement, unit, time period, source, and whether data are patient-reported, clinically measured, device-estimated, or missing. It should use calibrated language such as “is associated with,” “may support,” and “requires clinical assessment.” It must not invent measurements, diagnoses, medication use, or patient details.

## Safety hierarchy

1. Retrieve `safety/emergency_warning_signs.md` first when severe or rapidly worsening symptoms are present.
2. Recommend contacting local emergency services for emergency warning signs; do not delay for additional wearable data or another e-doc run.
3. Do not diagnose the cause or recommend starting, stopping, or changing medicine.
4. For non-emergency concerns, recommend routine clinical advice when symptoms persist, measurements repeatedly concern the user, or interpretation requires individual context.
5. Otherwise provide general, source-linked education with explicit uncertainty.

## Ingestion notes

- Ingest recursively as plain Markdown. Skip `README.md`, `SOURCES.md`, and `VERSION.md`.
- Also fetch live pages from `docs/knowledge_urls.txt`. A failed URL must not block local Markdown.
- Preserve headings and source URLs in chunks.
- Keep filename or relative path as metadata so condition, parameter, model, and safety scope remain available at retrieval time.
- Prefer heading-aware overlap so interpretation rules remain near the facts they qualify.
- Give safety documents higher retrieval priority and boost disease-matching chunks when the query names that disease.
- Deduplicate source-register text if URL-heavy chunks reduce retrieval quality.

## Limitations

Guidance is population-level and may not fit pregnancy, childhood, frailty, disability, acute illness, complications, or other individualized circumstances. Consumer wearables vary in accuracy and completeness. Guidelines and web pages change; follow the update policy in `SOURCES.md`. This collection contains no patient-specific advice or patient-identifying information.
