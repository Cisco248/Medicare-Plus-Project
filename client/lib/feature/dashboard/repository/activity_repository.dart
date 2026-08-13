import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/services/health_aggregator.dart';
import 'package:client/feature/dashboard/services/health_connect.service.dart';
import 'package:flutter_health_connect/app.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_repository.g.dart';

@riverpod
ActivityRepository activityRepository(Ref ref) =>
    ActivityRepository(service: ref.watch(healthConnectServiceProvider));

/// Health Connect access level determined while collecting data.
enum HealthAccessStatus {
  /// Health Connect is not supported or not installed on this device.
  unavailable,

  /// None of the requested read permissions are granted.
  denied,

  /// Some read permissions are granted; missing metrics are `null`.
  partial,

  /// All requested read permissions are granted.
  granted,
}

/// Result of a Health Connect collection run.
class HealthDataResult {
  const HealthDataResult({
    required this.status,
    this.activity,
    this.deniedMetrics = const <String>[],
  });

  final HealthAccessStatus status;

  /// Normalized data; `null` unless at least collection was attempted.
  final ActivityModel? activity;

  /// Record-type names the user has not granted read access to.
  final List<String> deniedMetrics;
}

/// Coordinates Health Connect data collection and normalization.
///
/// Reads only record types the user granted access to, aggregates raw
/// records via [HealthAggregator], and maps SDK exceptions into the
/// application's [AppException] hierarchy.
class ActivityRepository {
  ActivityRepository({required this._service});

  final HealthConnectService _service;

  /// All read permissions this feature can take advantage of.
  static final List<Permission> readPermissions = List.unmodifiable([
    Permission.steps.read,
    Permission.distance.read,
    Permission.activeCaloriesBurned.read,
    Permission.totalCaloriesBurned.read,
    Permission.heartRate.read,
    Permission.restingHeartRate.read,
    Permission.sleepSession.read,
    Permission.exerciseSession.read,
    Permission.weight.read,
    Permission.height.read,
    Permission.bloodPressure.read,
    Permission.bloodGlucose.read,
    Permission.oxygenSaturation.read,
  ]);

  /// Collects and normalizes all permitted health data for `[start, end)`.
  ///
  /// Metrics without permission or without records are `null` in the
  /// resulting [ActivityModel]; they must never be interpreted as zero.
  Future<HealthDataResult> collectActivity({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final availability = await _service.availability();
      if (availability == Availability.notInstalled ||
          availability == Availability.notSupported) {
        return const HealthDataResult(status: HealthAccessStatus.unavailable);
      }

      final permissionStatus = await _service.checkPermissions(readPermissions);
      final granted = permissionStatus.granted.map((p) => p.recordType).toSet();
      final deniedMetrics = permissionStatus.denied
          .map((p) => p.recordType.name)
          .toList(growable: false);

      if (granted.isEmpty) {
        return HealthDataResult(
          status: HealthAccessStatus.denied,
          deniedMetrics: deniedMetrics,
        );
      }

      final activity = await _readActivity(granted, startTime, endTime);
      return HealthDataResult(
        status: permissionStatus.allGranted
            ? HealthAccessStatus.granted
            : HealthAccessStatus.partial,
        activity: activity,
        deniedMetrics: deniedMetrics,
      );
    } on HealthConnectException catch (e) {
      throw _mapHealthConnectException(e);
    }
  }

  Future<ActivityModel> _readActivity(
    Set<RecordType> granted,
    DateTime start,
    DateTime end,
  ) async {
    Future<List<T>> readIfGranted<T>(
      RecordType type,
      Future<List<T>> Function(DateTime, DateTime) read,
    ) async {
      if (!granted.contains(type)) return const [];
      try {
        return await read(start, end);
      } on HealthConnectPermissionException {
        // Permission was revoked between the check and the read.
        return const [];
      } on HealthConnectSecurityException {
        return const [];
      }
    }

    final steps = await readIfGranted(RecordType.steps, _service.readSteps);
    final distance = await readIfGranted(
      RecordType.distance,
      _service.readDistance,
    );
    final activeCalories = await readIfGranted(
      RecordType.activeCaloriesBurned,
      _service.readActiveCaloriesBurned,
    );
    final totalCalories = await readIfGranted(
      RecordType.totalCaloriesBurned,
      _service.readTotalCaloriesBurned,
    );
    final heartRate = await readIfGranted(
      RecordType.heartRate,
      _service.readHeartRate,
    );
    final restingHeartRate = await readIfGranted(
      RecordType.restingHeartRate,
      _service.readRestingHeartRate,
    );
    final sleep = await readIfGranted(
      RecordType.sleepSession,
      _service.readSleepSessions,
    );
    final workouts = await readIfGranted(
      RecordType.exerciseSession,
      _service.readExerciseSessions,
    );
    final weight = await readIfGranted(RecordType.weight, _service.readWeight);
    final height = await readIfGranted(RecordType.height, _service.readHeight);
    final bloodPressure = await readIfGranted(
      RecordType.bloodPressure,
      _service.readBloodPressure,
    );
    final bloodGlucose = await readIfGranted(
      RecordType.bloodGlucose,
      _service.readBloodGlucose,
    );
    final oxygenSaturation = await readIfGranted(
      RecordType.oxygenSaturation,
      _service.readOxygenSaturation,
    );

    return ActivityModel(
      date: DateTime(start.year, start.month, start.day),
      steps: HealthAggregator.sumSteps(
        HealthAggregator.filterByRange(steps, start, end),
      ),
      distanceMeters: HealthAggregator.sumDistanceMeters(
        HealthAggregator.filterByRange(distance, start, end),
      ),
      activeCalories: HealthAggregator.sumActiveCalories(
        HealthAggregator.filterByRange(activeCalories, start, end),
      ),
      totalCalories: HealthAggregator.sumTotalCalories(
        HealthAggregator.filterByRange(totalCalories, start, end),
      ),
      heartRate: HealthAggregator.summarizeHeartRate(
        HealthAggregator.filterByRange(heartRate, start, end),
        HealthAggregator.filterByRange(restingHeartRate, start, end),
      ),
      sleep: HealthAggregator.summarizeSleep(
        HealthAggregator.filterByRange(sleep, start, end),
      ),
      workouts: HealthAggregator.summarizeWorkouts(
        HealthAggregator.filterByRange(workouts, start, end),
      ),
      weightKilograms: HealthAggregator.latestWeightKilograms(
        HealthAggregator.filterByRange(weight, start, end),
      ),
      heightMeters: HealthAggregator.latestHeightMeters(
        HealthAggregator.filterByRange(height, start, end),
      ),
      bloodPressure: HealthAggregator.latestBloodPressure(
        HealthAggregator.filterByRange(bloodPressure, start, end),
      ),
      bloodGlucoseMmolPerLiter: HealthAggregator.latestBloodGlucoseMmolPerLiter(
        HealthAggregator.filterByRange(bloodGlucose, start, end),
      ),
      oxygenSaturationPercent: HealthAggregator.latestOxygenSaturationPercent(
        HealthAggregator.filterByRange(oxygenSaturation, start, end),
      ),
    );
  }

  /// Opens the system Health Connect permission flow.
  Future<bool> requestPermissions() async {
    try {
      return await _service.requestPermissions(readPermissions);
    } on HealthConnectException catch (e) {
      throw _mapHealthConnectException(e);
    }
  }

  /// Opens this app's Health Connect permission management screen.
  Future<void> openPermissionSettings() async {
    try {
      await _service.openAppPermissions();
    } on HealthConnectException catch (e) {
      throw _mapHealthConnectException(e);
    }
  }

  AppException _mapHealthConnectException(HealthConnectException exception) {
    return switch (exception) {
      HealthConnectUnavailableException() ||
      HealthConnectNotInstalledException() => const NotFoundException(
        message: 'Health Connect is not available on this device.',
      ),
      HealthConnectPermissionException() ||
      HealthConnectSecurityException() => const ForbiddenException(
        message: 'Health Connect access has not been granted.',
      ),
      HealthConnectInvalidTimeRangeException() => const ValidationException(
        message: 'The selected period is invalid.',
      ),
      _ => UnknownException(
        message: 'Reading your health data failed. Please try again.',
        details: exception.code,
      ),
    };
  }

  // ---------------------------------------------------------------------
  // Legacy per-metric reads used by the existing dashboard activity cards.
  // ---------------------------------------------------------------------

  Future<List<StepsRecord>> footStep(List<Permission> permissions) async {
    try {
      await _service.checkPermissions(permissions);
      final start = _startOfToday();
      return await _service.readSteps(
        start,
        start.add(const Duration(days: 1)),
      );
    } on HealthConnectException catch (e) {
      throw _mapHealthConnectException(e);
    }
  }

  Future<List<TotalCaloriesBurnedRecord>> burnCalories(
    List<Permission> permissions,
  ) async {
    try {
      await _service.checkPermissions(permissions);
      final start = _startOfToday();
      return await _service.readTotalCaloriesBurned(
        start,
        start.add(const Duration(days: 1)),
      );
    } on HealthConnectException catch (e) {
      throw _mapHealthConnectException(e);
    }
  }

  Future<DailySummary> dailySummary() async {
    try {
      return await _service.getDailyHealthSummary(_startOfToday());
    } on HealthConnectException catch (e) {
      throw _mapHealthConnectException(e);
    }
  }

  DateTime _startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
