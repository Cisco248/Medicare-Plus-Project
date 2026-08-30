# Hypertension E-Doc Form

## Fields

Age, gender, height (cm), weight (kg) from profile; HbA1c (%); cholesterol (mg/dL); diabetes status dropdown (`normal`, `pre-diabetic`, `diabetic`).

## Why each field?

Height and weight exist to compute BMI. HbA1c and diabetes status capture glucose-disorder context. Cholesterol captures lipid context. Age and sex are demographic covariates. Current mmHg blood pressure is not an input to this model.

## Output

A label from `risk_labels.pkl`. Treat it as a model class, not a NICE diagnosis.
