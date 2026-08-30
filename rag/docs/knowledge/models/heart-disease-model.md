# MediCare Plus Heart-Disease Prediction Model

## Purpose

The heart-disease e-doc model estimates probability of the positive class from encoded survey-style features, then compares it with a threshold from `model.json` (default 0.6 if missing). Labels:

- probability ≥ threshold → `High heart-disease risk`
- otherwise → `Lower heart-disease risk`

This is not a diagnosis of coronary artery disease, heart attack, or heart failure.

## Input parameters

| Form field | Encoded name | Encoding |
| --- | --- | --- |
| age_category (or age in years) | AgeCategory | index 0–12 in the listed age bands |
| sex | Sex | 1.0 male, else 0.0 |
| bmi | BMI | float |
| gen_health | GenHealth | Poor, Fair, Good, Very good, Excellent |
| diabetic | Diabetic | No; No, borderline diabetes; Yes (during pregnancy); Yes |
| smoking | Smoking | yes → 1 else 0 |
| stroke | Stroke | yes → 1 else 0 |
| diff_walking | DiffWalking | yes → 1 else 0 |
| physical_health | PhysicalHealth | float, poor physical-health days in last 30 days |

After encoding, columns are selected using `features.json` (`selected_features` or `features`). Numeric columns listed in `model.json` `numeric_cols` are passed through `scaler.transform`.

## Prediction

`predict_proba` column 1 is the positive-class probability. `recommended_threshold` defaults to 0.6. API also returns `pred_code` 1 or 0, `confidence` (the probability), and `threshold`.

## What the model does not use

It does not use mmol/L glucose, clinic blood pressure, cholesterol, or ECG. Those may still matter clinically.

## Limitations

- Survey items are self-reported.
- Threshold 0.6 is an implementation default, not a universal medical law.
- High probability is not a heart-attack diagnosis.
- Lower risk is not a guarantee.
- Chest pain, severe breathlessness, collapse, or stroke signs need emergency services regardless of the score.

## Sources

Implementation: `HeartDiseaseSchema`, `HeartDiseaseMiddleware`, `POST /api-base/heart-disease`.
Medical context: AHA heart-attack and stroke symptoms; WHO hypertension and diabetes fact sheets (for clustered risk).
