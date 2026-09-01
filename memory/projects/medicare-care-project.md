# Medicare Care Project

**Status:** Active

## Purpose

A supportive, personalized medical application for registered clinical patients at government hospitals. It helps patients monitor and manage non-communicable diseases (NCDs), initially diabetes, hypertension, and heart disease.

## Product Components

- Backend server
- RAG system
- Flutter Android application
- Custom Android SDK that collects mobile health data
- Human Activity Recognition (HAR) engine and prediction model

## Hospital Data Source

- The hospital database system is the source of patient clinical data.
- Hospital clinical-section staff, including nurses, maintain and update this data.
- The system must receive these database updates in real time.

## Confirmed Features

1. **Medical chatbot:** Patients can ask medical questions through a chat interface supported by RAG. It provides general medical guidance for symptoms and questions; it does not replace a doctor or clinical consultation.
2. **Condition prediction and recommendations:** Three disease models predict patient conditions. Their predictions are passed to the RAG system to generate medical recommendations.
3. **E-pharmacy:** Doctors upload prescriptions to the system, allowing patients to obtain medicines for their conditions. Doctor-prescription approval is required before purchase/fulfilment; the exact workflow is still to be defined.
4. **Daily health summary:** A dashboard widget generates a daily patient health summary.
5. **Activity tracking:** The HAR engine processes patient activity and retains the latest six hours of timeline/prediction data.
6. **Custom mobile-health SDK:** Collects Android mobile health data for use by the application and its models.
7. **Document/report uploads:** Patients can upload reports only for the three supported basic models: diabetes, hypertension, and heart disease. Reports for other conditions must be rejected and must not be stored in the database.

## Data and Intelligence Flow

1. Hospital clinical-section staff maintain patient records in the hospital database, which updates in real time.
2. A patient registers at a government-hospital clinic and can then use the app.
3. The Android app and custom SDK collect mobile health data.
4. The HAR engine and disease models analyze the data to predict patient conditions.
5. The application creates daily activity and health summaries.
6. The RAG system summarizes model predictions and activity data, then provides recommendations and chatbot answers.
7. Supported diabetes, hypertension, and heart-disease reports add context for health tracking; unsupported reports are rejected and not stored.

## Patient Journey

1. The patient attends an initial in-person clinic session and is registered.
2. Clinical-section staff or nurses enter or update the patient's information in the hospital database, beginning at the initial session and continuing at each monthly session.
3. Hospital staff tell the patient how to set up the Medicare application.
4. After setup, the patient can view and monitor their own health information in the app.
5. The patient uses previous reports and required health parameters to understand their condition.
6. The RAG system provides a daily health summary and recommendations based on the available information and predictions.
7. The patient may use the chatbot for general medical guidance about symptoms or health questions. It is not a replacement for a doctor.
8. When a doctor provides a prescription, it is uploaded to the system so the patient can obtain the prescribed medicine through the e-pharmacy.

## Open Details

- Exact prescription approval workflow and who may approve prescriptions.
- Names and scope of the three disease-prediction models.
- Clinical safety rules, escalation paths, and whether recommendations require clinician review.
- User roles and permissions for patients, doctors, pharmacists, and hospital staff.
- Data-consent, privacy, retention, and security requirements.
