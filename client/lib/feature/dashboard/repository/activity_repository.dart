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

  /// Last [days] local calendar days from Health Connect.
  ///
  /// Reads native daily aggregates (not a single 7-day sum) so each chart
  /// bar is one patient day. Missing days stay null.
  Future<WeeklyActivityResult> collectWeeklyActivity({int days = 7}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = today.subtract(Duration(days: days - 1));
    final rangeEnd = today.add(const Duration(days: 1));

    try {
      final availability = await _service.availability();
      if (availability == Availability.notInstalled ||
          availability == Availability.notSupported) {
        return WeeklyActivityResult(
          status: HealthAccessStatus.unavailable,
          days: _emptyWeek(start, days),
        );
      }

      final permissionStatus = await _service.checkPermissions(readPermissions);
      final granted = permissionStatus.granted.map((p) => p.recordType).toSet();
      final deniedMetrics = permissionStatus.denied
          .map((p) => p.recordType.name)
          .toList(growable: false);

      if (granted.isEmpty) {
        return WeeklyActivityResult(
          status: HealthAccessStatus.denied,
          days: _emptyWeek(start, days),
          deniedMetrics: deniedMetrics,
        );
      }

      final daily = <ActivityModel>[];
      for (var offset = 0; offset < days; offset++) {
        daily.add(await _readDailySummary(start.add(Duration(days: offset))));
      }

      if (granted.contains(RecordType.exerciseSession)) {
        final sessions = await _readIfGrantedSessions(start, rangeEnd);
        for (var index = 0; index < daily.length; index++) {
          final day = daily[index].date;
          final workouts = HealthAggregator.summarizeWorkouts(
            _sessionsOnLocalDay(sessions, day),
          );
          if (workouts.isNotEmpty) {
            daily[index] = daily[index].copyWith(workouts: workouts);
          }
        }
      }

      return WeeklyActivityResult(
        status: permissionStatus.allGranted
            ? HealthAccessStatus.granted
            : HealthAccessStatus.partial,
        days: daily,
        deniedMetrics: deniedMetrics,
      );
    } on HealthConnectException catch (e) {
      throw _mapHealthConnectException(e);
    }
  }

  Future<ActivityModel> _readDailySummary(DateTime day) async {
    final date = DateTime(day.year, day.month, day.day);
    try {
      final summary = await _service.getDailyHealthSummary(date);
      return _activityFromDailySummary(summary, date);
    } on HealthConnectPermissionException {
      return ActivityModel(date: date);
    } on HealthConnectSecurityException {
      return ActivityModel(date: date);
    } on HealthConnectException {
      return ActivityModel(date: date);
    }
  }

  Future<List<ExerciseSessionRecord>> _readIfGrantedSessions(
    DateTime start,
    DateTime end,
  ) async {
    try {
      return await _service.readExerciseSessions(start, end);
    } on HealthConnectPermissionException {
      return const [];
    } on HealthConnectSecurityException {
      return const [];
    }
  }

  List<ExerciseSessionRecord> _sessionsOnLocalDay(
    List<ExerciseSessionRecord> sessions,
    DateTime day,
  ) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return [
      for (final session in sessions)
        if (!session.startTime.toLocal().isBefore(start) &&
            session.startTime.toLocal().isBefore(end))
          session,
    ];
  }

  ActivityModel _activityFromDailySummary(DailySummary summary, DateTime date) {
    final sleep = summary.sleepDuration;
    return ActivityModel(
      date: date,
      steps: summary.steps,
      distanceMeters: summary.distanceMeters,
      activeCalories: summary.activeCalories,
      totalCalories: summary.totalCalories,
      heartRate:
          summary.averageHeartRate == null && summary.restingHeartRate == null
          ? null
          : HeartRateSummary(
              averageBpm: summary.averageHeartRate,
              restingBpm: summary.restingHeartRate,
            ),
      sleep: sleep == null
          ? null
          : SleepSummary(totalMinutes: sleep.inMinutes, sessionCount: 1),
      weightKilograms: summary.weight,
    );
  }

  List<ActivityModel> _emptyWeek(DateTime start, int days) {
    return [
      for (var offset = 0; offset < days; offset++)
        ActivityModel(date: start.add(Duration(days: offset))),
    ];
  }

  Future<bool> requestPermissions() async {
    try {
      return await _service.requestPermissions(readPermissions);
    } on HealthConnectException catch (e) {
      throw _mapHealthConnectException(e);
    }
  }

  Future<PermissionStatus> checkReadPermissions() async {
    try {
      return await _service.checkPermissions(readPermissions);
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
}
