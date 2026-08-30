# Parameter: HbA1c

Also called: A1C, glycated hemoglobin, hemoglobin A1c. Hypertension e-doc field: `hba1c` (percent). Model feature name: `hba1c_pct`. Numeric. Not used by the diabetes classifier (that model uses `glucose` instead). The RAG e-doc request maps this field as hemoglobin_count / HbA1c.

## Question: What is HbA1c?

### Answer

HbA1c is a blood test that reflects average glucose exposure over roughly the previous two to three months. It is reported as a percent (or as mmol/mol in some laboratories). It is not the same as a finger-stick glucose reading.

## Why is it important?

ADA diagnosis education uses laboratory HbA1c at or above 6.5% as one diagnostic criterion for diabetes, with 5.7% to 6.4% described as prediabetes. These are diagnostic laboratory thresholds, not emergency thresholds. Anaemia, kidney disease, and haemoglobin variants can make HbA1c misleading; a clinician decides.

## Why does the hypertension model use HbA1c?

The hypertension feature table includes `hba1c_pct` with age, BMI, cholesterol, diabetes ordinal, and sex. Glucose disorders and hypertension cluster. HbA1c is not a blood-pressure measurement.

## Value categories (laboratory education)

- Below 5.7%: often described in ADA screening education as not meeting prediabetes HbA1c criteria.
- 5.7–6.4%: ADA prediabetes HbA1c band.
- 6.5% or higher: ADA diabetes diagnostic HbA1c criterion, requiring clinical confirmation rules.

Individual treatment targets for people already diagnosed can differ and must come from the care team. Do not treat an e-doc HbA1c as a home glucose.

## Model interpretation

The hypertension model does not diagnose diabetes from HbA1c. The diabetes status dropdown is a separate encoded feature (`normal` 0, `pre-diabetic` 1, `diabetic` 2).

## Sources

- ADA, Diagnosis: <https://diabetes.org/about-diabetes/diagnosis>
- NICE NG28: <https://www.nice.org.uk/guidance/ng28>
- WHO, Diabetes: <https://www.who.int/news-room/fact-sheets/detail/diabetes>
