# Parameter: glucose

Also called: blood glucose, blood sugar, sugar level. MediCare Plus diabetes e-doc feature name: `glucose`. Display name: Glucose. Data type: numeric float. Unit on the form: mmol/L. Used by the diabetes prediction model. Scaled with the diabetes scaler before prediction.

## Question: What is glucose?

### Answer

Glucose is the main sugar in the blood and a major energy source for the body. In the app it is the blood-glucose value entered on the diabetes e-doc form.

### Medical meaning

Blood glucose reflects how much sugar is circulating. Insulin helps move glucose into cells. High glucose over time is the defining laboratory problem in diabetes. Low glucose can cause shakiness, confusion, or collapse, especially in people who use insulin or some other glucose-lowering medicines.

## Question: Why is glucose important for diabetes?

### Answer

Diabetes is defined by problems keeping blood glucose in a healthy range. That is why glucose is a core diabetes concept and why the diabetes prediction model includes a glucose feature.

## Question: Why does the diabetes model use glucose?

### Answer

The implementation sends `glucose` into the feature table with age, gender, pulse rate, systolic and diastolic blood pressure, BMI, family diabetes, and hypertensive status. The scaler then transforms that row before the classifier runs. Glucose is therefore one of the actual model inputs, not an optional note.

## Question: Why does the e-doc ask for glucose?

### Answer

The diabetes form needs the features the trained model expects. Glucose is a required numeric field. If it is missing, the form should not submit. The value can change with meals, illness, and time of day, so it is a snapshot, not a lifetime average.

## Question: What does my glucose value mean?

### Answer

Interpret the number with its unit, timing (fasting, after eating, or unknown), and symptoms. The e-doc hint is mmol/L. Laboratory diagnostic thresholds and home-meter readings are not the same thing.

### Explanation

ADA educational diagnostic thresholds for laboratory plasma glucose include fasting ≥ 7.0 mmol/L (126 mg/dL) and random ≥ 11.1 mmol/L (200 mg/dL) with classic symptoms. Those are diagnostic thresholds, not a rule that one e-doc number equals a diagnosis. ADA hypoglycaemia education uses an alert value below 3.9 mmol/L (70 mg/dL) for many people who monitor glucose.

### Unit notes

mmol/L × 18 is an approximate conversion to mg/dL (7.0 mmol/L ≈ 126 mg/dL; 11.1 mmol/L ≈ 200 mg/dL). A typed value of 180 is typical of mg/dL, not mmol/L. 180 mmol/L is not a plausible home glucose. If the unit is uncertain, say so rather than forcing a category.

## Value categories (educational, not a diagnosis)

These categories help explain submitted numbers. They do not diagnose diabetes.

- Low / concerning for hypoglycaemia: values below about 3.9 mmol/L (70 mg/dL), especially with sweating, shaking, confusion, or collapse, warrant the person’s hypo plan or emergency care.
- Typical fasting laboratory concept: fasting plasma glucose below 5.6 mmol/L (100 mg/dL) is often described as not meeting ADA prediabetes fasting criteria; this is a laboratory screening concept, not proof of health.
- Elevated fasting laboratory concept: 5.6 to 6.9 mmol/L (100 to 125 mg/dL) overlaps ADA prediabetes fasting education.
- High diagnostic-range laboratory concept: fasting ≥ 7.0 mmol/L or random ≥ 11.1 mmol/L with symptoms is in the ADA diabetes diagnostic conversation and needs clinical testing.
- After-meal home readings are expected to be higher than fasting readings; there is no single universal post-meal cutoff in this knowledge base that diagnoses diabetes.

## What does a high glucose value mean?

A high reading may be associated with diabetes, prediabetes, a recent meal, illness, stress, steroid medicines, or measurement error. It warrants clinical interpretation. It does not automatically establish a diagnosis.

## What does a low glucose value mean?

A low reading may be associated with insulin or certain tablets, missed meals, extra activity, or illness. Severe symptoms are an emergency.

## Relationship with hypertension and heart disease

High glucose over time is associated with higher cardiovascular and kidney risk. Blood pressure care still matters. The hypertension model uses HbA1c and a diabetes-status category rather than this glucose field. The heart-disease model uses a survey-style diabetic status field, not mmol/L glucose.

## Lifestyle, diet, and medication

Meals, sugary drinks, activity, illness, and medicines can move glucose. Do not change prescribed medicine from a chatbot interpretation.

## Model interpretation

A high glucose feature can contribute to a “Diabetic / High Risk” class, but the model uses all features together after scaling. The app does not output which single feature “caused” the prediction. One abnormal parameter cannot be said to be the only reason.

## Important limitations

A single glucose value cannot diagnose diabetes, rule it out, or prove medicine failure. Missing glucose is unknown, not normal.

## Frequently asked questions

- Is my glucose high? Compare unit and timing with the educational ranges above and seek clinical review for unexpected values.
- Can a normal glucose guarantee I do not have diabetes? No. Timing, HbA1c, and clinical assessment still matter.
- Can one high glucose mean I have diabetes? No. It may warrant tests; it is not an automatic diagnosis.

## Sources

- ADA, Diagnosis: <https://diabetes.org/about-diabetes/diagnosis>
- ADA, Checking Your Blood Sugar: <https://diabetes.org/health-wellness/medication/blood-glucose-testing-and-control/checking-your-blood-sugar>
- ADA, Hypoglycemia: <https://diabetes.org/living-with-diabetes/treatment-care/hypoglycemia>
- ADA, Hyperglycemia: <https://diabetes.org/living-with-diabetes/treatment-care/hyperglycemia>
- WHO, Diabetes: <https://www.who.int/news-room/fact-sheets/detail/diabetes>
