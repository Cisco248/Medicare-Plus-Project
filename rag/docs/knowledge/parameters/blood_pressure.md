# Parameter: blood pressure (systolic_bp and diastolic_bp)

Also called: BP, high blood pressure reading. Diabetes e-doc collects a reading such as 120/80, then splits it into `systolic_bp` and `diastolic_bp` in mmHg. Both are numeric features in the diabetes model and are scaled before prediction. Display: Blood pressure.

## Question: What does blood pressure mean?

### Answer

Blood pressure is the force of blood against artery walls. It is written as systolic over diastolic, in mmHg. Systolic is the pressure when the heart contracts. Diastolic is the pressure when the heart relaxes.

## Question: Why is blood pressure included in my diabetes prediction?

### Answer

The diabetes model uses `systolic_bp` and `diastolic_bp` as actual features, plus a separate yes/no `hypertensive` flag. Diabetes and hypertension often occur together and share cardiovascular risk. Blood pressure does not measure glucose, but it is medically related and is in the trained feature list.

## Question: Why does the e-doc ask for blood pressure?

### Answer

The diabetes form requires a reading in the shape 120/80. The server parses that string if split numbers are missing. Missing blood pressure blocks prediction. Home and clinic readings can differ. One pair is a snapshot.

## Question: Is my blood pressure high? Is my blood pressure dangerous?

### Answer

AHA educational adult clinic categories:

- Normal: systolic less than 120 and diastolic less than 80 mmHg.
- Elevated: systolic 120–129 and diastolic less than 80.
- Hypertension stage 1: systolic 130–139 or diastolic 80–89.
- Hypertension stage 2: systolic 140 or higher or diastolic 90 or higher.
- Hypertensive crisis educational range: systolic over 180 and/or diastolic over 120, which needs urgent clinical attention especially with symptoms.

NICE NG136 uses clinic values of 140/90 mmHg or more as a common threshold to consider further measurement, with home or ambulatory confirmation often at 135/85 mmHg. These are guideline diagnostic pathways, not a single home reading diagnosis.

Crisis-range numbers with chest pain, severe headache, breathlessness, or neurological symptoms need emergency care, not another casual home check.

## What does a low reading mean?

Low blood pressure can be normal for some people or related to medicines, dehydration, or illness. Dizziness or fainting needs clinical advice. Do not stop blood-pressure medicine because of one low reading without professional advice.

## Relationship with diabetes and heart disease

High blood pressure increases stroke, heart, and kidney risk, especially with diabetes. The hypertension prediction model does not take a BP reading as an input; it uses age, BMI, HbA1c, cholesterol, diabetes status, and sex. Daily summaries may still record BP from Health Connect.

## Model interpretation

Elevated systolic or diastolic values can influence the diabetes risk class after scaling, together with glucose, BMI, and other features. The app does not state which BP number “caused” the prediction.

## Important limitations

One reading does not diagnose persistent hypertension. Caffeine, exercise, talking, cuff size, and anxiety can change a value. Wrist gadgets are less reliable than a validated upper-arm cuff.

## Sources

- AHA, Understanding Blood Pressure Readings: <https://www.heart.org/en/health-topics/high-blood-pressure/understanding-blood-pressure-readings>
- NICE NG136: <https://www.nice.org.uk/guidance/ng136>
- WHO, Hypertension: <https://www.who.int/news-room/fact-sheets/detail/hypertension>
- NHS, High blood pressure: <https://www.nhs.uk/conditions/high-blood-pressure-hypertension/>
