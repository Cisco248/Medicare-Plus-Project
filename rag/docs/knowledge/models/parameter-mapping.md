# Model Parameter Mapping

This mapping uses the actual inference code. It does not invent extra features.

## Diabetes model parameter mapping

| Model feature | Patient-friendly name | Medical concept | Unit | Source | RAG document | Preprocessing | Prediction usage |
| --- | --- | --- | --- | --- | --- | --- | --- |
| age | Age | chronological age | years | profile | parameters/age.md | scaled | diabetes classifier |
| gender | Gender | encoded sex | 1=male, 0=other | profile | parameters/gender.md | encoded then scaled | diabetes classifier |
| pulse_rate | Pulse rate | heart beats per minute | bpm | form / Health Connect | parameters/pulse_rate.md | scaled | diabetes classifier |
| systolic_bp | Systolic BP | systolic pressure | mmHg | form 120/80 | parameters/systolic_bp.md | parsed then scaled | diabetes classifier |
| diastolic_bp | Diastolic BP | diastolic pressure | mmHg | form 120/80 | parameters/diastolic_bp.md | parsed then scaled | diabetes classifier |
| glucose | Glucose | blood glucose | mmol/L | form | parameters/glucose.md | scaled | diabetes classifier |
| bmi | BMI | weight / height² | kg/m² | profile calc | parameters/bmi.md | scaled | diabetes classifier |
| family_diabetes | Family history | familial diabetes risk | yes/no | checkbox | parameters/family_diabetes.md | 0/1 then scaled | diabetes classifier |
| hypertensive | Hypertensive | known hypertension | yes/no | checkbox | parameters/hypertensive.md | 0/1 then scaled | diabetes classifier |

Output: pred_code 0 or 1 → Non-Diabetic / Low Risk or Diabetic / High Risk, plus probability confidence.

## Hypertension model parameter mapping

| Model feature | Patient-friendly name | Medical concept | Unit | Source | RAG document | Preprocessing | Prediction usage |
| --- | --- | --- | --- | --- | --- | --- | --- |
| age | Age | chronological age | years | profile | parameters/age.md | none in code | hypertension classifier |
| bmi | BMI | derived from height, weight | kg/m² | calculated | parameters/bmi.md | height cm, weight kg | hypertension classifier |
| hba1c_pct | HbA1c | average glucose exposure | % | form | parameters/hba1c.md | none in code | hypertension classifier |
| cholesterol_mgdl | Cholesterol | blood cholesterol | mg/dL | form | parameters/cholesterol.md | none in code | hypertension classifier |
| diabetes_ordinal | Diabetes status | normal / pre-diabetic / diabetic | 0 / 1 / 2 | dropdown | parameters/diabetes_ordinal.md | encoder | hypertension classifier |
| sex_male | Gender | encoded sex | 1=male | profile | parameters/gender.md | encoder | hypertension classifier |

Form also sends height and weight, which are not separate model columns after BMI is computed. Output label text comes from `risk_labels.pkl` and must be read from the artifact, not guessed.

## Heart-disease model parameter mapping

| Encoded feature | Patient-friendly name | Medical concept | RAG document | Preprocessing |
| --- | --- | --- | --- | --- |
| AgeCategory | Age group | age band 18–24 … 80 or older | parameters/age_category.md | index |
| Sex | Sex | male=1 | parameters/sex.md | binary |
| BMI | BMI | kg/m² | parameters/bmi.md | optional scaler if numeric |
| GenHealth | General health | Poor … Excellent | parameters/gen_health.md | index |
| Diabetic | Diabetes survey status | four survey labels | parameters/diabetic.md | index |
| Smoking | Smoking | yes/no | parameters/smoking.md | binary |
| Stroke | Previous stroke | yes/no | parameters/stroke.md | binary |
| DiffWalking | Difficulty walking | yes/no | parameters/diff_walking.md | binary |
| PhysicalHealth | Poor physical-health days | days in last 30 | parameters/physical_health.md | optional scaler |

Output: probability versus `recommended_threshold` (default 0.6) → High or Lower heart-disease risk.

## Shared medical concepts that are not always model features

| Concept | Diabetes model | Hypertension model | Heart-disease model |
| --- | --- | --- | --- |
| Glucose mmol/L | yes | no | no |
| HbA1c | no | yes | no |
| Blood pressure mmHg | yes | no | no |
| Cholesterol | no | yes | no |
| Smoking | no | no | yes |
| Insulin dose | no | no | no |
