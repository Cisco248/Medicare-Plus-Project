from data import DiabetesSchema


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

    def build_rag_question(self, schema: DiabetesSchema, diagnosis: str) -> str:
        return f"""
        A {schema.age}-year-old {schema.gender} patient has been screened for diabetes risk with the result: {diagnosis}. Their glucose level is {schema.glucose} mmol/L, BMI is {schema.bmi}, blood pressure is {schema.systolic_bp}/{schema.diastolic_bp} mmHg, family history of diabetes: {schema.family_diabetes}, existing hypertension: {schema.hypertensive}. Based on this, explain what this risk level means in simple terms and give clear, practical lifestyle and follow-up recommendations for this patient.
        """
