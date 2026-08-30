# Parameter: height

Hypertension e-doc field: `height` in centimetres. Used only to calculate BMI = weight / (height/100)². The hypertension model feature is `bmi`, not raw height. Diabetes and heart-disease forms use profile height to compute BMI on the client.

## What is height?

Standing height is how tall a person is. It is needed for BMI. It does not measure glucose or blood pressure.

## Missing values

If height is missing, BMI cannot be calculated and must stay unknown. Do not treat height 0 as real.

## Sources

- CDC, About Body Mass Index: <https://www.cdc.gov/bmi/about/index.html>
