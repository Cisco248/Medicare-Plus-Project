# Parameter: diabetic (heart-disease survey status)

Heart-disease e-doc field: `diabetic`. Encoded feature: `Diabetic` as an index into: No; No, borderline diabetes; Yes (during pregnancy); Yes.

## What does it mean?

It is a four-level survey history of diabetes, not a mmol/L glucose value and not the hypertension `diabetes_ordinal` field.

## Why does the heart-disease model use it?

Diabetes is a major cardiovascular risk factor. Borderline diabetes and pregnancy-related diabetes are also captured because the training feature used those survey labels.

## Relationship with the diabetes model

The diabetes classifier uses glucose, BMI, BP, and other clinical-style features and outputs “Diabetic / High Risk” or “Non-Diabetic / Low Risk.” That output is not automatically written into this survey field.

## Limitations

Selecting “No” does not prove glucose is normal. Selecting “Yes” is not a new laboratory diagnosis.

## Sources

- WHO, Diabetes: <https://www.who.int/news-room/fact-sheets/detail/diabetes>
- CDC, About Diabetes: <https://www.cdc.gov/diabetes/about/index.html>
