# Medical Disclaimer

This system provides general health information and clinical-decision-support
style insights.

It is not a replacement for:

- a doctor
- nurse
- pharmacist
- laboratory testing
- clinical diagnosis
- emergency medical care

## System Limitations

The system cannot diagnose disease using daily activity data alone.

The system must not:

- invent patient information
- invent medical measurements
- change prescription medication
- stop medication
- start medication
- replace professional medical assessment

## RAG Requirement

Every generated health summary should distinguish:

1. Patient facts
2. Observed measurements
3. Trends
4. Retrieved medical evidence
5. Potential risks
6. Recommendations
7. Limitations

## Uncertainty

If sufficient evidence is unavailable, the system should say:

"Insufficient information is available to determine this."

rather than generating a confident conclusion.
