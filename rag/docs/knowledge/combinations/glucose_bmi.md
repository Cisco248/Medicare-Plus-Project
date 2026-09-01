# Glucose and BMI Relationship

## What glucose represents

Glucose is blood sugar. The diabetes e-doc stores it as `glucose` in mmol/L.

## What BMI represents

BMI is weight relative to height. The diabetes and heart-disease models use `bmi`. The hypertension model calculates BMI from height and weight.

## Why both may be relevant to diabetes risk

Higher BMI is associated with insulin resistance. Higher glucose is the laboratory hallmark of diabetes and prediabetes. Population studies often see them together. Either can be unusual without the other.

## Why the combination does not diagnose diabetes

ADA diagnostic criteria use laboratory glucose or HbA1c, not BMI. A BMI of 31 with glucose 5.0 mmol/L fasting is not a diagnosis. Glucose 11.5 mmol/L with BMI 22 still needs clinical testing.

## How the diabetes model uses them

Both features are scaled together with age, BP, pulse, family history, and hypertensive status. The app does not report which of the two dominated the score.

## Sources

- ADA, Diagnosis: <https://diabetes.org/about-diabetes/diagnosis>
- CDC, Adult BMI Categories: <https://www.cdc.gov/bmi/adult-calculator/bmi-categories.html>
- WHO, Obesity and overweight: <https://www.who.int/news-room/fact-sheets/detail/obesity-and-overweight>
