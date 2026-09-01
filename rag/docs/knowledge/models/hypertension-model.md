# MediCare Plus Hypertension Prediction Model

## Purpose

The hypertension e-doc model maps submitted values to a stored class label from `risk_labels.pkl`. It is a risk-assessment classifier, not a clinic blood-pressure diagnosis and not a prescription.

## Input parameters (form)

| Form field | Type | Unit | Notes |
| --- | --- | --- | --- |
| age | int | years | passed through |
| height | float | cm | used only to compute BMI |
| weight | float | kg | used only to compute BMI |
| hba1c | float | percent | stored as `hba1c_pct` |
| cholesterol_mgdl | float | mg/dL | total-style cholesterol |
| diabetes_ordinal | str | normal / pre-diabetic / diabetic | encoded 0 / 1 / 2 |
| gender | str | male → sex_male 1 else 0 | `gender_encoder` |

## Derived and model table columns

BMI = weight / (height/100)². Feature columns prepared before `features.pkl` selection:

- age
- bmi
- hba1c_pct
- cholesterol_mgdl
- diabetes_ordinal (float 0–2)
- sex_male

No scaler is loaded on this path in `base_model_router.py`. Labels come from `labels[pred_code]` where labels are loaded from the artifact. The exact wording of those labels is stored in the pickle file and must not be invented here.

## What the model does not use

It does not take a systolic/diastolic reading as an input. Current blood pressure may still appear in daily health summaries from Health Connect. Pulse rate is not a hypertension-model feature.

## Prediction

`model.predict` returns an integer code used as an index into `risk_labels.pkl`. The API returns that string as `prediction`. RAG then explains the assessment using age, gender, height, weight, BMI, HbA1c, cholesterol, and diabetes status.

## Limitations

- A class label is not a NICE or AHA diagnosis of hypertension.
- BMI from self-entered height/weight inherits measurement error.
- HbA1c and the diabetes dropdown can disagree; the code does not reconcile them.
- False positives and false negatives are possible.
- Do not start or stop antihypertensives because of this output.

## Sources

Implementation: `HypertensionScehema`, `HypertensionMiddleware`, `POST /api-base/hypertension`.
Medical context: WHO hypertension fact sheet; NICE NG136; AHA blood-pressure readings page.
