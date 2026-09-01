import 'package:client/feature/dashboard/models/motion_sample.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MotionSample serializes accelerometer and gyroscope XYZ for HAR', () {
    final sample = MotionSample(
      timestamp: DateTime.utc(2026, 8, 23, 6, 55, 0),
      accX: 0.1,
      accY: 0.2,
      accZ: 9.7,
      gyroX: 0.01,
      gyroY: 0.02,
      gyroZ: 0.03,
    );

    expect(sample.toJson(), {
      'timestamp': '2026-08-23T06:55:00.000Z',
      'acc_x': 0.1,
      'acc_y': 0.2,
      'acc_z': 9.7,
      'gyro_x': 0.01,
      'gyro_y': 0.02,
      'gyro_z': 0.03,
    });
  });

  test('MotionPrediction reads six-hour window metadata', () {
    final prediction = MotionPrediction.fromJson({
      'activity': 'Walk',
      'confidence': 0.91,
      'window_samples': 48,
      'history_samples': 1200,
      'lookback_hours': 6,
      'window_start': '2026-09-01T17:59:57.000Z',
      'window_end': '2026-09-01T18:00:00.000Z',
    });

    expect(prediction.activity, 'Walk');
    expect(prediction.confidence, 0.91);
    expect(prediction.windowSamples, 48);
    expect(prediction.historySamples, 1200);
    expect(prediction.lookbackHours, 6);
    expect(prediction.windowEnd, DateTime.utc(2026, 9, 1, 18));
  });
}
