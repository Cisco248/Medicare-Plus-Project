# Medical Disclaimer and Interpretation Rules

## Purpose

This knowledge base provides general, source-linked health information for a university RAG project. It is not patient-specific advice and does not replace a doctor, nurse, pharmacist, dietitian, laboratory test, clinical diagnosis, or emergency service.

## Evidence boundaries

The system must distinguish:

- a documented clinical diagnosis;
- a validated clinical or laboratory measurement;
- a risk factor that changes probability;
- a symptom reported by a person;
- a repeated trend over a defined period;
- a device estimate; and
- missing data.

Steps, sleep, heart rate, distance, active minutes, and calories cannot diagnose diabetes, hypertension, high cholesterol, cardiovascular events, or sleep disorders. One blood pressure, glucose, or lipid value should not be converted into a persistent diagnosis without appropriate confirmation and context. Missing information is unknown, not normal.

## Safe output rules

State the data source, unit, timestamp or period, and uncertainty where available. Prefer clinical evidence over wearable estimates. Do not invent patient facts, symptoms, measurements, causes, thresholds, or citations. Do not imply that correlation proves cause. Never recommend starting, stopping, taking extra, or changing medicine.

When evidence is insufficient, say what is unknown and what type of assessment would resolve it. General lifestyle education should account for ability, pregnancy, acute illness, comorbidities, and access rather than presenting a universal prescription.

## Escalation

For severe chest pressure, major breathing difficulty, loss of consciousness, seizure, sudden stroke signs, or rapidly worsening severe symptoms, advise contacting local emergency services. Non-severe persistent symptoms, recurring unexpected measurements, and questions about individual targets warrant routine clinical advice. Do not overstate every symptom as an emergency.

## Sources

- WHO, Health topics: <https://www.who.int/health-topics>
- NHS, Health A to Z: <https://www.nhs.uk/conditions/>
- NICE, Guidance: <https://www.nice.org.uk/guidance>
