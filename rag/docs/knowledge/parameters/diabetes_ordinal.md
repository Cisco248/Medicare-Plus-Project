# Parameter: diabetes_ordinal

Hypertension e-doc field: `diabetes_ordinal`. Allowed strings: `normal`, `pre-diabetic`, `diabetic`. Encoded to 0.0, 1.0, and 2.0. Feature name in the table: `diabetes_ordinal`. Not a laboratory result.

## What does this parameter mean?

It is the form’s diabetes-status category for the hypertension model. `normal` means the user selected no diabetes category, `pre-diabetic` means the prediabetes option, and `diabetic` means known diabetes. Encoding uses lowercase lookup; unknown strings default to 0 in code.

## Why does the hypertension e-doc ask for diabetes status?

Diabetes and hypertension cluster. The model includes this ordinal feature with HbA1c, cholesterol, age, BMI, and sex.

## Limitations

Selecting `diabetic` is not a new diagnosis. Selecting `normal` does not prove glucose is normal. HbA1c is a separate numeric field and can disagree with the dropdown; the chatbot should not invent a reconciliation rule.

## Sources

- WHO, Diabetes: <https://www.who.int/news-room/fact-sheets/detail/diabetes>
- ADA, Diagnosis: <https://diabetes.org/about-diabetes/diagnosis>
