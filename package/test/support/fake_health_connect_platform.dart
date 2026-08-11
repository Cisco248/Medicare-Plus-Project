library;

import 'package:flutter_health_connect/app.dart';

/// In-memory fake used by Dart unit tests.
class FakeHealthConnectPlatform extends HealthConnectPlatform {
  int initializeCount = 0;
  Availability availability = Availability.available;
  Set<Permission> grantedPermissions = {};
  bool grantAllOnRequest = true;
  List<BaseRecord> recordsToReturn = const [];
  final List<BaseRecord> writtenRecords = [];
  double? aggregateValue;
  bool changesExpired = false;
  Object? throwOnRead;
  int? lastReadStartMillis;
  int? lastReadEndMillis;

  @override
  Future<void> initialize({required bool enableLogging}) async {
    initializeCount += 1;
  }

  @override
  Future<Availability> getAvailability() async => availability;

  @override
  Future<PermissionStatus> checkPermissions(
    List<Permission> permissions,
  ) async {
    final granted = permissions
        .where(grantedPermissions.contains)
        .toList(growable: false);
    return PermissionStatus(requested: permissions, granted: granted);
  }

  @override
  Future<bool> requestPermissions(List<Permission> permissions) async {
    if (grantAllOnRequest) {
      grantedPermissions = {...grantedPermissions, ...permissions};
      return true;
    }
    return false;
  }

  @override
  Future<Set<Permission>> getGrantedPermissions() async => grantedPermissions;

  @override
  Future<void> openHealthConnectSettings() async {}

  @override
  Future<void> openAppPermissions() async {}

  @override
  Future<List<BaseRecord>> readRecords({
    required RecordType type,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    if (throwOnRead != null) {
      throw throwOnRead!;
    }
    lastReadStartMillis = startTime.toUtc().millisecondsSinceEpoch;
    lastReadEndMillis = endTime.toUtc().millisecondsSinceEpoch;
    return recordsToReturn
        .where((r) => r.recordType == type)
        .toList(growable: false);
  }

  @override
  Future<List<String>> writeRecords(List<BaseRecord> records) async {
    writtenRecords.addAll(records);
    return List.generate(records.length, (i) => 'fake-id-$i');
  }

  @override
  Future<void> deleteRecord({
    required RecordType type,
    required String recordId,
  }) async {}

  @override
  Future<void> deleteRecordsByTimeRange({
    required RecordType type,
    required DateTime startTime,
    required DateTime endTime,
  }) async {}

  @override
  Future<AggregationResult> aggregate({
    required Metric metric,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    return AggregationResult(
      metric: metric,
      startTime: startTime,
      endTime: endTime,
      value: aggregateValue,
    );
  }

  @override
  Future<DailySummary> getDailyHealthSummary({required DateTime date}) async {
    return DailySummary(date: date, steps: aggregateValue?.toInt());
  }

  @override
  Future<ChangesToken> getChangesToken({
    required List<RecordType> recordTypes,
  }) async {
    return ChangesToken('token-1', recordTypes: recordTypes);
  }

  @override
  Future<Changes> getChanges(ChangesToken token) async {
    return Changes(
      upsertedRecords: recordsToReturn,
      deletedRecordIds: const [],
      nextChangesToken: ChangesToken('token-2', recordTypes: token.recordTypes),
      hasMore: false,
      changesTokenExpired: changesExpired,
    );
  }
}
