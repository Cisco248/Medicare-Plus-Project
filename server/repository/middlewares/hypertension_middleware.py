from data import HypertensionScehema


class HypertensionMiddleware:
    def __init__(self):
        pass

    def bmi_calculator(self, height: float, weight: float) -> float:
        if weight is None or height is None:
            return None
        return weight / (height / 100) ** 2

    def gender_encoder(self, gender: str) -> int:
        if gender is None:
            raise ValueError("Gender cannot be None")
        return 1 if gender.lower() == "male" else 0

    def diabetes_encoder(self, diabete_ordinal: str) -> float:
        if diabete_ordinal is None:
            raise ValueError("Diabetes cannot be None")
        diabetes_mapping = {
            "normal": 0.0,
            "pre-diabetic": 1.0,
            "diabetic": 2.0,
        }
        return diabetes_mapping.get(diabete_ordinal.lower(), 0)

    def compose_question(
        self, schema: HypertensionScehema, prediction: str, bmi: float
    ) -> str:
        return f"""
            Explain this hypertension risk assessment for a patient using only the medical knowledge context. Do not diagnose and do not invent facts.
    
            Predicted status: {prediction}
            Age: {schema.age}. Gender: {schema.gender}
            Height: {schema.height} cm. Weight: {schema.weight} kg
            BMI: {bmi:.1f}. HbA1c: {schema.hba1c}%
            Cholesterol: {schema.cholesterol_mgdl} mg/dL
            Diabetes status: {schema.diabetes_ordinal}
        """
