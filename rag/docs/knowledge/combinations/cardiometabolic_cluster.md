# Diabetes, Hypertension, and Heart Disease Together

## Shared risk factors

Obesity, physical inactivity, smoking, unhealthy diet, age, family history, high glucose, high blood pressure, and unfavorable lipids.

## Why the e-doc collects glucose-related and blood-pressure-related fields on different forms

Each model was trained on its own feature set. Glucose mmol/L is a diabetes-model feature. HbA1c and cholesterol are hypertension-model features. Smoking, stroke, and walking difficulty are heart-disease-model features. Collecting both glucose-related and pressure-related information across the app reflects clustered cardiometabolic risk, not a single super-model.

## Can multiple parameters together increase disease risk?

Yes, in population science, clustered risk factors raise average event rates. That still does not let the chatbot name a personal 10-year percent risk unless such a calculator is implemented (it is not in these three pickle models).

## Sources

- WHO diabetes, hypertension, obesity, and healthy-diet fact sheets
- NICE NG238 cardiovascular risk guidance
