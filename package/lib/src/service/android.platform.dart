import 'package:flutter_health_connect/src/enums/export.dart';
import 'package:flutter_health_connect/src/models/export.dart';
import 'package:flutter_health_connect/src/service/method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Contract between [FlutterHealthConnect] and a platform implementation.
///
/// This is a pure interface: every member is abstract and must be implemented
/// by the platform class. Implementations are responsible for surfacing typed
/// [HealthConnectException]s; this layer deliberately performs **no** error
/// translation of its own.
///
/// That is a correctness requirement, not a style choice. A wrapper here that
/// caught every error and rethrew a single type would erase the distinction
/// between "Health Connect is missing", "the user denied access" and "the call
/// failed", which callers rely on to decide what to show the user.
///
/// Platform implementations register themselves by assigning [instance].
abstract class HealthConnectPlatform extends PlatformInterface {
  HealthConnectPlatform() : super(token: _token);

  static final Object _token = Object();
  static HealthConnectPlatform _instance = MethodChannelHealthConnect();
  static HealthConnectPlatform get instance => _instance;

  static set instance(HealthConnectPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the platform implementation.
  Future<void> initialize({required bool enableLogging});

  /// Returns Health Connect availability on this device.
  Future<Availability> getAvailability();

  /// Checks which of [permissions] are currently granted.
  Future<PermissionStatus> checkPermissions(List<Permission> permissions);

  /// Requests [permissions] via the Health Connect permission UI.
  ///
  /// Returns `true` only when every requested permission was granted.
  Future<bool> requestPermissions(List<Permission> permissions);

  /// Returns all granted Health Connect permissions the plugin can model.
  Future<Set<Permission>> getGrantedPermissions();

  /// Opens the Health Connect home / settings screen.
  Future<void> openHealthConnectSettings();

  /// Opens the screen listing this app's Health Connect permissions.
  Future<void> openAppPermissions();

  /// Opens the Health Connect data and access management screen.
  Future<void> openHealthConnectDataManagement();

  /// Reads records of [type] between [startTime] and [endTime] (UTC instants).
  Future<List<BaseRecord>> readRecords({
    required RecordType type,
    required DateTime startTime,
    required DateTime endTime,
  });

  /// Inserts [records] and returns their Health Connect IDs.
  Future<List<String>> writeRecords(List<BaseRecord> records);

  /// Deletes a single record by type and ID.
  Future<void> deleteRecord({
    required RecordType type,
    required String recordId,
  });

  /// Deletes records of [type] in a time range.
  Future<void> deleteRecordsByTimeRange({
    required RecordType type,
    required DateTime startTime,
    required DateTime endTime,
  });

  /// Aggregates [metric] between [startTime] and [endTime].
  Future<AggregationResult> aggregate({
    required Metric metric,
    required DateTime startTime,
    required DateTime endTime,
  });

  /// Builds a daily summary for the local calendar day of [date].
  Future<DailySummary> getDailyHealthSummary({required DateTime date});

  /// Obtains a changes token for [recordTypes].
  Future<ChangesToken> getChangesToken({required List<RecordType> recordTypes});

  /// Fetches incremental changes for [token].
  Future<Changes> getChanges(ChangesToken token);
}
