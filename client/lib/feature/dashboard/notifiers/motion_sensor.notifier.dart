import 'dart:async';

import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/network/api_endpoint.dart';
import 'package:client/feature/auth/models/auth.state.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/dashboard/models/motion_sample.model.dart';
import 'package:client/feature/dashboard/notifiers/server_health.notifier.dart';
import 'package:client/feature/dashboard/services/motion_sensor.service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MotionSensorState {
  const MotionSensorState({
    this.recording = false,
    this.uploading = false,
    this.buffered = 0,
    this.uploaded = 0,
    this.storedCount = 0,
    this.errorMessage,
  });

  final bool recording;
  final bool uploading;
  final int buffered;
  final int uploaded;
  final int storedCount;
  final String? errorMessage;

  MotionSensorState copyWith({
    bool? recording,
    bool? uploading,
    int? buffered,
    int? uploaded,
    int? storedCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MotionSensorState(
      recording: recording ?? this.recording,
      uploading: uploading ?? this.uploading,
      buffered: buffered ?? this.buffered,
      uploaded: uploaded ?? this.uploaded,
      storedCount: storedCount ?? this.storedCount,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class MotionSensorNotifier extends Notifier<MotionSensorState> {
  static const _batchSize = 80;
  static const _flushEvery = Duration(seconds: 6);

  final MotionSensorService _sensors = MotionSensorService();
  final List<MotionSample> _buffer = [];
  StreamSubscription<MotionSample>? _subscription;
  Timer? _flushTimer;
  bool _starting = false;

  @override
  MotionSensorState build() {
    ref.onDispose(_dispose);
    ref.listen(authenticationProvider, (_, next) {
      unawaited(_syncToAuth(next));
    });
    Future.microtask(() => _syncToAuth(ref.read(authenticationProvider)));
    return const MotionSensorState();
  }

  String? get _token => ref.read(authenticationProvider).value?.data?.token;

  Future<void> _syncToAuth(AsyncValue<AuthStates> auth) async {
    final data = auth.asData?.value;
    final token = data?.data?.token;
    if (data?.state == AuthMode.authenticated &&
        token != null &&
        token.isNotEmpty) {
      await start();
      return;
    }
    if (data?.state == AuthMode.unauthenticated ||
        data?.state == AuthMode.setup) {
      await stop();
    }
  }

  Future<void> start() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    if (state.recording || _starting) return;
    _starting = true;
    try {
      final probe = await _sensors.probe();
      if (!probe.isReady) {
        state = state.copyWith(
          errorMessage: _missingSensorMessage(probe),
        );
        return;
      }
      if (_sensors.usesNativeCapture) {
        await _sensors.startNative(
          token: token,
          baseUrl: '${ApiEndpoints.baseUrl}:8080',
        );
        state = state.copyWith(recording: true, clearError: true);
        return;
      }
      _sensors.startLocal();
      final ready = await _sensors.waitUntilReady(const Duration(seconds: 4));
      if (!ready) {
        await _sensors.stopLocal();
        state = state.copyWith(
          errorMessage:
              'Accelerometer or gyroscope did not produce a reading. '
              'HAR needs both X, Y, Z streams.',
        );
        return;
      }
      state = state.copyWith(recording: true, clearError: true);
      _subscription = _sensors.samples.listen(_onSample);
      _flushTimer = Timer.periodic(_flushEvery, (_) => unawaited(_flush()));
    } on MissingPluginException {
      state = state.copyWith(
        errorMessage: 'Motion capture is not available on this platform.',
      );
    } catch (error) {
      debugPrint('HAR motion start failed: $error');
      state = state.copyWith(
        errorMessage: 'Could not start motion capture. It will retry.',
      );
    } finally {
      _starting = false;
    }
  }

  String _missingSensorMessage(MotionSensorProbe probe) {
    if (!probe.accelerometer && !probe.gyroscope) {
      return 'This device has no accelerometer or gyroscope.';
    }
    if (!probe.accelerometer) {
      return 'This device has no accelerometer.';
    }
    return 'This device has no gyroscope.';
  }

  void _onSample(MotionSample sample) {
    _buffer.add(sample);
    state = state.copyWith(buffered: _buffer.length);
    if (_buffer.length >= _batchSize) {
      unawaited(_flush());
    }
  }

  Future<void> stop() async {
    _flushTimer?.cancel();
    _flushTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    if (_sensors.usesNativeCapture) {
      try {
        await _sensors.stopNative();
      } catch (_) {}
    }
    await _sensors.stopLocal();
    if (state.recording) {
      state = state.copyWith(recording: false);
    }
    await _flush();
  }

  Future<void> _flush() async {
    if (_buffer.isEmpty || state.uploading) return;
    final token = _token;
    if (token == null || token.isEmpty) return;
    final batch = List<MotionSample>.from(_buffer);
    _buffer.clear();
    state = state.copyWith(uploading: true, buffered: 0, clearError: true);
    try {
      final result = await ref
          .read(harRepositoryProvider)
          .uploadMotionSamples(token: token, samples: batch);
      state = state.copyWith(
        uploading: false,
        uploaded: state.uploaded + result.accepted,
        storedCount: result.sampleCount,
      );
    } on AppException catch (error) {
      _buffer.insertAll(0, batch);
      state = state.copyWith(
        uploading: false,
        buffered: _buffer.length,
        errorMessage: error.message,
      );
    } catch (_) {
      _buffer.insertAll(0, batch);
      state = state.copyWith(
        uploading: false,
        buffered: _buffer.length,
        errorMessage: 'Could not store motion samples. They will retry.',
      );
    }
  }

  Future<void> _dispose() async {
    _flushTimer?.cancel();
    await _subscription?.cancel();
    // Leave the Android foreground service running when Flutter tears down
    // so capture continues while the app is closed.
    await _sensors.dispose();
  }
}

final motionSensorProvider =
    NotifierProvider<MotionSensorNotifier, MotionSensorState>(
      MotionSensorNotifier.new,
    );
