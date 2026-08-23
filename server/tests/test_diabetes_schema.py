import sys

from data.schemas.base_model_scehema import DiabetesSchema, parse_bp_reading


FLUTTER_PAYLOAD = {
    "age": 45,
    "gender": "male",
    "pulseRate": 78,
    "bpReading": "120/80",
    "glucose": 110,
    "bmi": 24.5,
    "familyDiabetes": "Yes",
    "hypertensive": "Yes",
}


def test_parse_bp_reading():
    assert parse_bp_reading("120/80") == (120.0, 80.0)
    assert parse_bp_reading("118 - 76") == (118.0, 76.0)
    assert parse_bp_reading("bad") is None


def test_diabetes_schema_accepts_flutter_payload():
    schema = DiabetesSchema.model_validate(FLUTTER_PAYLOAD)
    assert schema.pulse_rate == 78
    assert schema.systolic_bp == 120
    assert schema.diastolic_bp == 80
    assert schema.family_diabetes == "Yes"


def test_diabetes_schema_accepts_snake_case():
    schema = DiabetesSchema.model_validate(
        {
            "age": 45,
            "gender": "female",
            "pulse_rate": 70,
            "systolic_bp": 118,
            "diastolic_bp": 76,
            "glucose": 95,
            "bmi": 22.1,
            "family_diabetes": "No",
            "hypertensive": "No",
        }
    )
    assert schema.systolic_bp == 118
    assert schema.gender == "female"


def test_diabetes_endpoint_no_longer_returns_422(client, monkeypatch):
    class FakeModel:
        def predict(self, data):
            return [0]

        def predict_proba(self, data):
            return [[0.8, 0.2]]

    class FakeScaler:
        def transform(self, data):
            return data

    class FakeLoader:
        def model_loader(self, path):
            return FakeModel()

        def scaler_loader(self, path):
            return FakeScaler()

        def feature_loader(self, path):
            return [
                "age",
                "gender",
                "pulse_rate",
                "systolic_bp",
                "diastolic_bp",
                "glucose",
                "bmi",
                "family_diabetes",
                "hypertensive",
            ]

    monkeypatch.setattr(
        sys.modules["repository.routes.base_model_router"],
        "ArtifactLoader",
        FakeLoader,
    )
    response = client.post("/api-base/diabetes", json=FLUTTER_PAYLOAD)
    assert response.status_code == 200, response.text
    body = response.json()
    assert body["diagnosis"]
    assert "pred_code" in body
