import math
import statistics
import uuid
from datetime import datetime, timedelta, timezone

import pandas as pd
from sqlalchemy import func
from sqlalchemy.orm import Session

from data.models.har_sensor_sample_model import HARSensorSampleModel
from data.schemas.har_data_schema import HARSensorReading, HARSensorStoreResponse


class HARMiddleware:
    MIN_WINDOW_SIZE = 10
    LOOKBACK_HOURS = 6
    RETENTION_HOURS = 6
    WINDOW_SECONDS = 3
    FALLBACK_WINDOW_SECONDS = 30
    MAX_WINDOW_SAMPLES = 300

    def __init__(self):
        pass

    def _stdev(self, values: list[float]) -> float:
        if len(values) < 2:
            return 0.0
        return statistics.stdev(values)

    def _average_magnitude(
        self, xs: list[float], ys: list[float], zs: list[float]
    ) -> float:
        mx = sum(xs) / len(xs)
        my = sum(ys) / len(ys)
        mz = sum(zs) / len(zs)
        magnitudes = [
            math.sqrt((x - mx) ** 2 + (y - my) ** 2 + (z - mz) ** 2)
            for x, y, z in zip(xs, ys, zs)
        ]
        return sum(magnitudes) / len(magnitudes)

    def extract_features(self, readings: list) -> dict:
        if not readings or len(readings) < self.MIN_WINDOW_SIZE:
            raise ValueError(
                f"Window too small: need at least {self.MIN_WINDOW_SIZE} samples, "
                f"got {len(readings) if readings else 0}"
            )

        acc_x = [r.acc_x for r in readings]
        acc_y = [r.acc_y for r in readings]
        acc_z = [r.acc_z for r in readings]
        gyro_x = [r.gyro_x for r in readings]
        gyro_y = [r.gyro_y for r in readings]
        gyro_z = [r.gyro_z for r in readings]

        return {
            "acc_x (STDEV)": self._stdev(acc_x),
            "acc_y (STDEV)": self._stdev(acc_y),
            "acc_z (STDEV)": self._stdev(acc_z),
            "acc_average": self._average_magnitude(acc_x, acc_y, acc_z),
            "gyro_x (STDEV)": self._stdev(gyro_x),
            "gyro_y (STDEV)": self._stdev(gyro_y),
            "gyro_z (STDEV)": self._stdev(gyro_z),
            "gyro_average": self._average_magnitude(gyro_x, gyro_y, gyro_z),
        }

    def predict(self, readings: list, model) -> tuple[str, float, dict]:
        features = self.extract_features(readings)
        names = getattr(model, "feature_names_in_", None)
        if names is not None:
            ordered = pd.DataFrame(
                [[features[name] for name in names]],
                columns=list(names),
            )
        else:
            ordered = [list(features.values())]
        try:
            pred_activity = str(model.predict(ordered)[0])
            proba = model.predict_proba(ordered)[0]
            confidence = float(max(proba))
        except Exception as exc:
            raise RuntimeError(
                "The activity model could not score this window."
            ) from exc
        return pred_activity, confidence, features

    @staticmethod
    def _as_naive_utc(value: datetime) -> datetime:
        if value.tzinfo is None:
            return value
        return value.astimezone(timezone.utc).replace(tzinfo=None)

    @classmethod
    def prune(cls, db: Session, user_id: str) -> int:
        cutoff = datetime.utcnow() - timedelta(hours=cls.RETENTION_HOURS)
        deleted = (
            db.query(HARSensorSampleModel)
            .filter(
                HARSensorSampleModel.user_id == user_id,
                HARSensorSampleModel.timestamp < cutoff,
            )
            .delete(synchronize_session=False)
        )
        return int(deleted or 0)

    @classmethod
    def _bounds(cls, db: Session, user_id: str) -> tuple[int, datetime | None, datetime | None]:
        count, oldest, newest = (
            db.query(
                func.count(HARSensorSampleModel.id),
                func.min(HARSensorSampleModel.timestamp),
                func.max(HARSensorSampleModel.timestamp),
            )
            .filter(HARSensorSampleModel.user_id == user_id)
            .one()
        )
        return int(count or 0), oldest, newest

    @classmethod
    def store_samples(
        cls,
        db: Session,
        user_id: str,
        samples: list[HARSensorReading],
    ) -> HARSensorStoreResponse:
        now = datetime.utcnow()
        cutoff = now - timedelta(hours=cls.RETENTION_HOURS)
        accepted = 0
        for sample in samples:
            stamp = cls._as_naive_utc(sample.timestamp)
            if stamp < cutoff or stamp > now + timedelta(minutes=5):
                continue
            db.add(
                HARSensorSampleModel(
                    id=str(uuid.uuid4()),
                    user_id=user_id,
                    timestamp=stamp,
                    acc_x=sample.acc_x,
                    acc_y=sample.acc_y,
                    acc_z=sample.acc_z,
                    gyro_x=sample.gyro_x,
                    gyro_y=sample.gyro_y,
                    gyro_z=sample.gyro_z,
                )
            )
            accepted += 1
        pruned = cls.prune(db, user_id)
        db.commit()
        count, oldest, newest = cls._bounds(db, user_id)
        return HARSensorStoreResponse(
            accepted=accepted,
            pruned=pruned,
            sample_count=count,
            oldest=oldest,
            newest=newest,
        )

    @classmethod
    def list_recent(
        cls,
        db: Session,
        user_id: str,
        limit: int = 500,
    ) -> list[HARSensorSampleModel]:
        return (
            db.query(HARSensorSampleModel)
            .filter(HARSensorSampleModel.user_id == user_id)
            .order_by(HARSensorSampleModel.timestamp.desc())
            .limit(limit)
            .all()
        )

    @classmethod
    def get_sensor_data_for_last_six_hours(
        cls,
        db: Session,
        user_id: str,
        prediction_time: datetime | None = None,
    ) -> list[HARSensorSampleModel]:
        at = cls._as_naive_utc(prediction_time or datetime.utcnow())
        start = at - timedelta(hours=cls.LOOKBACK_HOURS)
        return (
            db.query(HARSensorSampleModel)
            .filter(
                HARSensorSampleModel.user_id == user_id,
                HARSensorSampleModel.timestamp >= start,
                HARSensorSampleModel.timestamp <= at,
            )
            .order_by(HARSensorSampleModel.timestamp.asc())
            .all()
        )

    @classmethod
    def inference_window(cls, history: list) -> list:
        """Pick the latest short burst from a 6-hour lookback.

        The deployed Random Forest was trained on ~3s windows of acc/gyro
        statistics, not on a mixed 6-hour stretch of different activities.
        """
        if not history:
            return []
        latest = cls._as_naive_utc(history[-1].timestamp)
        primary_start = latest - timedelta(seconds=cls.WINDOW_SECONDS)
        primary = [
            row
            for row in history
            if cls._as_naive_utc(row.timestamp) >= primary_start
        ]
        if len(primary) >= cls.MIN_WINDOW_SIZE:
            return primary[-cls.MAX_WINDOW_SAMPLES :]
        fallback_start = latest - timedelta(seconds=cls.FALLBACK_WINDOW_SECONDS)
        fallback = [
            row
            for row in history
            if cls._as_naive_utc(row.timestamp) >= fallback_start
        ]
        return fallback[-cls.MAX_WINDOW_SAMPLES :]

    @classmethod
    def describe_window(cls, history: list, window: list) -> dict:
        return {
            "lookback_hours": cls.LOOKBACK_HOURS,
            "history_samples": len(history),
            "history_start": history[0].timestamp if history else None,
            "history_end": history[-1].timestamp if history else None,
            "inference_samples": len(window),
            "inference_start": window[0].timestamp if window else None,
            "inference_end": window[-1].timestamp if window else None,
            "ready": len(window) >= cls.MIN_WINDOW_SIZE,
        }

    @classmethod
    def current_window(
        cls,
        db: Session,
        user_id: str,
        prediction_time: datetime | None = None,
    ) -> list[HARSensorSampleModel]:
        history = cls.get_sensor_data_for_last_six_hours(
            db, user_id, prediction_time
        )
        return cls.inference_window(history)

    @classmethod
    def sample_stats(cls, db: Session, user_id: str) -> HARSensorStoreResponse:
        cls.prune(db, user_id)
        db.commit()
        count, oldest, newest = cls._bounds(db, user_id)
        return HARSensorStoreResponse(
            accepted=0,
            pruned=0,
            sample_count=count,
            oldest=oldest,
            newest=newest,
        )
