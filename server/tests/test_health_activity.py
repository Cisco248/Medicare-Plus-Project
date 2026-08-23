from datetime import date


def test_register_does_not_return_password(client):
    response = client.post(
        "/api/register",
        json={
            "name": "Ada",
            "email": "ada@example.com",
            "mobnum": "071",
            "password": "secret123",
        },
    )
    assert response.status_code == 200
    body = response.json()
    assert "password" not in body
    assert body["email"] == "ada@example.com"


def test_register_saves_birthday_height_and_weight(client):
    response = client.post(
        "/api/register",
        json={
            "name": "Ada",
            "email": "ada-profile@example.com",
            "mobnum": "0712345678",
            "password": "secret123",
            "date_of_birth": "1990-05-12",
            "height_cm": 168,
            "weight_kg": 62,
        },
    )
    assert response.status_code == 200
    body = response.json()
    assert body["date_of_birth"] == "1990-05-12"
    assert body["height_cm"] == 168
    assert body["weight_kg"] == 62
    assert body["age"] is not None


def test_login_rejects_wrong_password(client):
    client.post(
        "/api/register",
        json={
            "name": "Ada",
            "email": "ada@example.com",
            "mobnum": "071",
            "password": "secret123",
        },
    )
    response = client.post(
        "/api/login",
        json={"email": "ada@example.com", "password": "wrong"},
    )
    assert response.status_code == 401


def test_har_ingest_is_idempotent(client, auth_headers):
    headers, user_id = auth_headers
    payload = {
        "patient_id": user_id,
        "date": date.today().isoformat(),
        "timezone": "UTC",
        "records": [
            {
                "metric_type": "steps",
                "value": 8234,
                "unit": "count",
                "recorded_at": "2026-08-23T08:00:00Z",
                "source": "health_connect",
                "external_record_id": "steps-1",
            }
        ],
    }
    first = client.post("/api/har", json=payload, headers=headers)
    second = client.post("/api/har", json=payload, headers=headers)
    assert first.status_code == 200
    assert second.status_code == 200
    assert first.json()["accepted"] == 1
    assert second.json()["accepted"] == 0
    assert second.json()["duplicates"] == 1


def test_har_rejects_other_patient(client, auth_headers):
    headers, _user_id = auth_headers
    payload = {
        "patient_id": "someone-else",
        "date": date.today().isoformat(),
        "timezone": "UTC",
        "records": [
            {
                "metric_type": "steps",
                "value": 10,
                "unit": "count",
                "recorded_at": "2026-08-23T08:00:00Z",
                "source": "health_connect",
            }
        ],
    }
    response = client.post("/api/har", json=payload, headers=headers)
    assert response.status_code == 403


def test_daily_summary_and_prediction(client, auth_headers):
    headers, user_id = auth_headers
    client.put(
        "/api/profile",
        headers=headers,
        json={
            "height_cm": 170,
            "weight_kg": 90,
            "date_of_birth": "1960-01-01",
            "conditions": [{"code": "hypertension", "label": "Hypertension"}],
        },
    )
    client.post(
        "/api/har",
        headers=headers,
        json={
            "patient_id": user_id,
            "date": "2026-08-23",
            "timezone": "UTC",
            "records": [
                {
                    "metric_type": "steps",
                    "value": 900,
                    "unit": "count",
                    "recorded_at": "2026-08-23T10:00:00Z",
                    "source": "health_connect",
                },
                {
                    "metric_type": "blood_pressure_systolic",
                    "value": 148,
                    "unit": "mmHg",
                    "recorded_at": "2026-08-23T10:05:00Z",
                    "source": "health_connect",
                },
                {
                    "metric_type": "blood_pressure_diastolic",
                    "value": 94,
                    "unit": "mmHg",
                    "recorded_at": "2026-08-23T10:05:00Z",
                    "source": "health_connect",
                },
            ],
        },
    )
    daily = client.get("/api/har/daily?day=2026-08-23&timezone=UTC", headers=headers)
    assert daily.status_code == 200
    body = daily.json()
    assert body["steps"] == 900
    assert "Elevated systolic" in " ".join(body["anomalies"])

    predictions = client.get("/api/har/predictions", headers=headers)
    assert predictions.status_code == 200
    item = predictions.json()[0]
    assert item["model_name"] == "medicare-plus-risk-rules"
    assert item["model_version"]
    assert item["evidence"]
    first_id = item["id"]

    refreshed = client.post("/api/har/predictions", headers=headers)
    assert refreshed.status_code == 200
    latest = refreshed.json()[0]
    assert latest["id"] != first_id
    assert latest["model_name"] == "medicare-plus-risk-rules"


def test_profile_accepts_smoking_and_stroke_conditions(client, auth_headers):
    headers, _user_id = auth_headers
    response = client.put(
        "/api/profile",
        headers=headers,
        json={
            "gender": "female",
            "conditions": [
                {"code": "smoking", "label": "Smoking"},
                {"code": "stroke", "label": "Stroke"},
            ],
        },
    )
    assert response.status_code == 200
    codes = {item["code"] for item in response.json()["conditions"]}
    assert codes == {"smoking", "stroke"}
    assert response.json()["gender"] == "female"


def test_unauthenticated_har_is_rejected(client):
    response = client.post(
        "/api/har",
        json={"date": "2026-08-23", "records": []},
    )
    assert response.status_code == 401
