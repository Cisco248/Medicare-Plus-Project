import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_health_connect/src/service/android.platform.dart';
import 'package:flutter_health_connect/src/converters/export.dart';
import 'package:flutter_health_connect/src/enums/export.dart';
import 'package:flutter_health_connect/src/exceptions/exception.dart';
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

  /// Invokes [method] and requires a non-null [T] payload.
  Future<T> _invoke<T extends Object>(
    String method, [
    Map<String, Object?>? args,
  ]) async {
    final Object? result;
    try {
      result = await _channel.invokeMethod<T>(method, args);
    } catch (error, stack) {
      throw ExceptionConverter.fromError(error, stack);
    }
    if (result is! T) {
      // A null or mistyped payload means the Dart and Kotlin sides disagree
      // about this method's contract. Reporting it as a bridge fault is far
      // more actionable than the raw cast error it used to surface as.
      throw HealthConnectOperationException(
        "Platform channel returned ${result.runtimeType} for '$method', "
        'expected $T.',
        code: 'invalid_platform_response',
      );
    }
    return result;
  }

  /// Invokes [method] and ignores the payload.
  Future<void> _invokeVoid(String method, [Map<String, Object?>? args]) async {
    try {
      await _channel.invokeMethod<void>(method, args);
    } catch (error, stack) {
      throw ExceptionConverter.fromError(error, stack);
    }
  }

  @override
  Future<void> initialize({required bool enableLogging}) async {
    await _invokeVoid('initialize', {'enableLogging': enableLogging});
  }

  @override
  Future<Availability> getAvailability() async {
    final value = await _invoke<String>('getAvailability');
    return Availability.values.asNameMap()[value] ?? Availability.unknown;
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
    await _invokeVoid('openHealthConnectSettings');
  }

  @override
  Future<void> openAppPermissions() async {
    await _invokeVoid('openAppPermissions');
  }

  @override
  Future<void> openHealthConnectDataManagement() async {
    await _invokeVoid('openHealthConnectDataManagement');
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
    await _invokeVoid('deleteRecord', {
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
    await _invokeVoid('deleteRecordsByTimeRange', {
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
