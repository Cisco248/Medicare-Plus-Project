# E-Doc Health Parameter Explanation

## Question: Why does the e-doc ask for these parameters?

### Answer

Each e-doc form collects the exact inputs that prediction model expects. Diabetes, hypertension, and heart-disease models do not share the same feature list. Values are sent to the backend, preprocessed as documented, and a class label (and sometimes a probability) is returned. RAG then writes an educational explanation. None of this replaces a doctor.

## What happens if a value is missing?

Required form fields must be filled or the API returns a validation error (for example blood pressure must look like 120/80). The models do not impute missing clinical values in the shown inference path. Missing wearable data in daily summaries stay N/A and must not be treated as zero.

## Can these values change?

Yes. Glucose, pulse, blood pressure, weight, and self-rated health can change. A new submission can change the prediction. Incorrect typing (especially glucose units) can change the prediction without a true health change.

## What can affect the values?

Meals, illness, medicines, cuff technique, time of day, and measurement device. See each parameter file.

## After submission, what reaches the chatbot?

The prediction API posts a full English paragraph with the submitted numbers to `/api/e-doc` for recommendations. The in-app chatbot (`/api/ask`) originally received only the typed question. The client now also sends `patient_context` with the latest e-doc values and profile snapshot when available. Static RAG documents still must not contain a named patient’s numbers.

## Safety

Educational answers only. Prediction ≠ diagnosis. Emergency symptoms need local emergency services first.
