# Parameter: family_diabetes

MediCare Plus diabetes feature: `family_diabetes`. Display: Family history of diabetes. Categorical yes/no string. Encoded to 1 for yes/true/1, otherwise 0. Scaled with other features.

## Question: Why is family history important?

### Answer

Type 2 diabetes clusters in families because of genes and shared environments. CDC lists family history as a risk factor. A relative with diabetes raises probability; it does not prove the user has diabetes.

## Question: What does my pregnancy history mean for diabetes risk?

### Answer

Previous gestational diabetes is a separate recognized risk factor. The diabetes e-doc family-history checkbox is not a pregnancy-history field. The heart-disease form has a diabetic option “Yes (during pregnancy)” for survey-style diabetes status.

## Why does the e-doc ask for family history?

The checkbox becomes the `family_diabetes` feature. If unchecked, the encoder stores 0. Missing should not be treated as “no disease.”

## Model interpretation

A Yes value can contribute to predicted risk together with glucose and BMI. Family history alone cannot diagnose diabetes and cannot guarantee future diabetes.

## Sources

- CDC, Diabetes Risk Factors: <https://www.cdc.gov/diabetes/risk-factors/index.html>
- WHO, Diabetes: <https://www.who.int/news-room/fact-sheets/detail/diabetes>
