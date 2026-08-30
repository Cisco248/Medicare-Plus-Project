# Parameter: stroke

Heart-disease e-doc field: `stroke`. Encoded feature: `Stroke` as 1 for yes/true/1, otherwise 0.

## What does it mean?

It records a reported previous stroke. Stroke is a medical emergency at onset (face drooping, arm weakness, speech difficulty). A past stroke is a strong marker of cardiovascular risk.

## Why the model uses it

Prior stroke is associated with higher future cardiovascular event risk. The classifier includes this binary feature.

## Limitations

The checkbox is not a neurology diagnosis. New stroke symptoms need emergency services, not an e-doc resubmit.

## Sources

- NHS, Stroke symptoms: <https://www.nhs.uk/conditions/stroke/symptoms/>
- AHA, Heart Attack, Stroke and Cardiac Arrest Symptoms: <https://www.heart.org/en/about-us/heart-attack-and-stroke-symptoms>
