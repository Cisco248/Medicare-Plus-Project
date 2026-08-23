from repository.middlewares.heart_disease_middleware import HeartDiseaseMiddleware
from data.schemas.base_model_scehema import HeartDiseaseSchema


PAYLOAD = {
    "age_category": "65-69",
    "sex": "male",
    "bmi": 29.4,
    "gen_health": "Fair",
    "diabetic": "Yes",
    "smoking": "Yes",
    "stroke": "No",
    "diff_walking": "Yes",
    "physical_health": 8,
}


def test_heart_disease_encodes_notebook_features():
    schema = HeartDiseaseSchema.model_validate(PAYLOAD)
    encoded = HeartDiseaseMiddleware.encode(schema)
    assert encoded["AgeCategory"] == 9
    assert encoded["GenHealth"] == 1
    assert encoded["Diabetic"] == 3
    assert encoded["Sex"] == 1
    assert encoded["Smoking"] == 1
    assert encoded["DiffWalking"] == 1
    assert encoded["Stroke"] == 0
    assert encoded["BMI"] == 29.4
    assert encoded["PhysicalHealth"] == 8


def test_heart_disease_accepts_age_and_camel_case():
    schema = HeartDiseaseSchema.model_validate(
        {
            "age": 72,
            "sex": "female",
            "bmi": 22.1,
            "genHealth": "Excellent",
            "diabetic": "No",
            "smoking": "No",
            "stroke": "No",
            "diffWalking": "No",
            "physicalHealth": 0,
        }
    )
    encoded = HeartDiseaseMiddleware.encode(schema)
    assert encoded["AgeCategory"] == 10
    assert encoded["Sex"] == 0
    assert encoded["GenHealth"] == 4


def test_heart_disease_endpoint_uses_artifacts(client):
    response = client.post("/api-base/heart-disease", json=PAYLOAD)
    assert response.status_code == 200, response.text
    body = response.json()
    assert body["diagnosis"]
    assert 0 <= body["confidence"] <= 1
    assert body["threshold"] == 0.6
    assert "pred_code" in body


def test_heart_disease_alias_route(client):
    response = client.post("/api-base/hear-disease", json=PAYLOAD)
    assert response.status_code == 200, response.text
