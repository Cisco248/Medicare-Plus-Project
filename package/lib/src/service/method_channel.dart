import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_health_connect/src/service/android.platform.dart';
import 'package:flutter_health_connect/src/converters/export.dart';
import 'package:flutter_health_connect/src/enums/export.dart';
import 'package:flutter_health_connect/src/models/export.dart';

/// MethodChannel implementation of [HealthConnectPlatform].
///
/// ### Params
///
/// * [channel]: The method channel to use for communication.

class MethodChannelHealthConnect extends HealthConnectPlatform {
  MethodChannelHealthConnect({MethodChannel? channel})
    : _channel =
          channel ??
          const MethodChannel('dev.fluttercommunity.flutter_health_connect');

  final MethodChannel _channel;

  Future<T> _invoke<T>(String method, [Map<String, Object?>? args]) async {
    try {
      final result = await _channel.invokeMethod<T>(method, args);
      return result as T;
    } catch (error, stack) {
      throw ExceptionConverter.fromError(error, stack);
    }
  }

  @override
  Future<void> initialize({required bool enableLogging}) async {
    await _invoke<void>('initialize', {'enableLogging': enableLogging});
  }

  @override
  Future<Availability> getAvailability() async {
    final value = await _invoke<String>('getAvailability');
    return Availability.values.byName(value);
  }

  @override
  Future<PermissionStatus> checkPermissions(
    List<Permission> permissions,
  ) async {
    final result = await _invoke<Map<Object?, Object?>>('checkPermissions', {
      'permissions': permissions.map((p) => p.toMap()).toList(growable: false),
    });
    final granted = (result['granted'] as List<Object?>? ?? const [])
        .cast<Map<Object?, Object?>>()
        .map(Permission.fromMap)
        .toList(growable: false);
    return PermissionStatus(requested: permissions, granted: granted);
  }

  @override
  Future<bool> requestPermissions(List<Permission> permissions) async {
    final result = await _invoke<bool>('requestPermissions', {
      'permissions': permissions.map((p) => p.toMap()).toList(growable: false),
    });
    return result;
  }

  @override
  Future<Set<Permission>> getGrantedPermissions() async {
    final result = await _invoke<List<Object?>>('getGrantedPermissions');
    return result.cast<Map<Object?, Object?>>().map(Permission.fromMap).toSet();
  }

  @override
  Future<void> openHealthConnectSettings() async {
    await _invoke<void>('openHealthConnectSettings');
  }

  @override
  Future<void> openAppPermissions() async {
    await _invoke<void>('openAppPermissions');
  }

  @override
  Future<List<BaseRecord>> readRecords({
    required RecordType type,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final result = await _invoke<List<Object?>>('readRecords', {
      'recordType': type.name,
      'startTimeMillis': startTime.toUtc().millisecondsSinceEpoch,
      'endTimeMillis': endTime.toUtc().millisecondsSinceEpoch,
    });
    return result
        .cast<Map<Object?, Object?>>()
        .map(RecordConverter.fromMap)
        .toList(growable: false);
  }

  @override
  Future<List<String>> writeRecords(List<BaseRecord> records) async {
    final result = await _invoke<List<Object?>>('writeRecords', {
      'records': records.map((r) => r.toMap()).toList(growable: false),
    });
    return result.cast<String>();
  }

  @override
  Future<void> deleteRecord({
    required RecordType type,
    required String recordId,
  }) async {
    await _invoke<void>('deleteRecord', {
      'recordType': type.name,
      'recordId': recordId,
    });
  }

  @override
  Future<void> deleteRecordsByTimeRange({
    required RecordType type,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    await _invoke<void>('deleteRecordsByTimeRange', {
      'recordType': type.name,
      'startTimeMillis': startTime.toUtc().millisecondsSinceEpoch,
      'endTimeMillis': endTime.toUtc().millisecondsSinceEpoch,
    });
  }

  @override
  Future<AggregationResult> aggregate({
    required Metric metric,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final result = await _invoke<Map<Object?, Object?>>('aggregate', {
      'metric': metric.name,
      'startTimeMillis': startTime.toUtc().millisecondsSinceEpoch,
      'endTimeMillis': endTime.toUtc().millisecondsSinceEpoch,
    });
    return AggregationResult.fromMap(result);
  }

  @override
  Future<DailySummary> getDailyHealthSummary({required DateTime date}) async {
    final result = await _invoke<Map<Object?, Object?>>(
      'getDailyHealthSummary',
      {
        'dateMillis': DateTime(
          date.year,
          date.month,
          date.day,
        ).millisecondsSinceEpoch,
      },
    );
    return DailySummary.fromMap(result);
  }

  @override
  Future<ChangesToken> getChangesToken({
    required List<RecordType> recordTypes,
  }) async {
    final result = await _invoke<Map<Object?, Object?>>('getChangesToken', {
      'recordTypes': recordTypes.map((t) => t.name).toList(growable: false),
    });
    return ChangesToken.fromMap(result);
  }

  @override
  Future<Changes> getChanges(ChangesToken token) async {
    final result = await _invoke<Map<Object?, Object?>>(
      'getChanges',
      token.toMap(),
    );
    return Changes.fromMap(result);
  }

  @override
  String toString() =>
      'MethodChannelHealthConnect(${kIsWeb ? 'web' : 'native'})';
}
