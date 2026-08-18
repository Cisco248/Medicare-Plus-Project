# Diabetes Monitoring

## Important Measurements

Diabetes monitoring may involve:

- blood glucose
- HbA1c
- blood pressure
- lipid profile
- kidney health
- eye health
- foot health

## Wearable Data

Wearable data can provide supporting lifestyle information.

Examples:

- steps
- active minutes
- sleep
- heart rate

Wearable data must not replace clinical measurements.

## RAG Rule

If clinical measurements exist:

Clinical measurements
        >
Wearable measurements

## Missing Data

Missing data must be represented as:

"Not available"

Never assume:

"Normal"

when data is missing.
