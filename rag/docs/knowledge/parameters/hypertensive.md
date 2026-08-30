# Parameter: hypertensive

MediCare Plus diabetes feature: `hypertensive`. Display: Hypertensive from recorded conditions. Categorical yes/no. Encoded to 1 for yes/true/1, otherwise 0. Scaled with other features.

## What does this parameter mean?

It records whether the person is already known to have hypertension (high blood pressure as a condition), not the mmHg reading itself. The reading is stored separately as systolic and diastolic values.

## Why does the diabetes model need it?

Diabetes and hypertension frequently coexist and together raise cardiovascular and kidney risk. The trained model includes this flag plus the numeric BP features.

## Why does the e-doc ask for it?

The diabetes form checkbox can be prefilled from recorded conditions. It is a yes/no feature, not a BP diagnosis engine.

## Limitations

Checking Yes does not measure current control. Checking No does not prove blood pressure is normal. Do not start or stop BP medicine based on this checkbox.

## Sources

- WHO, Hypertension: <https://www.who.int/news-room/fact-sheets/detail/hypertension>
- WHO, Diabetes: <https://www.who.int/news-room/fact-sheets/detail/diabetes>
