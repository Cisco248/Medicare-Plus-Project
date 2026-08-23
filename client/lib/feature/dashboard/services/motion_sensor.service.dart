import 'dart:async';

import 'package:client/feature/dashboard/models/motion_sample.model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MotionSensorProbe {
  const MotionSensorProbe({
    required this.accelerometer,
    required this.gyroscope,
  });

  final bool accelerometer;
  final bool gyroscope;

  bool get isReady => accelerometer && gyroscope;
}

/// Pairs accelerometer and gyroscope X/Y/Z. On Android the native
/// [HarMotionService] owns capture and upload so it survives app close.
class MotionSensorService {
  MotionSensorService({this.minInterval = const Duration(milliseconds: 50)});

  static const MethodChannel channel = MethodChannel(
    'com.example.client/har_motion',
  );

  final Duration minInterval;

  StreamSubscription<AccelerometerEvent>? _accSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;
  AccelerometerEvent? _lastAcc;
  GyroscopeEvent? _lastGyro;
  DateTime? _lastEmit;
  final _controller = StreamController<MotionSample>.broadcast();

  Stream<MotionSample> get samples => _controller.stream;
  bool get isLocalRunning => _accSub != null || _gyroSub != null;
  bool get usesNativeCapture =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<MotionSensorProbe> probe() async {
    if (usesNativeCapture) {
      final raw = await channel.invokeMapMethod<String, dynamic>('probe');
      return MotionSensorProbe(
        accelerometer: raw?['accelerometer'] == true,
        gyroscope: raw?['gyroscope'] == true,
      );
    }
    return const MotionSensorProbe(accelerometer: true, gyroscope: true);
  }

  Future<void> startNative({
    required String token,
    required String baseUrl,
  }) async {
    await channel.invokeMethod<void>('start', {
      'token': token,
      'baseUrl': baseUrl,
    });
  }

  Future<void> stopNative() async {
    await channel.invokeMethod<void>('stop');
  }

  void startLocal() {
    if (isLocalRunning) return;
    // Prefer ~20 Hz. Do not treat a single EventChannel error as "missing
    // sensors" — OEM streams can emit a transient error on subscribe.
    const period = Duration(milliseconds: 50);
    _accSub = accelerometerEventStream(samplingPeriod: period).listen(
      (event) {
        _lastAcc = event;
        _emitIfReady();
      },
      onError: (Object error) {
        debugPrint('Accelerometer stream error: $error');
      },
      cancelOnError: false,
    );
    _gyroSub = gyroscopeEventStream(samplingPeriod: period).listen(
      (event) {
        _lastGyro = event;
        _emitIfReady();
      },
      onError: (Object error) {
        debugPrint('Gyroscope stream error: $error');
      },
      cancelOnError: false,
    );
  }

  Future<bool> waitUntilReady(Duration timeout) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      if (_lastAcc != null && _lastGyro != null) return true;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    return _lastAcc != null && _lastGyro != null;
  }

  void _emitIfReady() {
    final acc = _lastAcc;
    final gyro = _lastGyro;
    if (acc == null || gyro == null) return;
    final now = DateTime.now();
    if (_lastEmit != null && now.difference(_lastEmit!) < minInterval) {
      return;
    }
    _lastEmit = now;
    if (!_controller.isClosed) {
      _controller.add(
        MotionSample(
          timestamp: now,
          accX: acc.x,
          accY: acc.y,
          accZ: acc.z,
          gyroX: gyro.x,
          gyroY: gyro.y,
          gyroZ: gyro.z,
        ),
      );
    }
  }

  Future<void> stopLocal() async {
    await _accSub?.cancel();
    await _gyroSub?.cancel();
    _accSub = null;
    _gyroSub = null;
    _lastAcc = null;
    _lastGyro = null;
    _lastEmit = null;
  }

  Future<void> dispose() async {
    await stopLocal();
    await _controller.close();
  }
}
