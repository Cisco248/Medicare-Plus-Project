# Parameter: age

MediCare Plus feature `age` (integer years) is used by the diabetes model (scaled) and the hypertension model (as `age`). The heart-disease model uses `age_category` bands instead of raw years, or maps years to a band if only `age` is sent.

## Question: What does age mean as a health parameter?

### Answer

Age is how many years a person has lived. It is not a lab test. Increasing age is associated with higher average risk of type 2 diabetes, hypertension, and cardiovascular disease.

## Question: Why is age used by the diabetes model?

### Answer

The diabetes e-doc sends `age` from the patient profile into the feature table. Age is a recognized type 2 diabetes risk factor. The scaler transforms it with the other numeric fields. Age cannot be modified by lifestyle, and it does not diagnose diabetes.

## Question: Why does the model need my age?

### Answer

Each trained classifier expects the same columns it saw in training. For diabetes and hypertension that column is `age` in years. For heart disease the encoded column is `AgeCategory` (0 for 18–24 up to 12 for 80 or older).

## Value interpretation

There is no “normal age.” Educational risk for type 2 diabetes increases in middle and older adulthood, but younger adults can still have diabetes, especially type 1 or other forms. A child-specific BMI chart is not used by these adult models.

## Model interpretation

Older age can contribute to a higher predicted risk class together with glucose, BMI, and other features. The app does not print an age-only explanation.

## Limitations

Age does not measure glucose or blood pressure. A young person with very high glucose still needs clinical care. An older person with typical glucose is not automatically diagnosed.

## Sources

- CDC, Diabetes Risk Factors: <https://www.cdc.gov/diabetes/risk-factors/index.html>
- WHO, Hypertension: <https://www.who.int/news-room/fact-sheets/detail/hypertension>
