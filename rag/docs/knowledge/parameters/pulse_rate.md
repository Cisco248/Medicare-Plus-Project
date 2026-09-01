# Parameter: pulse_rate

MediCare Plus diabetes feature: `pulse_rate`. Display name: Pulse rate. Numeric. Unit: beats per minute (bpm). Encoded: none. Scaled: yes. Source: diabetes e-doc field, often prefilled from Health Connect heart rate.

## Question: What is pulse rate?

### Answer

Pulse rate is how many times the heart beats in one minute. It is related to heart rate. AHA education often describes a typical resting adult range of about 60 to 100 bpm, with athletic people sometimes lower. This is a reference discussion, not a diagnostic test for diabetes.

## Why does the diabetes model use pulse rate?

The trained diabetes feature list includes `pulse_rate`. Resting pulse is not a glucose measurement. It can reflect fitness, stress, fever, medicines, caffeine, or heart rhythm issues. The model still expects the number because that is how it was trained.

## What does a high or low pulse mean?

A high pulse can occur with exercise, anxiety, fever, dehydration, thyroid disease, or arrhythmia. A low pulse can be normal in fit people or related to medicines. Chest pain, fainting, or severe breathlessness with an unusual pulse needs urgent care. Do not diagnose a heart condition from the e-doc pulse field.

## Relationship with blood pressure

Pulse is not blood pressure. A normal pulse does not prove BP is normal.

## Sources

- AHA, All About Heart Rate: <https://www.heart.org/en/health-topics/high-blood-pressure/the-facts-about-high-blood-pressure/all-about-heart-rate-pulse>
