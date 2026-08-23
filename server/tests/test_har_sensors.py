import sys
from datetime import datetime, timedelta


def _sample(offset_seconds: float = 0.0, acc_x: float = 0.1):
    stamp = datetime.utcnow() - timedelta(seconds=offset_seconds)
    return {
        "timestamp": stamp.isoformat() + "Z",
        "acc_x": acc_x,
        "acc_y": 0.2,
        "acc_z": 9.7,
        "gyro_x": 0.01,
        "gyro_y": 0.02,
        "gyro_z": 0.03,
    }


def test_sensor_samples_require_auth(client):
    response = client.post("/api-har/samples", json={"samples": [_sample()]})
    assert response.status_code == 401


def test_sensor_samples_are_scoped_to_user(client, auth_headers):
    headers, _user_id = auth_headers
    payload = {"samples": [_sample(i * 0.05) for i in range(12)]}
    stored = client.post("/api-har/samples", json=payload, headers=headers)
    assert stored.status_code == 200, stored.text
    body = stored.json()
    assert body["accepted"] == 12
    assert body["sample_count"] == 12

    listed = client.get("/api-har/samples", headers=headers)
    assert listed.status_code == 200
    assert listed.json()["sample_count"] == 12
    first = listed.json()["samples"][0]
    assert "acc_x" in first and "gyro_z" in first


def test_old_samples_are_pruned(client, auth_headers):
    headers, _user_id = auth_headers
    stale = _sample()
    stale["timestamp"] = (datetime.utcnow() - timedelta(hours=13)).isoformat() + "Z"
    recent = [_sample(i * 0.05) for i in range(5)]
    stored = client.post(
        "/api-har/samples",
        json={"samples": [stale, *recent]},
        headers=headers,
    )
    assert stored.status_code == 200
    assert stored.json()["accepted"] == 5
    assert stored.json()["sample_count"] == 5


def test_predict_current_uses_stored_window(client, auth_headers, monkeypatch):
    headers, _user_id = auth_headers
    samples = [_sample(i * 0.1, acc_x=0.2 + i * 0.01) for i in range(20)]
    client.post("/api-har/samples", json={"samples": samples}, headers=headers)

    class FakeModel:
        feature_names_in_ = [
            "acc_x (STDEV)",
            "acc_y (STDEV)",
            "acc_z (STDEV)",
            "acc_average",
            "gyro_x (STDEV)",
            "gyro_y (STDEV)",
            "gyro_z (STDEV)",
            "gyro_average",
        ]

        def predict(self, data):
            return ["Walking"]

        def predict_proba(self, data):
            return [[0.15, 0.85]]

    class FakeLoader:
        def model_loader(self, path):
            return FakeModel()

    monkeypatch.setattr(
        sys.modules["repository.routes.har_router"],
        "ArtifactLoader",
        FakeLoader,
    )
    response = client.post("/api-har/predict-current", headers=headers)
    assert response.status_code == 200, response.text
    body = response.json()
    assert body["activity"] == "Walking"
    assert body["window_samples"] >= 10
    assert body["confidence"] == 0.85
