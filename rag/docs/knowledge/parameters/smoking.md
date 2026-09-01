# Parameter: smoking

Heart-disease e-doc field: `smoking`. Encoded feature: `Smoking` as 1 for yes/true/1, otherwise 0.

## What does it mean?

It records whether the person smokes (yes/no as encoded). Tobacco use is a major risk factor for coronary heart disease, stroke, and peripheral artery disease.

## Why does the e-doc ask?

The heart-disease model includes `Smoking` among encoded features. Quitting advice should come from a clinician; the chatbot should not prescribe nicotine products.

## Limitations

“No” does not erase past smoking history if the form only captures current yes/no. The implementation is a single yes/no encoder.

## Sources

- AHA prevention and lifestyle education: <https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/nutrition-basics/aha-diet-and-lifestyle-recommendations>
- WHO, Hypertension fact sheet (tobacco as a cardiovascular risk): <https://www.who.int/news-room/fact-sheets/detail/hypertension>
