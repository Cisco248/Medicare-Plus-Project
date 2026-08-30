# MediCare Plus Diabetes Prediction Model

## Purpose

The diabetes e-doc model estimates a binary risk class from submitted form values. It supports educational screening conversation. It is not a clinical diagnosis, not a WHO or ADA laboratory test, and not a treatment plan.

## Input parameters

Exact fields sent into the feature table before `features.pkl` column selection:

| Feature | Patient-friendly name | Type | Unit / format | Encoding | Scaling |
| --- | --- | --- | --- | --- | --- |
| age | Age | int | years | none | yes, diabetes scaler |
| gender | Gender | int after encode | male → 1, otherwise 0 | `gender_encoder` | yes |
| pulse_rate | Pulse rate | float | bpm | none | yes |
| systolic_bp | Systolic blood pressure | float | mmHg | parsed from `120/80` | yes |
| diastolic_bp | Diastolic blood pressure | float | mmHg | parsed from `120/80` | yes |
| glucose | Glucose | float | mmol/L on the form | none | yes |
| bmi | BMI | float | kg/m² | none | yes |
| family_diabetes | Family history of diabetes | int after encode | Yes/No | 1 if yes/true/1 else 0 | yes |
| hypertensive | Existing hypertension | int after encode | Yes/No | 1 if yes/true/1 else 0 | yes |

The Flutter form collects `bpReading` as a single string. The API schema accepts `bpReading` or split `systolic_bp` / `diastolic_bp`. Blood pressure is required.

## Preprocessing

Confirmed in `server/repository/routes/base_model_router.py`: a one-row pandas DataFrame is built, columns are ordered by `features.pkl`, then `scaler.transform` is applied. Missing values are not imputed in this path; the form requires the fields.

## Prediction

`model.predict` returns a class code. `model.predict_proba` provides confidence for that code. Labels from code:

- 1 → `Diabetic / High Risk`
- otherwise → `Non-Diabetic / Low Risk`

These strings are defined in `DiabetesMiddleware.risk_label`. They are model classes, not ADA diagnostic labels.

## Probability

The API returns `confidence` as the predicted-class probability rounded to four decimals. A high confidence on “Low Risk” does not prove the person is free of diabetes. A high confidence on “High Risk” does not prove diabetes.

## What a prediction means

A high-risk prediction means the classifier mapped the scaled feature vector to class 1. Clinicians may still need laboratory testing. A low-risk prediction means class 0. Symptoms, pregnancy, and type 1 diabetes can still require care.

## Why the e-doc asks for these parameters

The trained artifact expects this feature set. Asking extra medical questions that are not features would not change this model. Features that are absent (for example insulin dose, HbA1c, cholesterol) are not used by this classifier.

## Limitations

- Prediction ≠ diagnosis.
- Input quality matters: wrong units (mg/dL typed into a mmol/L field) can distort the vector.
- Training data, false positives, false negatives, and population differences are not published in the app code.
- The app does not display per-feature importance, so the chatbot must not invent “which parameter caused my risk.”
- One abnormal parameter cannot be said to establish diabetes; one typical parameter cannot guarantee absence of diabetes.

## RAG question used after prediction

The server sends a natural-language paragraph to `/api/e-doc` including age, gender, diagnosis label, glucose mmol/L, BMI, BP, family history, and hypertensive status, asking for simple explanation and lifestyle follow-up without diagnosing.

## Sources

Implementation: `DiabetesSchema`, `DiabetesMiddleware`, `POST /api-base/diabetes`.
Medical context: WHO diabetes fact sheet; ADA diagnosis page (for why glucose matters, not for claiming the model uses ADA rules).
