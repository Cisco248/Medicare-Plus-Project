# Parameter: gender / sex

Diabetes and hypertension models use `gender` encoded as `1` if the text is male (case-insensitive), otherwise `0` (`sex_male` in the hypertension feature table). Heart-disease encoding uses `Sex` as 1.0 for male and 0.0 otherwise.

## What is this parameter?

It is the sex/gender value from the patient profile used as a model covariate. It is not a laboratory test.

## Why do the models use it?

Cardiometabolic risk patterns differ on average by sex in training data. Encoding is binary in the current implementation: only the string `male` maps to 1. Values such as female or other map to 0. That is a software encoding limitation, not a clinical statement that other genders have zero risk.

## Limitations

Sex/gender does not diagnose diabetes, hypertension, or heart disease. The chatbot should not stereotype care from this flag.

## Sources

- CDC, Diabetes Risk Factors: <https://www.cdc.gov/diabetes/risk-factors/index.html>
- CDC, High Blood Pressure Risk Factors: <https://www.cdc.gov/high-blood-pressure/risk-factors/index.html>
