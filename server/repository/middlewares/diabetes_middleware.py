class DiabetesMiddleware:
    def __init__(self):
        pass

    def gender_encoder(self, gender: str) -> int:
        if gender is None:
            raise ValueError("Gender cannot be None")
        return 1 if gender.lower() == "male" else 0

    def yes_no_encoder(self, value: str) -> int:
        if value is None:
            raise ValueError("Value cannot be None")
        return 1 if value.lower() in ("yes", "true", "1") else 0

    def risk_label(self, pred_code: int) -> str:
        return "Diabetic / High Risk" if pred_code == 1 else "Non-Diabetic / Low Risk"

    def build_rag_question(
        self,
        diagnosis: str,
        age: int,
        gender: str,
        glucose: float,
        bmi: float,
        systolic_bp: float,
        diastolic_bp: float,
        family_diabetes: str,
        hypertensive: str,
    ) -> str:
        """Turns the diabetes prediction + patient inputs into a natural
        language question for the RAG /e-doc endpoint, so it can generate
        a short patient-friendly explanation and recommendations."""
        return (
            f"A {age}-year-old {gender} patient has been screened for diabetes risk "
            f"with the result: {diagnosis}. "
            f"Their glucose level is {glucose} mmol/L, BMI is {bmi}, blood pressure is "
            f"{systolic_bp}/{diastolic_bp} mmHg, family history of diabetes: {family_diabetes}, "
            f"existing hypertension: {hypertensive}. "
            "Based on this, explain what this risk level means in simple terms and give "
            "clear, practical lifestyle and follow-up recommendations for this patient."
        )
