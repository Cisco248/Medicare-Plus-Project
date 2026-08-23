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
}
