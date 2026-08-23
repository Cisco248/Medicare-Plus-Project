# Consumer Wearables and Daily Health Apps

## Real-world use case

Phones and watches now feed daily summaries used in this project: steps, distance, active minutes, estimated calories, optical heart rate, and inferred sleep. People treat the dashboard as a medical record. Consumer devices are useful trend tools when worn consistently; they are not a clinic visit.

## What reputable explainers report

Harvard Health has described wrist heart-rate sensors as generally usable at rest, with more error during some activities, and has noted that 10,000 steps is a marketing target rather than a required medical number. A later Harvard Health piece on wearable workouts explains that heart-rate zones on watches are usually based on age-estimated maximum heart rate and may not match an individual. Combining steps with average heart rate has been discussed in research blogs as an experimental fitness signal, not a diagnostic test.

CDC and WHO activity guidance is still based on minutes and muscle-strengthening days. Wearable “active minutes” use vendor definitions that may not match those guidelines.

## Practical limits

- Non-wear, dead batteries, and a phone left behind create missing data, not a sedentary diagnosis.
- Sleep stages, stress scores, blood-oxygen estimates, and “readiness” scores are proprietary and should not be presented as clinical sleep or cardiopulmonary tests.
- A device marketed for wellness is not automatically a validated medical blood-pressure or glucose device.
- Skin tone, tattoos, loose fit, cold skin, and motion all affect optical sensors.

## Safe interpretation

Prefer raw recorded fields (steps, minutes, mmHg, mg/dL or mmol/L, kg) over vendor wellness scores. Say when a value is device-estimated. Do not diagnose disease from a closed-ring day or a low readiness score. Escalate based on symptoms and validated measurements, not on a gamified badge.

## Sources

- Harvard Health, How accurate are wearable heart rate monitors?: <https://www.health.harvard.edu/heart-health/how-accurate-are-wearable-heart-rate-monitors>
- Harvard Health, Smarter, safer workouts with a wearable fitness tracker: <https://www.health.harvard.edu/heart-health/smarter-safer-workouts-with-a-wearable-fitness-tracker>
- Harvard Health, 10,000 steps a day — or fewer?: <https://www.health.harvard.edu/blog/10000-steps-a-day-or-fewer-2019071117305>
- CDC, What Counts as Physical Activity for Adults: <https://www.cdc.gov/physical-activity-basics/adding-adults/what-counts.html>
- WHO, Physical activity: <https://www.who.int/news-room/fact-sheets/detail/physical-activity>
