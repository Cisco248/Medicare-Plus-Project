# Parameter: physical_health

Heart-disease e-doc field: `physical_health`. Encoded feature: `PhysicalHealth` as a float. Meaning in the RAG question: poor physical-health days in the last 30 days.

## What does it mean?

It is a count of days in the past month the person felt their physical health was not good. Typical survey range is 0 to 30. It is not BMI, not glucose, and not a diagnosis.

## Why the model uses it

More unhealthy days are associated with worse outcomes in population surveys. The scaler may transform this column if it is listed in `numeric_cols` in `model.json`.

## Value interpretation

0 means no such days were reported. Higher counts mean more days of poor physical health. There is no official diagnostic cutoff that equals heart disease.

## Limitations

Infection, injury, or mood can raise the number without coronary blockage.

## Sources

Defined by the heart-disease form and inference code (`physical_health` → `PhysicalHealth`).
