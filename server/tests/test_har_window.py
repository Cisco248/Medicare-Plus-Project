from datetime import datetime, timedelta
from types import SimpleNamespace

from repository.middlewares.har_middleware import HARMiddleware

END = datetime(2026, 9, 1, 18, 0, 0)


def _sample_at(stamp: datetime, acc_x: float = 0.1) -> SimpleNamespace:
    return SimpleNamespace(
        timestamp=stamp,
        acc_x=acc_x,
        acc_y=0.2,
        acc_z=9.7,
        gyro_x=0.01,
        gyro_y=0.02,
        gyro_z=0.03,
    )


def test_extract_features_match_model_names():
    readings = [
        _sample_at(END - timedelta(milliseconds=50 * index), acc_x=0.1 + index * 0.01)
        for index in range(20)
    ]
    features = HARMiddleware().extract_features(readings)
    assert list(features) == [
        "acc_x (STDEV)",
        "acc_y (STDEV)",
        "acc_z (STDEV)",
        "acc_average",
        "gyro_x (STDEV)",
        "gyro_y (STDEV)",
        "gyro_z (STDEV)",
        "gyro_average",
    ]
    assert all(isinstance(value, float) for value in features.values())


def test_extract_features_rejects_short_window():
    try:
        HARMiddleware().extract_features([_sample_at(END)] * 9)
    except ValueError as exc:
        assert "Window too small" in str(exc)
    else:
        raise AssertionError("expected ValueError")


def test_inference_window_uses_latest_short_burst():
    older = [
        _sample_at(END - timedelta(hours=1, seconds=index))
        for index in range(40, 0, -1)
    ]
    latest = [
        _sample_at(END - timedelta(milliseconds=100 * index))
        for index in range(14, -1, -1)
    ]
    window = HARMiddleware.inference_window(older + latest)
    assert len(window) == 15
    assert window[-1].timestamp == END
    assert window[0].timestamp >= END - timedelta(seconds=HARMiddleware.WINDOW_SECONDS)


def test_inference_window_falls_back_to_thirty_seconds():
    history = [
        _sample_at(END - timedelta(seconds=11 - index)) for index in range(12)
    ]
    window = HARMiddleware.inference_window(history)
    assert len(window) == 12
    assert window[-1].timestamp == END


def test_inference_window_empty_history():
    assert HARMiddleware.inference_window([]) == []


def test_describe_window_marks_ready_only_with_enough_samples():
    history = [
        _sample_at(END - timedelta(milliseconds=100 * index))
        for index in range(11, -1, -1)
    ]
    window = HARMiddleware.inference_window(history)
    described = HARMiddleware.describe_window(history, window)
    assert described["lookback_hours"] == 6
    assert described["history_samples"] == 12
    assert described["ready"] is True


class _FakeHarModel:
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

    def predict(self, frame):
        assert list(frame.columns) == list(self.feature_names_in_)
        return ["Walk"]

    def predict_proba(self, frame):
        return [[0.1, 0.9]]


def test_predict_uses_named_model_features():
    readings = [
        _sample_at(END - timedelta(milliseconds=50 * index), acc_x=0.1 + index * 0.01)
        for index in range(20)
    ]
    activity, confidence, features = HARMiddleware().predict(readings, _FakeHarModel())
    assert activity == "Walk"
    assert confidence == 0.9
    assert list(features) == list(_FakeHarModel.feature_names_in_)
