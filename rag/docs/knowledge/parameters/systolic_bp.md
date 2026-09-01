# Parameter: systolic_bp

MediCare Plus diabetes model feature: `systolic_bp`. Numeric. Unit: mmHg. Encoded: none. Scaled: yes, with the diabetes scaler.

## What is systolic blood pressure?

Systolic pressure is the upper number in a reading such as 120/80. It is the pressure during heart contraction.

## Why it matters

Persistently high systolic pressure is associated with stroke, heart disease, and kidney disease. AHA educational categories use systolic bands such as below 120 (with diastolic below 80) as normal, 120–129 as elevated when diastolic is below 80, 130–139 as stage 1 when diastolic is not already higher, and 140 or more as stage 2.

## Model usage

The diabetes form stores systolic from the 120/80 string. It is required. It is not used as a standalone diagnosis.

## Sources

- AHA, Understanding Blood Pressure Readings: <https://www.heart.org/en/health-topics/high-blood-pressure/understanding-blood-pressure-readings>
