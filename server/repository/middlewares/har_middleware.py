import math
import statistics


class HARMiddleware:
    """Turns a raw ~3s window of accelerometer + gyroscope samples into the
    8 statistical features the trained Random Forest activity model expects,
    in the exact order the model was trained on:

        ['acc_x (STDEV)', 'acc_y (STDEV)', 'acc_z (STDEV)', 'acc_average',
         'gyro_x (STDEV)', 'gyro_y (STDEV)', 'gyro_z (STDEV)', 'gyro_average']

    NOTE: 'acc_average' / 'gyro_average' are computed as the mean vector
    magnitude of each axis after de-meaning (i.e. subtracting each axis's
    own window average first). This removes any constant offset -- such as
    gravity sitting on one accelerometer axis in raw sensor data -- before
    computing magnitude, which matches KU-HAR's gravity-free feature values
    (stationary activities like Sit/Stand/Lay average close to 0).
    """

    MIN_WINDOW_SIZE = 10  # sanity floor; ideally ~300 samples (3s @ 100Hz)

    def __init__(self):
        pass

    def _stdev(self, values: list[float]) -> float:
        if len(values) < 2:
            return 0.0
        return statistics.stdev(values)

    def _average_magnitude(self, xs: list[float], ys: list[float], zs: list[float]) -> float:
        # De-mean each axis first so a constant offset (e.g. gravity sitting on
        # one axis in raw accelerometer data) cancels out before computing the
        # magnitude. This matches KU-HAR's gravity-free feature values, where
        # stationary activities (Sit/Stand/Lay) average close to 0.
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