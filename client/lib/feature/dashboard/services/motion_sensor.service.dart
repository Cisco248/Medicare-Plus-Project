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

/// In-app accelerometer + gyroscope capture.
///
/// On Android a native foreground service keeps the process alive in the
/// background and takes over capture when the Flutter UI is not running.
/// Collected samples are posted to `POST /api-har/samples` by the notifier.
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
      try {
        final raw = await channel.invokeMapMethod<String, dynamic>('probe');
        return MotionSensorProbe(
          accelerometer: raw?['accelerometer'] == true,
          gyroscope: raw?['gyroscope'] == true,
        );
      } on MissingPluginException {
        debugPrint('HAR probe plugin missing; assuming device sensors exist');
      }
    }
    return const MotionSensorProbe(accelerometer: true, gyroscope: true);
  }

  Future<bool> isNativeRunning() async {
    if (!usesNativeCapture) return false;
    try {
      return await channel.invokeMethod<bool>('isRunning') ?? false;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// [capture] true: native sensors + POST `/api-har/samples`.
  /// [capture] false: keep-alive foreground service only (Dart captures).
  Future<void> startNative({
    required String token,
    required String baseUrl,
    bool capture = true,
  }) async {
    await channel.invokeMethod<void>('start', {
      'token': token,
      'baseUrl': baseUrl,
      'capture': capture,
    });
  }

  Future<void> stopNative() async {
    await channel.invokeMethod<void>('stop');
  }

  void startLocal() {
    if (isLocalRunning) return;
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
