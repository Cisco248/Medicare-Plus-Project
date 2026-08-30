# Knowledge Base Version

## Current release

- Version: 2.0.0
- Release date: 2026-08-31
- Content access date: 2026-08-31

## Scope

Version 2.0.0 keeps the governed educational material for diabetes, hypertension, cholesterol, physical activity, sleep, monitoring, and safety, and adds parameter-aware, model-aware, and e-doc knowledge so the chatbot can explain submitted health values without treating a prediction as a diagnosis.

Covered model features are taken from the running inference code:

- Diabetes: age, gender, pulse_rate, systolic_bp, diastolic_bp, glucose (mmol/L), bmi, family_diabetes, hypertensive; scaler; labels Diabetic / High Risk versus Non-Diabetic / Low Risk.
- Hypertension: age, bmi (from height and weight), hba1c_pct, cholesterol_mgdl, diabetes_ordinal, sex_male; labels from `risk_labels.pkl` (wording not invented here).
- Heart disease: AgeCategory, Sex, BMI, GenHealth, Diabetic, Smoking, Stroke, DiffWalking, PhysicalHealth; probability versus threshold (default 0.6).

Startup also ingests live pages listed in `docs/knowledge_urls.txt`. Sample or demo data files are not used. Named patient values are not stored in static documents.

The release does not provide individualized treatment plans, medication doses, diagnostic decision rules that replace a clinician, or country-specific emergency numbers.

## Changelog

### 2.0.0 - 2026-08-31

- Added parameter documents for every confirmed e-doc/model feature, plus insulin as a related concept.
- Added model, e-doc, mapping, combination, FAQ, heart-disease, medication-class, and South Asian diet files.
- Expanded diabetes diagnosis, management, types, causes, complications, emergencies, and diet Q&A so common chatbot questions retrieve an answer instead of “I don’t know.”
- Documented value-interpretation concepts (reference versus diagnostic versus risk versus emergency) without claiming that a single parameter diagnoses disease.

### 1.1.0 - 2026-08-23

- Added daily-use-case, heart-rate, body-metric, home-monitoring, wearable, and sleep-tracking topic files grounded in public agency pages and reputable health-organization blogs.
- Added `docs/knowledge_urls.txt` so RAG startup can fetch those live pages.
- URL ingest is resilient: one failed fetch does not block Markdown knowledge.

### 1.0.0 - 2026-08-18

- Established the 33-file governed knowledge-base structure.
- Expanded condition content into separate overview, risk, symptom, activity, diet, sleep, monitoring, and warning-sign topics.
- Added cross-condition activity, sedentary behavior, sleep, emergency, and disclaimer guidance.
- Added authoritative source links, retrieval conventions, uncertainty rules, and an update policy.
- Consolidated useful material from the earlier partial knowledge base and removed superseded files.
