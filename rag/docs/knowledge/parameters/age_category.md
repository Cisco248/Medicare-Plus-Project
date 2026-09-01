# Parameter: age_category

Heart-disease e-doc field: `age_category`. Encoded feature: `AgeCategory` as a float index into this order: 18-24, 25-29, 30-34, 35-39, 40-44, 45-49, 50-54, 55-59, 60-64, 65-69, 70-74, 75-79, 80 or older. If the client sends `age` in years instead, the server maps it to a band.

## What does it mean?

It is a survey-style age group used by the heart-disease classifier, not a laboratory value. Older bands are associated with higher average cardiovascular risk in population data.

## Why does the e-doc ask for it?

The XGBoost heart-disease pipeline expects `AgeCategory` in the selected feature list from `features.json`.

## Limitations

An age band cannot diagnose coronary disease. Younger adults can still have heart disease, especially with smoking, diabetes, or other risks.

## Sources

- CDC, High Blood Pressure Risk Factors: <https://www.cdc.gov/high-blood-pressure/risk-factors/index.html>
- AHA heart attack and stroke symptoms: <https://www.heart.org/en/about-us/heart-attack-and-stroke-symptoms>
