# Parameter: diff_walking

Heart-disease e-doc field: `diff_walking`. Encoded feature: `DiffWalking` as 1 for yes/true/1, otherwise 0.

## What does it mean?

It records difficulty walking, a survey item often related to mobility, pain, breathlessness, or neurological problems. It is not a step count from a wearable.

## Why the model uses it

Difficulty walking is associated with poorer health status and cardiovascular disease in survey datasets. It does not by itself diagnose heart failure or peripheral artery disease.

## Limitations

Disability, arthritis, and temporary injury can produce a Yes without coronary disease. A No does not prove fitness.

## Sources

Defined by the heart-disease form and `HeartDiseaseMiddleware` encoder.
