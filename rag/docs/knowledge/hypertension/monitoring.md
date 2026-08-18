# Hypertension Monitoring

## Primary Measurement

Blood pressure.

## Data Structure

Recommended:

{
    "systolic": 135,
    "diastolic": 85,
    "unit": "mmHg",
    "measured_at": "2026-08-18T08:00:00"
}

## Longitudinal Monitoring

Prefer:

7-day trend
14-day trend
30-day trend

over:

one measurement.

## Activity Relationship

Activity can provide lifestyle context.

It cannot replace blood-pressure measurements.

## RAG Rule

Never infer blood pressure from:

- steps
- calories
- heart rate
- sleep
