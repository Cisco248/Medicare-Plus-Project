# Hypertension FAQ

## What is hypertension?

Hypertension means blood pressure is persistently high. Also called high blood pressure, high BP, elevated BP. It is often symptomless.

## What is systolic pressure? What is diastolic pressure?

Systolic is the upper number; diastolic is the lower number. Unit mmHg.

## How is hypertension diagnosed?

Repeated validated measurements, sometimes home or ambulatory monitoring, plus clinical assessment (NICE NG136, AHA education). One e-doc result is not a diagnosis. The hypertension model does not even take a mmHg reading.

## How can I lower blood pressure?

Educational pillars include less sodium (WHO < 5 g salt/day for adults unless advised otherwise), vegetables and fruits, activity as able, weight management if overweight, limited alcohol, not smoking, sleep, and prescribed medicines if a clinician starts them. Do not stop tablets because you feel well.

## Is my blood pressure high? Is this BP dangerous?

See AHA educational categories (normal <120/<80; crisis-range >180 and/or >120 with symptoms is urgent). NICE often uses clinic 140/90 as a threshold to investigate further.

## Why does the hypertension e-doc ask for HbA1c and cholesterol?

Those are actual model features (`hba1c_pct`, `cholesterol_mgdl`) because glucose disorders and lipids cluster with hypertension risk.

## Why does it ask for diabetes status?

Feature `diabetes_ordinal` with values normal, pre-diabetic, diabetic.

## What does my hypertension prediction mean?

It is the class label from `risk_labels.pkl`. Not a NICE diagnosis.

## What should I do if my blood pressure is extremely high?

If readings are in a crisis-range and you have chest pain, severe headache, breathlessness, or neurological symptoms, contact emergency services. Otherwise remeasure with good technique and seek prompt clinical advice.

## Sources

WHO hypertension fact sheet; AHA readings page; NICE NG136; NHS high blood pressure page.
