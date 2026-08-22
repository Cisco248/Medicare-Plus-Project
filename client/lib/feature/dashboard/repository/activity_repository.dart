import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/services/health_aggregator.dart';
import 'package:client/feature/dashboard/services/health_connect.service.dart';
import 'package:flutter_health_connect/app.dart';

class ActivityRepository {
  ActivityRepository({required this._service});

  final HealthConnectService _service;

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

  Future<Availability> getAvailability() async {
    try {
      return await _service.availability();
    } catch (e) {
      throw UnknownException(details: e);
    }
  }

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

  Future<bool> requestPermissions() async {
    try {
      return await _service.requestPermissions(readPermissions);
    } on HealthConnectException catch (e) {
      throw _mapHealthConnectException(e);
    }
  }

  Future<void> openPermissionSettings() async {
    try {
      await _service.openAppPermissions();
    } on HealthConnectException catch (e) {
      throw _mapHealthConnectException(e);
    }
  }

  /// Translates SDK failures into the app's exception vocabulary.
  ///
  /// Only [HealthConnectUnavailableException] and
  /// [HealthConnectNotInstalledException] describe a device that cannot serve
  /// Health Connect at all; the SDK raises those two exclusively from an
  /// explicit availability check. Every other failure keeps its own meaning, so
  /// a denied permission or a failed provider call is no longer reported to the
  /// user as "Health Connect is not available on this device".
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
      HealthConnectInvalidRequestException() ||
      HealthConnectUnsupportedRecordException() => const ValidationException(
        message: 'This health data type is not supported on your device.',
      ),
      HealthConnectNavigationException() => const UnknownException(
        message: 'Health Connect could not be opened on this device.',
      ),
      HealthConnectNotInitializedException() => const UnknownException(
        message: 'Health Connect is still starting up. Please try again.',
      ),
      HealthConnectOperationException() => const UnknownException(
        message: 'Health Connect did not respond. Please try again.',
      ),
      _ => UnknownException(
        message: 'Reading your health data failed. Please try again.',
        details: exception.code,
      ),
    };
  }

  /// Reads a single dashboard metric for today.
  ///
  /// The permission check result is honoured rather than discarded: an
  /// ungranted metric yields an empty list so one unapproved tile cannot fail
  /// the whole dashboard. [ActivityNotifier] drives the permission prompt.
  Future<List<T>> _readToday<T>(
    List<Permission> permissions,
    Future<List<T>> Function(DateTime, DateTime) read,
  ) async {
    try {
      final status = await _service.checkPermissions(permissions);
      if (status.granted.isEmpty) return const [];
      final start = _startOfToday();
      return await read(start, start.add(const Duration(days: 1)));
    } on HealthConnectException catch (e) {
      throw _mapHealthConnectException(e);
    }
  }

  Future<List<StepsRecord>> footStep(List<Permission> permissions) =>
      _readToday(permissions, _service.readSteps);

  Future<List<TotalCaloriesBurnedRecord>> burnCalories(
    List<Permission> permissions,
  ) => _readToday(permissions, _service.readTotalCaloriesBurned);

  Future<List<HeightRecord>> bodyHeight(List<Permission> permissions) =>
      _readToday(permissions, _service.readHeight);

  Future<List<SleepSessionRecord>> sleepHour(List<Permission> permissions) {
    return _readToday(permissions, _service.readSleepSessions);
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
