import 'dart:async';

import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/network/api_endpoint.dart';
import 'package:client/feature/auth/models/auth.state.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/dashboard/models/motion_sample.model.dart';
import 'package:client/feature/dashboard/notifiers/server_health.notifier.dart';
import 'package:client/feature/dashboard/services/motion_sensor.service.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MotionSensorState {
  const MotionSensorState({
    this.recording = false,
    this.uploading = false,
    this.background = false,
    this.predicting = false,
    this.buffered = 0,
    this.uploaded = 0,
    this.storedCount = 0,
    this.activity,
    this.confidence,
    this.errorMessage,
    this.predictionError,
  });

  final bool recording;
  final bool uploading;
  final bool background;
  final bool predicting;
  final int buffered;
  final int uploaded;
  final int storedCount;
  final String? activity;
  final double? confidence;
  final String? errorMessage;
  final String? predictionError;

  MotionSensorState copyWith({
    bool? recording,
    bool? uploading,
    bool? background,
    bool? predicting,
    int? buffered,
    int? uploaded,
    int? storedCount,
    String? activity,
    double? confidence,
    String? errorMessage,
    String? predictionError,
    bool clearError = false,
    bool clearPredictionError = false,
  }) {
    return MotionSensorState(
      recording: recording ?? this.recording,
      uploading: uploading ?? this.uploading,
      background: background ?? this.background,
      predicting: predicting ?? this.predicting,
      buffered: buffered ?? this.buffered,
      uploaded: uploaded ?? this.uploaded,
      storedCount: storedCount ?? this.storedCount,
      activity: activity ?? this.activity,
      confidence: confidence ?? this.confidence,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      predictionError: clearPredictionError
          ? null
          : predictionError ?? this.predictionError,
    );
  }
}

class MotionSensorNotifier extends Notifier<MotionSensorState> {
  static const _batchSize = 80;
  static const _flushEvery = Duration(seconds: 6);
  static const _statsEvery = Duration(seconds: 15);

  final MotionSensorService _sensors = MotionSensorService();
  final List<MotionSample> _buffer = [];
  StreamSubscription<MotionSample>? _subscription;
  Timer? _flushTimer;
  Timer? _statsTimer;
  _MotionLifecycle? _lifecycle;
  bool _starting = false;
  bool _desired = false;
  bool _backgroundCapture = false;

  @override
  MotionSensorState build() {
    ref.keepAlive();
    _lifecycle = _MotionLifecycle(this);
    WidgetsBinding.instance.addObserver(_lifecycle!);
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
    _desired = true;
    try {
      final probe = await _sensors.probe();
      if (!probe.isReady) {
        state = state.copyWith(errorMessage: _missingSensorMessage(probe));
        return;
      }
      await _startNative(capture: false);
      await _startDartCapture();
      _startStatsPolling();
      state = state.copyWith(
        recording: true,
        background: false,
        clearError: true,
      );
      debugPrint('HAR motion: in-app capture started');
    } on StateError {
      await _startNative(capture: true);
      _backgroundCapture = true;
      _startStatsPolling();
      state = state.copyWith(
        recording: true,
        background: true,
        errorMessage:
            'Accelerometer or gyroscope did not produce a reading in the app. '
            'Background capture is running instead.',
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

  Future<void> onAppResumed() async {
    if (!_desired) return;
    if (!_backgroundCapture && _sensors.isLocalRunning) return;
    _backgroundCapture = false;
    await _startNative(capture: false);
    await _startDartCapture();
    _startStatsPolling();
    state = state.copyWith(
      recording: true,
      background: false,
      clearError: true,
    );
  }

  Future<void> onAppBackgrounded() async {
    if (!_desired || _backgroundCapture) return;
    _backgroundCapture = true;
    await _stopDartCapture();
    await _startNative(capture: true);
    state = state.copyWith(recording: true, background: true);
    debugPrint('HAR motion: background native capture');
  }

  Future<void> _startDartCapture() async {
    if (_sensors.isLocalRunning && _subscription != null) return;
    _sensors.startLocal();
    final ready = await _sensors.waitUntilReady(const Duration(seconds: 4));
    if (!ready) {
      await _sensors.stopLocal();
      throw StateError('sensors-not-ready');
    }
    _subscription ??= _sensors.samples.listen(_onSample);
    _flushTimer ??= Timer.periodic(_flushEvery, (_) => unawaited(_flush()));
  }

  Future<void> _stopDartCapture() async {
    _flushTimer?.cancel();
    _flushTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    await _sensors.stopLocal();
    await _flush();
  }

  Future<void> _startNative({required bool capture}) async {
    final token = _token;
    if (token == null || token.isEmpty || !_sensors.usesNativeCapture) return;
    try {
      await _sensors.startNative(
        token: token,
        baseUrl: ApiEndpoints.backendUrl,
        capture: capture,
      );
    } on MissingPluginException {
      debugPrint('HAR native plugin missing; in-app sensors still run');
    } catch (error) {
      debugPrint('HAR native service failed: $error');
    }
  }

  void _startStatsPolling() {
    _statsTimer?.cancel();
    _statsTimer = Timer.periodic(
      _statsEvery,
      (_) => unawaited(_refreshStats()),
    );
    unawaited(_refreshStats());
  }

  Future<void> refreshStats() => _refreshStats();

  Future<void> predictCurrent() async {
    final token = _token;
    if (token == null || token.isEmpty || state.predicting) return;
    state = state.copyWith(predicting: true, clearPredictionError: true);
    try {
      final result = await ref
          .read(harRepositoryProvider)
          .predictCurrentWindow(token: token);
      state = state.copyWith(
        predicting: false,
        activity: result.activity,
        confidence: result.confidence,
        clearPredictionError: true,
      );
    } on AppException catch (error) {
      state = state.copyWith(predicting: false, predictionError: error.message);
    } catch (_) {
      state = state.copyWith(
        predicting: false,
        predictionError:
            'Activity prediction is not available yet. Keep capturing motion and try again.',
      );
    }
  }

  Future<void> _refreshStats() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    try {
      final result = await ref
          .read(harRepositoryProvider)
          .motionStats(token: token);
      state = state.copyWith(storedCount: result.sampleCount);
    } catch (_) {}
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
    _desired = false;
    _backgroundCapture = false;
    _statsTimer?.cancel();
    _statsTimer = null;
    await _stopDartCapture();
    if (_sensors.usesNativeCapture) {
      try {
        await _sensors.stopNative();
      } catch (_) {}
    }
    if (state.recording) {
      state = state.copyWith(recording: false, background: false);
    }
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
      debugPrint('HAR motion: posted ${result.accepted} samples');
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
    final observer = _lifecycle;
    if (observer != null) {
      WidgetsBinding.instance.removeObserver(observer);
    }
    _statsTimer?.cancel();
    await _stopDartCapture();
    final token = _token;
    if (_desired && token != null && _sensors.usesNativeCapture) {
      try {
        await _sensors.startNative(
          token: token,
          baseUrl: ApiEndpoints.backendUrl,
          capture: true,
        );
      } catch (_) {}
    }
    await _sensors.dispose();
  }
}

class _MotionLifecycle with WidgetsBindingObserver {
  _MotionLifecycle(this._notifier);

  final MotionSensorNotifier _notifier;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(_notifier.onAppResumed());
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        unawaited(_notifier.onAppBackgrounded());
      case AppLifecycleState.inactive:
        break;
    }
  }
}

final motionSensorProvider =
    NotifierProvider<MotionSensorNotifier, MotionSensorState>(
      MotionSensorNotifier.new,
    );
