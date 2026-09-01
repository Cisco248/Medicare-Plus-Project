# Cross-Disease Relationships

## Diabetes → Hypertension

High glucose over time is associated with stiffer vessels and kidney strain, which can raise blood pressure. Shared lifestyle factors also link them. The diabetes form therefore includes BP features; the hypertension form includes diabetes status and HbA1c.

## Diabetes → Heart Disease

Vascular injury, clustered lipids, kidney disease, and hypertension raise coronary and stroke risk. The heart-disease form includes a diabetic survey field.

## Hypertension → Heart Disease

High pressure loads the heart and arteries and contributes to heart attack, heart failure, and stroke.

## Hypertension → Diabetes

They share obesity and inactivity. Some people with hypertension later develop type 2 diabetes. The hypertension model’s diabetes_ordinal feature is history/status, not a crystal ball.

## All three together

Cardiometabolic clustering. See combinations/cardiometabolic_cluster.md.

## Why the e-doc collects both blood glucose and blood pressure (across forms)

Glucose mmol/L is required for the diabetes model. BP mmHg is required for the diabetes model. The hypertension model uses HbA1c instead of glucose and does not use mmHg. Together the app covers clustered risk without claiming one form measures everything.

## Sources

WHO diabetes and hypertension fact sheets; NICE NG28, NG136, NG238.
