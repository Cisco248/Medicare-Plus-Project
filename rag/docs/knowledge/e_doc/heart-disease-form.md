# Heart-Disease E-Doc Form

## Fields

Age category, sex, BMI, general health, diabetic survey status, smoking, previous stroke, difficulty walking, poor physical-health days in the last 30 days.

## Why each field?

These match the encoded XGBoost feature names. They are mostly survey and history items plus BMI.

## Output

`High heart-disease risk` or `Lower heart-disease risk` from probability versus threshold (default 0.6). Not an ECG, not a heart-attack diagnosis.

## Emergency

Chest pain, severe breathlessness, collapse, or stroke signs override any form result.
