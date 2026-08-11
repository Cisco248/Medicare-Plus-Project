import 'package:flutter_health_connect/src/config/configuration.dart';
import 'package:flutter_health_connect/src/enums/export.dart';
import 'package:flutter_health_connect/src/exceptions/exception.dart';
import 'package:flutter_health_connect/src/converters/export.dart';
import 'package:flutter_health_connect/src/models/export.dart';
import 'package:flutter_health_connect/src/service/android.platform.dart';

/// Primary entry point for Android Health Connect from Flutter.
///
/// This plugin is **Android-only**. Calling APIs on unsupported platforms
/// throws [HealthConnectUnavailableException].
///
/// ## Time handling
///
/// All [DateTime] arguments for record read/write/delete/aggregate/changes are
/// converted to **UTC Instant** (epoch milliseconds) before crossing the
/// platform channel. Zone offsets returned by Health Connect are preserved on
/// records when available.
///
/// [getDailyHealthSummary] interprets [date] as a **local calendar day** on the
/// Android device.
/// Creates a Health Connect client with optional [config].
///
/// [platform] is intended for tests; production code should omit it.
///

class FlutterHealthConnect {
  FlutterHealthConnect({
    this._config = const Configuration(),
    HealthConnectPlatform? platform,
  }) : _platform = platform ?? HealthConnectPlatform.instance;

  final Configuration _config;
  final HealthConnectPlatform _platform;
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Configuration get config => _config;

  void _ensureInitialized() {
    if (!_initialized) {
      throw const HealthConnectUnavailableException(
        'FlutterHealthConnect.initialize() must be called before use.',
        code: 'not_initialized',
      );
    }
  }

  void _validateTimeRange(
    DateTime startTime,
    DateTime endTime, {
    bool allowEqual = false,
  }) {
    final invalid = allowEqual
        ? endTime.isBefore(startTime)
        : !endTime.isAfter(startTime);
    if (invalid) {
      throw HealthConnectInvalidTimeRangeException(
        allowEqual
            ? 'endTime ($endTime) must not be before startTime ($startTime).'
            : 'endTime ($endTime) must be after startTime ($startTime).',
        code: 'invalid_time_range',
      );
    }
  }

  Future<void> initialize() async {
    if (_initialized) return;
    await _platform.initialize(enableLogging: _config.enableLogging);
    _initialized = true;
  }

  Future<Availability> getAvailability() async {
    _ensureInitialized();
    return _platform.getAvailability();
  }

  Future<PermissionStatus> checkPermissions(
    List<Permission> permissions,
  ) async {
    _ensureInitialized();
    return _platform.checkPermissions(permissions);
  }

  Future<bool> requestPermissions(List<Permission> permissions) async {
    _ensureInitialized();
    return _platform.requestPermissions(permissions);
  }

  Future<Set<Permission>> getGrantedPermissions() async {
    _ensureInitialized();
    return _platform.getGrantedPermissions();
  }

  /// Opens the Health Connect settings screen.
  Future<void> openHealthConnectSettings() async {
    _ensureInitialized();
    return _platform.openHealthConnectSettings();
  }

  /// Opens the screen for managing this app's Health Connect permissions.
  Future<void> openAppPermissions() async {
    _ensureInitialized();
    return _platform.openAppPermissions();
  }

  /// Reads records of [type] between [startTime] and [endTime] (UTC instants).
  Future<List<BaseRecord>> readRecords({
    required RecordType type,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    _ensureInitialized();
    _validateTimeRange(startTime, endTime);
    return _platform.readRecords(
      type: type,
      startTime: startTime,
      endTime: endTime,
    );
  }

  /// Reads step-count records within [startTime] and [endTime].
  ///
  /// Throws [HealthConnectPermissionException] if the application does not have
  /// permission to read steps.
  Future<List<StepsRecord>> readSteps({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final records = await readRecords(
      type: RecordType.steps,
      startTime: startTime,
      endTime: endTime,
    );
    return RecordConverter.castAll<StepsRecord>(records);
  }

  /// Reads distance records within [startTime] and [endTime].
  Future<List<DistanceRecord>> readDistance({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final records = await readRecords(
      type: RecordType.distance,
      startTime: startTime,
      endTime: endTime,
    );
    return RecordConverter.castAll<DistanceRecord>(records);
  }

  /// Reads active calories burned records within [startTime] and [endTime].
  Future<List<ActiveCaloriesBurnedRecord>> readActiveCaloriesBurned({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final records = await readRecords(
      type: RecordType.activeCaloriesBurned,
      startTime: startTime,
      endTime: endTime,
    );
    return RecordConverter.castAll<ActiveCaloriesBurnedRecord>(records);
  }

  /// Reads total calories burned records within [startTime] and [endTime].
  Future<List<TotalCaloriesBurnedRecord>> readTotalCaloriesBurned({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final records = await readRecords(
      type: RecordType.totalCaloriesBurned,
      startTime: startTime,
      endTime: endTime,
    );
    return RecordConverter.castAll<TotalCaloriesBurnedRecord>(records);
  }

  /// Reads heart-rate records within [startTime] and [endTime].
  Future<List<HeartRateRecord>> readHeartRate({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final records = await readRecords(
      type: RecordType.heartRate,
      startTime: startTime,
      endTime: endTime,
    );
    return RecordConverter.castAll<HeartRateRecord>(records);
  }

  /// Reads resting heart-rate records within [startTime] and [endTime].
  Future<List<RestingHeartRateRecord>> readRestingHeartRate({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final records = await readRecords(
      type: RecordType.restingHeartRate,
      startTime: startTime,
      endTime: endTime,
    );
    return RecordConverter.castAll<RestingHeartRateRecord>(records);
  }

  /// Reads sleep session records within [startTime] and [endTime].
  Future<List<SleepSessionRecord>> readSleepSessions({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final records = await readRecords(
      type: RecordType.sleepSession,
      startTime: startTime,
      endTime: endTime,
    );
    return RecordConverter.castAll<SleepSessionRecord>(records);
  }

  /// Reads weight records within [startTime] and [endTime].
  Future<List<WeightRecord>> readWeight({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final records = await readRecords(
      type: RecordType.weight,
      startTime: startTime,
      endTime: endTime,
    );
    return RecordConverter.castAll<WeightRecord>(records);
  }

  /// Reads blood pressure records within [startTime] and [endTime].
  Future<List<BloodPressureRecord>> readBloodPressure({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final records = await readRecords(
      type: RecordType.bloodPressure,
      startTime: startTime,
      endTime: endTime,
    );
    return RecordConverter.castAll<BloodPressureRecord>(records);
  }

  /// Reads blood glucose records within [startTime] and [endTime].
  Future<List<BloodGlucoseRecord>> readBloodGlucose({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final records = await readRecords(
      type: RecordType.bloodGlucose,
      startTime: startTime,
      endTime: endTime,
    );
    return RecordConverter.castAll<BloodGlucoseRecord>(records);
  }

  /// Reads oxygen saturation records within [startTime] and [endTime].
  Future<List<OxygenSaturationRecord>> readOxygenSaturation({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final records = await readRecords(
      type: RecordType.oxygenSaturation,
      startTime: startTime,
      endTime: endTime,
    );
    return RecordConverter.castAll<OxygenSaturationRecord>(records);
  }

  /// Reads nutrition records within [startTime] and [endTime].
  Future<List<NutritionRecord>> readNutrition({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final records = await readRecords(
      type: RecordType.nutrition,
      startTime: startTime,
      endTime: endTime,
    );
    return RecordConverter.castAll<NutritionRecord>(records);
  }

  /// Inserts [records] and returns their Health Connect IDs.
  ///
  /// Requires the corresponding write permissions to already be granted.
  Future<List<String>> writeRecords(List<BaseRecord> records) async {
    _ensureInitialized();
    if (records.isEmpty) return const [];
    for (final record in records) {
      // Instantaneous records may have equal start/end timestamps.
      _validateTimeRange(record.startTime, record.endTime, allowEqual: true);
    }
    return _platform.writeRecords(records);
  }

  /// Writes a steps record and returns its Health Connect ID.
  Future<String> writeSteps({
    required int count,
    required DateTime startTime,
    required DateTime endTime,
    String? clientRecordId,
  }) async {
    final ids = await writeRecords([
      StepsRecord(
        id: '',
        startTime: startTime,
        endTime: endTime,
        count: count,
        clientRecordId: clientRecordId,
      ),
    ]);
    return ids.first;
  }

  /// Writes a weight record and returns its Health Connect ID.
  Future<String> writeWeight({
    required double weightKilograms,
    required DateTime time,
    String? clientRecordId,
  }) async {
    final ids = await writeRecords([
      WeightRecord(
        id: '',
        startTime: time,
        endTime: time,
        weightKilograms: weightKilograms,
        clientRecordId: clientRecordId,
      ),
    ]);
    return ids.first;
  }

  /// Writes a heart-rate record and returns its Health Connect ID.
  Future<String> writeHeartRate({
    required List<HeartRateSample> samples,
    required DateTime startTime,
    required DateTime endTime,
    String? clientRecordId,
  }) async {
    final ids = await writeRecords([
      HeartRateRecord(
        id: '',
        startTime: startTime,
        endTime: endTime,
        samples: samples,
        clientRecordId: clientRecordId,
      ),
    ]);
    return ids.first;
  }

  /// Deletes a single record by [type] and [recordId].
  ///
  /// This is a destructive operation and must be called explicitly.
  Future<void> deleteRecord({
    required RecordType type,
    required String recordId,
  }) async {
    _ensureInitialized();
    if (recordId.isEmpty) {
      throw const HealthConnectRecordException(
        'recordId must not be empty.',
        code: 'invalid_record_id',
      );
    }
    return _platform.deleteRecord(type: type, recordId: recordId);
  }

  /// Deletes records of [type] between [startTime] and [endTime].
  ///
  /// This is a destructive operation and must be called explicitly.
  Future<void> deleteRecordsByTimeRange({
    required RecordType type,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    _ensureInitialized();
    _validateTimeRange(startTime, endTime);
    return _platform.deleteRecordsByTimeRange(
      type: type,
      startTime: startTime,
      endTime: endTime,
    );
  }

  /// Aggregates [metric] using Health Connect's native aggregation APIs.
  Future<AggregationResult> aggregate({
    required Metric metric,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    _ensureInitialized();
    _validateTimeRange(startTime, endTime);
    return _platform.aggregate(
      metric: metric,
      startTime: startTime,
      endTime: endTime,
    );
  }

  /// Returns a daily health summary for the local calendar day of [date].
  ///
  /// Only fields with available data are populated. There is no BMI field
  /// because Health Connect has no first-class BMI record type.
  Future<DailySummary> getDailyHealthSummary({required DateTime date}) async {
    _ensureInitialized();
    return _platform.getDailyHealthSummary(date: date);
  }

  /// Obtains a changes token for incremental synchronization of [recordTypes].
  Future<ChangesToken> getChangesToken({
    required List<RecordType> recordTypes,
  }) async {
    _ensureInitialized();
    if (recordTypes.isEmpty) {
      throw const HealthConnectChangesException(
        'recordTypes must not be empty.',
        code: 'invalid_record_types',
      );
    }
    return _platform.getChangesToken(recordTypes: recordTypes);
  }

  /// Fetches incremental changes for [token].
  ///
  /// When [HealthChanges.changesTokenExpired] is `true`, obtain a new token
  /// via [getChangesToken] and perform a full resync.
  Future<Changes> getChanges(ChangesToken token) async {
    _ensureInitialized();
    return _platform.getChanges(token);
  }
}
