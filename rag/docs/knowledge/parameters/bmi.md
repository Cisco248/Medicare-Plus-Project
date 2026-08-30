# Parameter: BMI

Also called: body mass index. MediCare Plus feature name: `bmi` (diabetes and heart-disease models). Hypertension model uses BMI calculated from height and weight as feature `bmi`. Display name: BMI. Data type: numeric float. Unit: kg/m². Calculated as weight in kilograms divided by height in metres squared.

## Question: What is BMI?

### Answer

BMI is a screening number from height and weight. CDC describes it as a measure of weight relative to height, not a diagnosis of disease and not a direct measure of body fat.

## Question: What does my BMI mean?

### Answer

For adults 20 years and older, CDC groups BMI as underweight (below 18.5), healthy weight (18.5 to 24.9), overweight (25.0 to 29.9), and obesity (30.0 or greater), with further obesity classes at 30, 35, and 40. WHO discusses overweight and obesity as population issues associated with higher risk of type 2 diabetes, cardiovascular disease, and some cancers.

### Important safety information

These are screening categories, not a diagnosis of “obesity disease” and not a personal target. Muscular people can have a high BMI without excess fat. Age, sex, and ancestry can change how BMI relates to risk.

## Question: Is my BMI high?

### Answer

If adult BMI is 25.0 to 29.9, CDC labels that overweight. If it is 30.0 or greater, CDC labels that obesity. “High” in conversation often means those categories. It still does not diagnose diabetes or heart disease.

## Question: Why does the diabetes model use BMI?

### Answer

The diabetes e-doc sends `bmi` as a numeric feature, then scales it with the other features. Higher BMI is associated with insulin resistance and type 2 diabetes risk in population studies. The model does not output a BMI-only decision.

## Question: Why does the e-doc ask for BMI?

### Answer

Diabetes and heart-disease forms use profile height and weight to compute BMI. The hypertension form sends height and weight; the server calculates BMI as weight / (height/100)² before prediction. If height or weight is missing, BMI is unknown and should not be treated as zero.

## Low, reference, and high values

- Low BMI (underweight category) can reflect undernutrition, illness, or other causes and needs clinical context.
- 18.5–24.9 is the CDC adult “healthy weight” screening band, not a guarantee of metabolic health.
- 25–29.9 and ≥30 are associated with higher average cardiometabolic risk. They are risk-related screening bands, not diagnostic thresholds for diabetes.

## Relationship with glucose, blood pressure, and heart disease

Higher BMI can be associated with higher glucose, blood pressure, and cardiovascular risk, but people with typical BMI can still have diabetes or hypertension. The heart-disease model also uses `BMI` after encoding other survey features.

## Lifestyle and medication

Activity and eating patterns can change weight over time. Medicines should not be started or stopped because of BMI category alone.

## Model interpretation

BMI is one feature among several. A BMI of 31 does not by itself mean the diabetes prediction must be high risk. A BMI of 22 does not guarantee low risk.

## Frequently asked questions

- What does a BMI of 31 mean? In CDC adult categories that is in the obesity screening range. It is associated with higher average diabetes and heart-disease risk. It is not a diagnosis.
- What does a BMI of 29.5 mean? That is in the overweight screening range.
- Can BMI diagnose diabetes? No.

## Sources

- CDC, About Body Mass Index: <https://www.cdc.gov/bmi/about/index.html>
- CDC, Adult BMI Categories: <https://www.cdc.gov/bmi/adult-calculator/bmi-categories.html>
- WHO, Obesity and overweight: <https://www.who.int/news-room/fact-sheets/detail/obesity-and-overweight>
