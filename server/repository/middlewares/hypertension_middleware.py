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
