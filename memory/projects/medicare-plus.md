# Medicare Plus

**Status:** Active final-year project

## Purpose

Medicare Plus is a supportive, personalized mobile healthcare application for clinical patients of government hospitals. It helps registered patients monitor and manage non-communicable diseases, initially focused on diabetes, hypertension, and heart disease.

The solution comprises:

- A backend server connected to the hospital database system.
- A RAG system.
- A Flutter Android application.
- A custom SDK for integrating Android mobile-health data.
- A human activity recognition (HAR) engine and prediction model.

## Users and Roles

### Patients

Patients become eligible after registering during an initial physical clinical session. Hospital staff then instruct them to set up Medicare Plus. Patients can view their own health information, monitor trends, review summaries and supported reports, access the pharmacy, and use the chatbot.

### Hospital clinical staff

Clinical-section staff, including nurses, update the hospital database from the initial session through monthly follow-up sessions. Those real-time data updates provide the patient information shown and used by the Medicare Plus system.

### Doctors

Doctors provide prescriptions. A prescription must be uploaded and approved before the patient can obtain medicines through the e-pharmacy.

## Core Features

1. **Medical chatbot:** Patients can ask medical questions and receive simple medical guidance. It is not a substitute for a doctor or professional diagnosis.
2. **Condition prediction and recommendations:** Models assess the three supported disease areas—diabetes, hypertension, and heart disease. Model predictions are passed to the RAG system, which produces medically grounded recommendations.
3. **Daily health summary:** A dashboard widget presents a daily summary based on patient information, predicted conditions, and activity data.
4. **Human activity tracking:** The HAR engine uses integrated mobile-health data to detect activity and store the latest six-hour activity/prediction timeline.
5. **Custom Android health-data SDK:** Connects suitable Android mobile-health data to the application models.
6. **Report uploader:** Patients can submit relevant reports such as diabetes and blood-pressure reports for tracking. At this stage, only diabetes, hypertension, and heart-disease reports may be stored in the hospital database; other report types must be rejected or kept outside that database workflow.
7. **E-pharmacy:** Patients can conveniently request or buy medicines, subject to doctor-prescription approval.

## End-to-End Workflow

1. The patient registers during an initial physical clinic session.
2. Nurses or other clinical staff add and update the patient’s information in the hospital database, initially and at monthly sessions.
3. Staff inform the patient to install and configure Medicare Plus.
4. The patient accesses their individual health data and monitoring features in the application.
5. The patient reviews disease-related information using previous reports and required custom parameters.
6. The condition models and HAR system generate predictions and activity information.
7. The RAG system turns relevant prediction, activity, and clinical context into a daily summary and recommendations.
8. The patient may use the chatbot for general/simple medical questions, while seeking a clinician for diagnosis or urgent care.
9. When a doctor supplies a prescription, it is uploaded and approved to enable the e-pharmacy flow.

## Data Flow and Boundaries

- The hospital database system is the authoritative source for patient clinical data and updates in real time.
- The mobile app contributes supported mobile-health/activity data through the custom SDK.
- The RAG system summarizes model predictions and daily activity information and powers contextual chatbot responses.
- Only the defined three disease categories are in scope for database-backed report uploads.

## Project Vocabulary

| Term | Meaning |
|---|---|
| RAG | Retrieval-augmented generation system for recommendations, summaries, and contextual chatbot service. |
| HAR | Human activity recognition engine/model processing mobile-health activity data. |
| Supported diseases | Diabetes, hypertension, and heart disease. |
| Clinical session | The initial registration session or scheduled monthly follow-up at the hospital clinic. |

## Future Context

The project owner may provide further requirements or corrections later. Treat this document as the current product narrative and update it when new validated details are supplied.
