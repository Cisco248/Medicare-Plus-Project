# Parameter: cholesterol_mgdl

Hypertension e-doc field and model feature: `cholesterol_mgdl`. Display: Cholesterol. Numeric. Unit: mg/dL. Not scaled in the hypertension inference path (no scaler is loaded for that model). Not a diabetes-model feature.

## Question: What does cholesterol mean?

### Answer

Cholesterol is a waxy substance in blood, carried in lipoproteins. Educational discussion often includes total cholesterol, LDL, HDL, and triglycerides. The hypertension form collects a single total-style cholesterol number in mg/dL.

## Why does the hypertension model use cholesterol?

Unfavorable lipids contribute to atherosclerotic cardiovascular risk, which clusters with hypertension. The model expects `cholesterol_mgdl` as a numeric covariate.

## Educational total cholesterol bands (CDC)

CDC educational categories for total cholesterol in adults often describe:

- less than 200 mg/dL as desirable
- 200–239 mg/dL as borderline high
- 240 mg/dL or more as high

These are screening labels, not a diagnosis of heart disease. Clinical decisions usually emphasize LDL, overall risk, and other factors (NICE NG238, AHA). Fasting status can affect triglycerides more than total cholesterol.

## Limitations

One number does not prove blocked arteries. HDL and LDL are not separate e-doc fields. Do not start or stop statins from a chatbot interpretation.

## Sources

- CDC, About Cholesterol: <https://www.cdc.gov/cholesterol/about/index.html>
- AHA, What Is Cholesterol?: <https://www.heart.org/en/health-topics/cholesterol/about-cholesterol>
- NICE NG238: <https://www.nice.org.uk/guidance/ng238>
