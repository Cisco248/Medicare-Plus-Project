# Knowledge Base Version

## Current release

- Version: 1.1.0
- Release date: 2026-08-23
- Content access date: 2026-08-23

## Scope

Version 1.1.0 keeps the governed educational material for diabetes, hypertension, cholesterol, physical activity, sleep, monitoring, and safety, and adds real-world daily-summary use cases: interpreting one recorded day, steps and distance, estimated calories, workout intensity, resting and activity heart rate, BMI and weight, home blood pressure, self-checked glucose, wearable limits, and daily sleep tracking.

Startup also ingests live pages listed in `docs/knowledge_urls.txt` (WHO, CDC, NHS, AHA, ADA, NIH/NHLBI, Mayo Clinic, and Harvard Health Publishing). Sample or demo data files are not used.

The release does not provide individualized treatment plans, medication recommendations, diagnostic decision rules, or country-specific emergency numbers.

## Changelog

### 1.1.0 - 2026-08-23

- Added daily-use-case, heart-rate, body-metric, home-monitoring, wearable, and sleep-tracking topic files grounded in public agency pages and reputable health-organization blogs.
- Added `docs/knowledge_urls.txt` so RAG startup can fetch those live pages.
- URL ingest is resilient: one failed fetch does not block Markdown knowledge.

### 1.0.0 - 2026-08-18

- Established the 33-file governed knowledge-base structure.
- Expanded condition content into separate overview, risk, symptom, activity, diet, sleep, monitoring, and warning-sign topics.
- Added cross-condition activity, sedentary behavior, sleep, emergency, and disclaimer guidance.
- Added authoritative source links, retrieval conventions, uncertainty rules, and an update policy.
- Consolidated useful material from the earlier partial knowledge base and removed superseded files.
