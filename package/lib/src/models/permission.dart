import 'package:flutter_health_connect/src/enums/export.dart';

/// A typed Health Connect read or write permission for a record type.
///
/// Prefer the static helpers, for example:
/// ```dart
/// HealthPermission.steps.read
/// HealthPermission.heartRate.write
/// ```
/// [HealthPermission] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [recordType]: The record type this permission applies to.
/// * [access]: Whether this is a read or write permission.

class Permission {
  const Permission({required this.recordType, required this.access});

  final RecordType recordType;
  final AccessType access;

  static const PermissionGroup steps = PermissionGroup(RecordType.steps);

  static const PermissionGroup distance = PermissionGroup(RecordType.distance);

  static const PermissionGroup activeCaloriesBurned = PermissionGroup(
    RecordType.activeCaloriesBurned,
  );

  static const PermissionGroup totalCaloriesBurned = PermissionGroup(
    RecordType.totalCaloriesBurned,
  );

  static const PermissionGroup floorsClimbed = PermissionGroup(
    RecordType.floorsClimbed,
  );

  static const PermissionGroup exerciseSession = PermissionGroup(
    RecordType.exerciseSession,
  );

  static const PermissionGroup heartRate = PermissionGroup(
    RecordType.heartRate,
  );

  static const PermissionGroup restingHeartRate = PermissionGroup(
    RecordType.restingHeartRate,
  );

  static const PermissionGroup heartRateVariabilityRmssd = PermissionGroup(
    RecordType.heartRateVariabilityRmssd,
  );

  static const PermissionGroup bloodPressure = PermissionGroup(
    RecordType.bloodPressure,
  );

  static const PermissionGroup weight = PermissionGroup(RecordType.weight);

  static const PermissionGroup height = PermissionGroup(RecordType.height);

  static const PermissionGroup bodyFat = PermissionGroup(RecordType.bodyFat);

  static const PermissionGroup sleepSession = PermissionGroup(
    RecordType.sleepSession,
  );

  static const PermissionGroup oxygenSaturation = PermissionGroup(
    RecordType.oxygenSaturation,
  );

  static const PermissionGroup bodyTemperature = PermissionGroup(
    RecordType.bodyTemperature,
  );

  static const PermissionGroup nutrition = PermissionGroup(
    RecordType.nutrition,
  );

  static const PermissionGroup bloodGlucose = PermissionGroup(
    RecordType.bloodGlucose,
  );

  Map<String, Object?> toMap() => {
    'recordType': recordType.name,
    'access': access.name,
  };

  factory Permission.fromMap(Map<Object?, Object?> map) {
    return Permission(
      recordType: RecordType.values.byName(map['recordType']! as String),
      access: AccessType.values.byName(map['access']! as String),
    );
  }

  @override
  String toString() => 'Permission(${recordType.name}.${access.name})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Permission &&
          recordType == other.recordType &&
          access == other.access;

  @override
  int get hashCode => Object.hash(recordType, access);
}

/// Helper that exposes `.read` / `.write` for a [RecordType].
/// [HealthPermissionGroup] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [recordType]: The record type for this group.

class PermissionGroup {
  const PermissionGroup(this.recordType);

  final RecordType recordType;

  Permission get read =>
      Permission(recordType: recordType, access: AccessType.read);

  Permission get write =>
      Permission(recordType: recordType, access: AccessType.write);
}

/// Result of checking a set of Health Connect permissions.
/// [PermissionStatus] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [requested]: The permissions that were requested.
/// * [granted]: The permissions that were granted.

class PermissionStatus {
  const PermissionStatus({required this.requested, required this.granted});

  final List<Permission> requested;
  final List<Permission> granted;

  bool get allGranted =>
      requested.isNotEmpty && granted.length == requested.length;

  List<Permission> get denied =>
      requested.where((p) => !granted.contains(p)).toList(growable: false);
}
