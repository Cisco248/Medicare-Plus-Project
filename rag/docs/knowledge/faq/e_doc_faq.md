# E-Doc and Model FAQ

## Why does the e-doc ask for my BMI? Why does the e-doc ask for glucose?

BMI is a feature of the diabetes and heart-disease models and is calculated for hypertension. Glucose is a diabetes-model feature in mmol/L.

## Why does the model need my age? Why does the model need my blood pressure?

Diabetes and hypertension models use age. The diabetes model uses systolic and diastolic mmHg. The hypertension model does not use a BP reading. The heart-disease model uses age bands, not BP.

## What do these parameters have to do with diabetes?

They are either core glucose biology (glucose) or associated risk markers the trained diabetes classifier includes.

## How does the diabetes model work?

Encode yes/no and gender, build a row, select `features.pkl` columns, scale, predict class 0/1, map to Low Risk / High Risk, attach probability.

## What parameters does the diabetes model use?

age, gender, pulse_rate, systolic_bp, diastolic_bp, glucose, bmi, family_diabetes, hypertensive.

## Is the prediction a diagnosis?

No. A machine-learning prediction is not the same as a clinical diagnosis.

## Why did my prediction change? Can incorrect input change the prediction?

Yes. Different numbers change the vector. Wrong units matter.

## What happens if a parameter is missing?

The diabetes and hypertension forms require their fields. Heart-disease requires age category or age plus the other listed fields.

## What does my prediction mean?

See e_doc/predictions.md and the model-specific files.

## Sources

Implementation files cited in models/*.md.
