import json
from pathlib import Path

from data.schemas.base_model_scehema import HeartDiseaseSchema


class HeartDiseaseMiddleware:
    AGE_ORDER = [
        "18-24",
        "25-29",
        "30-34",
        "35-39",
        "40-44",
        "45-49",
        "50-54",
        "55-59",
        "60-64",
        "65-69",
        "70-74",
        "75-79",
        "80 or older",
    ]
    GEN_HEALTH_ORDER = ["Poor", "Fair", "Good", "Very good", "Excellent"]
    DIABETIC_ORDER = [
        "No",
        "No, borderline diabetes",
        "Yes (during pregnancy)",
        "Yes",
    ]

    @classmethod
    def age_category_from_years(cls, age: int) -> str:
        if age >= 80:
            return "80 or older"
        bands = [
            (24, "18-24"),
            (29, "25-29"),
            (34, "30-34"),
            (39, "35-39"),
            (44, "40-44"),
            (49, "45-49"),
            (54, "50-54"),
            (59, "55-59"),
            (64, "60-64"),
            (69, "65-69"),
            (74, "70-74"),
            (79, "75-79"),
        ]
        for upper, label in bands:
            if age <= upper:
                return label
        return "80 or older"

    @classmethod
    def _index(cls, value: str, options: list[str], label: str) -> int:
        normalized = value.strip().lower()
        aliases = {
            "very good": "Very good",
            "verygood": "Very good",
            "borderline": "No, borderline diabetes",
            "no, borderline diabetes": "No, borderline diabetes",
            "pregnancy": "Yes (during pregnancy)",
            "yes (during pregnancy)": "Yes (during pregnancy)",
            "80+": "80 or older",
            "80 or older": "80 or older",
        }
        mapped = aliases.get(normalized)
        if mapped is not None:
            return options.index(mapped)
        for index, option in enumerate(options):
            if option.lower() == normalized:
                return index
        raise ValueError(f"Unknown {label}: {value}")

    @staticmethod
    def yes_no(value: str) -> int:
        return 1 if str(value).strip().lower() in ("yes", "true", "1") else 0

    @classmethod
    def encode(cls, schema: HeartDiseaseSchema) -> dict[str, float]:
        category = schema.age_category
        if not category and schema.age is not None:
            category = cls.age_category_from_years(schema.age)
        if not category:
            raise ValueError("Age category is required")
        return {
            "AgeCategory": float(cls._index(category, cls.AGE_ORDER, "age category")),
            "GenHealth": float(cls._index(schema.gen_health, cls.GEN_HEALTH_ORDER, "general health")),
            "DiffWalking": float(cls.yes_no(schema.diff_walking)),
            "Stroke": float(cls.yes_no(schema.stroke)),
            "Diabetic": float(cls._index(schema.diabetic, cls.DIABETIC_ORDER, "diabetic status")),
            "PhysicalHealth": float(schema.physical_health),
            "Sex": 1.0 if schema.sex.strip().lower() == "male" else 0.0,
            "BMI": float(schema.bmi),
            "Smoking": float(cls.yes_no(schema.smoking)),
        }

    @staticmethod
    def load_features(path: str) -> list[str]:
        with open(path, encoding="utf-8") as handle:
            data = json.load(handle)
        if isinstance(data, dict):
            data = data.get("selected_features") or data.get("features")
        if not isinstance(data, list):
            raise ValueError("Heart-disease feature list is invalid")
        return [str(item) for item in data]

    @staticmethod
    def load_info(path: str) -> dict:
        info_path = Path(path)
        if not info_path.exists():
            return {"numeric_cols": [], "recommended_threshold": 0.6}
        with info_path.open(encoding="utf-8") as handle:
            return json.load(handle)

    @staticmethod
    def risk_label(high_risk: bool) -> str:
        return "High heart-disease risk" if high_risk else "Lower heart-disease risk"

    @staticmethod
    def build_rag_question(schema: HeartDiseaseSchema, diagnosis: str, probability: float) -> str:
        category = schema.age_category or (
            HeartDiseaseMiddleware.age_category_from_years(schema.age)
            if schema.age is not None
            else "unknown"
        )
        return f"""
        A {schema.sex} patient in age group {category} has been screened for heart-disease risk.
        Result: {diagnosis} (model probability {probability:.1%}).
        BMI is {schema.bmi}, general health is {schema.gen_health}, diabetes status is {schema.diabetic},
        smoking: {schema.smoking}, previous stroke: {schema.stroke}, difficulty walking: {schema.diff_walking},
        poor physical-health days in the last 30 days: {schema.physical_health}.
        Explain what this risk level means in simple terms and give practical follow-up advice.
        Do not diagnose. Do not invent lab results.
        """
