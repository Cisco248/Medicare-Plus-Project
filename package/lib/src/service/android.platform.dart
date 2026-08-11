import 'package:flutter_health_connect/app.dart';
import 'package:flutter_health_connect/src/service/method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Platform-specific implementations should set this with their own
/// platform-specific class that extends [HealthConnectPlatform] when
/// they register themselves.

/// Initializes the platform implementation.
/// Returns Health Connect availability.
/// Checks which of [permissions] are currently granted.
/// Requests [permissions] via the Health Connect permission UI.
/// Returns all currently granted Health Connect permissions known to the plugin.
/// Opens Health Connect settings.
/// Opens the app's Health Connect permission management screen.
/// Reads records of [type] between [startTime] and [endTime] (UTC instants).
/// Inserts [records] and returns their Health Connect IDs.
/// Deletes a single record by type and ID.
/// Deletes records of [type] in a time range.
/// Aggregates [metric] between [startTime] and [endTime].
/// Builds a daily summary for the local calendar day of [date].
/// Obtains a changes token for [recordTypes].
/// Fetches incremental changes for [token].

abstract class HealthConnectPlatform extends PlatformInterface {
  HealthConnectPlatform() : super(token: _token);

  static final Object _token = Object();

  static HealthConnectPlatform _instance = MethodChannelHealthConnect();

  static HealthConnectPlatform get instance => _instance;

  static set instance(HealthConnectPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize({required bool enableLogging}) async {
    try {
      return await _instance.initialize(enableLogging: enableLogging);
    } catch (e) {
      throw HealthConnectNotInstalledException(
        "Failed to Initialized Service!",
      );
    }
  }

  Future<Availability> getAvailability() async {
    try {
      final availability = await _instance.getAvailability();
      if (availability == Availability.notSupported) return availability;
      if (availability == Availability.notInstalled) return availability;
      if (availability == Availability.unknown) {
        throw HealthConnectUnavailableException(
          "Health Connect Status is Unknown",
          code: 'unknown',
          details: availability.name.toString(),
        );
      }
      return availability;
    } catch (e) {
      throw HealthConnectUnavailableException(
        'Health Connect Unavailable.',
        code: 'unavailable',
        details: e,
      );
    }
  }

  Future<PermissionStatus> checkPermissions(
    List<Permission> permissions,
  ) async {
    try {
      final result = await _instance.checkPermissions(permissions);
      return result;
    } catch (e) {
      throw HealthConnectUnavailableException(
        'Failed Check Permission!.',
        code: 'failed',
        details: e,
      );
    }
  }

  Future<bool> requestPermissions(List<Permission> permissions) async {
    try {
      return _instance.requestPermissions(permissions);
    } catch (e) {
      throw HealthConnectPermissionException(
        "Failed Request Permission!",
        code: "failed",
        details: e,
      );
    }
  }

  Future<Set<Permission>> getGrantedPermissions() async {
    try {
      final result = await _instance.getGrantedPermissions();
      if (result.isEmpty) {
        throw HealthConnectPermissionException(
          "Permissions are not Found!",
          code: "not_found",
          details: result.toString(),
        );
      }
      return result;
    } catch (e) {
      throw HealthConnectPermissionException(
        "Failed Get Granted Permission",
        code: "failed",
        details: e,
      );
    }
  }

  Future<void> openHealthConnectSettings() async {
    try {
      return await _instance.openHealthConnectSettings();
    } catch (e) {
      throw HealthConnectUnknownException(
        'Failed Open App Setting!',
        code: "failed",
        details: e,
      );
    }
  }

  Future<void> openAppPermissions() async {
    try {
      return await _instance.openAppPermissions();
    } catch (e) {
      throw HealthConnectUnknownException(
        'Failed Open App Permission!',
        code: "failed",
        details: e,
      );
    }
  }

  Future<List<BaseRecord>> readRecords({
    required RecordType type,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      return await _instance.readRecords(
        type: type,
        startTime: startTime,
        endTime: endTime,
      );
    } catch (e) {
      throw HealthConnectRecordException(
        "Faild Read Records!",
        code: "failed",
        details: e,
      );
    }
  }

  Future<List<String>> writeRecords(List<BaseRecord> records) async {
    try {
      if (records.isEmpty) {
        throw HealthConnectRecordException(
          "Records are not Found!",
          code: 'not_found',
          details: records,
        );
      }
      return await _instance.writeRecords(records);
    } catch (e) {
      throw HealthConnectRecordException(
        "Faild Write Record!",
        code: "failed",
        details: e,
      );
    }
  }

  Future<void> deleteRecord({
    required RecordType type,
    required String recordId,
  }) async {
    try {
      return await _instance.deleteRecord(type: type, recordId: recordId);
    } catch (e) {
      throw HealthConnectRecordException(
        "Faild Delete Records!",
        code: "failed",
        details: e,
      );
    }
  }

  Future<void> deleteRecordsByTimeRange({
    required RecordType type,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      return await _instance.deleteRecordsByTimeRange(
        type: type,
        startTime: startTime,
        endTime: endTime,
      );
    } catch (e) {
      throw HealthConnectRecordException(
        "Faild Delete Records by Time Range!",
        code: "failed",
        details: e,
      );
    }
  }

  Future<AggregationResult> aggregate({
    required Metric metric,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      if (metric.name == '' &&
          startTime.timeZoneName == '' &&
          endTime.timeZoneName == '') {
        throw HealthConnectRecordException("All feilds are empty!");
      }
      return await _instance.aggregate(
        metric: metric,
        startTime: startTime,
        endTime: endTime,
      );
    } catch (e) {
      throw HealthConnectRecordException(
        "Faild Aggregate Records!",
        code: "failed",
        details: e,
      );
    }
  }

  Future<DailySummary> getDailyHealthSummary({required DateTime date}) async {
    try {
      if (date.timeZoneName == '') {
        throw HealthConnectRecordException(
          "Input are empty",
          code: 'not_found',
          details: date.timeZoneName,
        );
      }
      return _instance.getDailyHealthSummary(date: date);
    } catch (e) {
      throw HealthConnectUnsupportedRecordException(
        "Failed get Health Summary",
        code: 'failed',
        details: e,
      );
    }
  }

  Future<ChangesToken> getChangesToken({
    required List<RecordType> recordTypes,
  }) async {
    try {
      return await _instance.getChangesToken(recordTypes: recordTypes);
    } catch (e) {
      throw HealthConnectChangesException(
        "Failed Get Change Token",
        code: 'failed',
        details: e,
      );
    }
  }

  Future<Changes> getChanges(ChangesToken token) async {
    try {
      return await _instance.getChanges(token);
    } catch (e) {
      throw HealthConnectChangesException(
        "Failed Get Change Token",
        code: 'failed',
        details: e,
      );
    }
  }
}
