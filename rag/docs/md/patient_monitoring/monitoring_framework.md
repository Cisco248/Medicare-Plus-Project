# Patient Monitoring Framework for Diabetes, Hypertension and Cholesterol

## Purpose
A monitoring system can combine clinical measurements with human activity data to identify trends and support patient education.

## Core data domains

### Diabetes
- Blood glucose
- HbA1c from clinical testing
- Meal context
- Physical activity
- Medication adherence when explicitly provided
- Hypoglycemia symptoms
- Weight

### Hypertension
- Systolic BP
- Diastolic BP
- Measurement time
- Measurement conditions
- Heart rate
- Symptoms
- Physical activity

### Cholesterol
- LDL
- HDL
- Triglycerides
- Total cholesterol
- Relevant cardiovascular risk factors

### Human activity
- Steps
- Active minutes
- Exercise sessions
- Sedentary duration
- Distance
- Heart rate
- Sleep duration estimates

## Trend-based reasoning
Prefer trends over isolated values.

Example:
`7-day activity trend decreasing + sedentary time increasing`

The system may respond:
"Your recent activity pattern has decreased. Regular activity is generally beneficial for metabolic and cardiovascular health. Consider discussing a safe activity goal with your healthcare professional."

It should not respond:
"Your diabetes is getting worse because you walked less."

## Context requirements
Before interpreting a clinical measurement, obtain:
- Unit
- Time
- Measurement method
- Relevant symptoms
- Repeated vs single measurement
- Known diagnosis
- Relevant medication context

## Device limitations
Consumer devices can have measurement error. Data can be missing, delayed or inaccurate.

RAG responses should clearly distinguish:
- User-entered clinical measurements
- Clinically validated device readings
- Consumer wearable estimates
- Inferred trends

## Safety escalation
The application should prioritize urgent medical evaluation when severe symptoms are reported, especially:
- Chest pain
- Severe shortness of breath
- Fainting or loss of consciousness
- New weakness or numbness
- New speech difficulty
- Severe confusion
- Severe or rapidly worsening illness
- Severe symptoms associated with markedly abnormal glucose or blood pressure

The exact emergency pathway depends on local healthcare services.

## Privacy
Health data should be handled according to applicable privacy, security and data-protection requirements. Store only information required for the application's purpose.

## Sources
- WHO, Diabetes: https://www.who.int/en/news-room/fact-sheets/detail/diabetes
- WHO, Hypertension: https://www.who.int/news-room/fact-sheets/detail/hypertension
- NICE NG136: https://www.nice.org.uk/guidance/ng136
- ADA Standards of Care 2026: https://diabetesjournals.org/care/issue/49/Supplement_1
