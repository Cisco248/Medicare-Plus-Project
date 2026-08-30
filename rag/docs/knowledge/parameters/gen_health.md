# Parameter: gen_health

Heart-disease e-doc field: `gen_health`. Encoded feature: `GenHealth` as an index into Poor, Fair, Good, Very good, Excellent.

## What does it mean?

It is self-rated general health, a survey item, not a lab test or a clinician’s examination.

## Why is it in the model?

Self-rated health is associated with outcomes in population surveys used to train many cardiovascular risk models. Poor or fair ratings may coincide with higher predicted risk after other features are included. They do not diagnose a blocked artery.

## Limitations

A person can feel “Excellent” and still have risk factors. A person can feel “Poor” because of unrelated illness.

## Sources

This parameter is defined by the app’s heart-disease form options and the encoder in `HeartDiseaseMiddleware`.
