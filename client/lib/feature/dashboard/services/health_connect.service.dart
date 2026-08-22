import 'package:flutter_health_connect/app.dart';

class HealthConnectService {
  HealthConnectService({FlutterHealthConnect? sdk})
    : _sdk = sdk ?? FlutterHealthConnect();

  final FlutterHealthConnect _sdk;

  Future<void> _ensureInitialized() async {
    if (!_sdk.isInitialized) await _sdk.initialize();
  }

  Future<Availability> availability() async {
    await _ensureInitialized();
    return _sdk.getAvailability();
  }

  Future<PermissionStatus> checkPermissions(
    List<Permission> permissions,
  ) async {
    await _ensureInitialized();
    return _sdk.checkPermissions(permissions);
  }

  Future<bool> requestPermissions(List<Permission> permissions) async {
    await _ensureInitialized();
    return _sdk.requestPermissions(permissions);
  }

  Future<void> openAppPermissions() async {
    await _ensureInitialized();
    return _sdk.openAppPermissions();
  }

  Future<List<StepsRecord>> readSteps(DateTime start, DateTime end) async {
    await _ensureInitialized();
    return _sdk.readSteps(startTime: start, endTime: end);
  }

  Future<List<DistanceRecord>> readDistance(
    DateTime start,
    DateTime end,
  ) async {
    await _ensureInitialized();
    return _sdk.readDistance(startTime: start, endTime: end);
  }

  Future<List<ActiveCaloriesBurnedRecord>> readActiveCaloriesBurned(
    DateTime start,
    DateTime end,
  ) async {
    await _ensureInitialized();
    return _sdk.readActiveCaloriesBurned(startTime: start, endTime: end);
  }

  Future<List<TotalCaloriesBurnedRecord>> readTotalCaloriesBurned(
    DateTime start,
    DateTime end,
  ) async {
    await _ensureInitialized();
    return _sdk.readTotalCaloriesBurned(startTime: start, endTime: end);
  }

  Future<List<HeartRateRecord>> readHeartRate(
    DateTime start,
    DateTime end,
  ) async {
    await _ensureInitialized();
    return _sdk.readHeartRate(startTime: start, endTime: end);
  }

  Future<List<RestingHeartRateRecord>> readRestingHeartRate(
    DateTime start,
    DateTime end,
  ) async {
    await _ensureInitialized();
    return _sdk.readRestingHeartRate(startTime: start, endTime: end);
  }

  Future<List<SleepSessionRecord>> readSleepSessions(
    DateTime start,
    DateTime end,
  ) async {
    await _ensureInitialized();
    return _sdk.readSleepSessions(startTime: start, endTime: end);
  }

  Future<List<ExerciseSessionRecord>> readExerciseSessions(
    DateTime start,
    DateTime end,
  ) async {
    await _ensureInitialized();
    final records = await _sdk.readRecords(
      type: RecordType.exerciseSession,
      startTime: start,
      endTime: end,
    );
    return records.whereType<ExerciseSessionRecord>().toList(growable: false);
  }

  Future<List<WeightRecord>> readWeight(DateTime start, DateTime end) async {
    await _ensureInitialized();
    return _sdk.readWeight(startTime: start, endTime: end);
  }

  Future<List<HeightRecord>> readHeight(DateTime start, DateTime end) async {
    await _ensureInitialized();
    final records = await _sdk.readRecords(
      type: RecordType.height,
      startTime: start,
      endTime: end,
    );
    return records.whereType<HeightRecord>().toList(growable: false);
  }

  Future<List<BloodPressureRecord>> readBloodPressure(
    DateTime start,
    DateTime end,
  ) async {
    await _ensureInitialized();
    return _sdk.readBloodPressure(startTime: start, endTime: end);
  }

  Future<List<BloodGlucoseRecord>> readBloodGlucose(
    DateTime start,
    DateTime end,
  ) async {
    await _ensureInitialized();
    return _sdk.readBloodGlucose(startTime: start, endTime: end);
  }

  Future<List<OxygenSaturationRecord>> readOxygenSaturation(
    DateTime start,
    DateTime end,
  ) async {
    await _ensureInitialized();
    return _sdk.readOxygenSaturation(startTime: start, endTime: end);
  }

  Future<DailySummary> getDailyHealthSummary(DateTime date) async {
    await _ensureInitialized();
    return _sdk.getDailyHealthSummary(date: date);
  }
}
