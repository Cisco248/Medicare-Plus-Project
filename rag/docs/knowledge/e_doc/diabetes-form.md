# Diabetes E-Doc Form

## Fields the form actually collects

Pulse rate (bpm), blood pressure (120/80), glucose (mmol/L if known), family history of diabetes (checkbox), hypertensive from recorded conditions (checkbox). Age, gender, and BMI come from the clinical snapshot/profile.

## Why each field?

- Pulse rate: diabetes model feature `pulse_rate`.
- Blood pressure: features `systolic_bp` and `diastolic_bp`.
- Glucose: feature `glucose` in mmol/L.
- Family history: feature `family_diabetes`.
- Hypertensive: feature `hypertensive`.
- Age, gender, BMI: features `age`, `gender`, `bmi`.

## Outputs

`Diabetic / High Risk` or `Non-Diabetic / Low Risk`, plus `confidence`. Recommendations come from RAG using those values.

## Common questions

- What do these parameters have to do with diabetes? Glucose is central; BMI, age, family history, and blood pressure are associated risk features the trained model also uses.
- Does a positive prediction mean I have diabetes? No. It means class 1 of this classifier.
- Which parameter is most important? The app does not expose feature importance. Do not invent a ranking.
