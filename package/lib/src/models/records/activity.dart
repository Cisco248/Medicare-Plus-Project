import 'package:flutter_health_connect/src/models/export.dart';
import 'package:flutter_health_connect/src/enums/export.dart';

/// Steps counted over an interval.
/// Creates a steps record. [StepsRecord] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [id]: The ID of the record.
/// * [startTime]: The start time of the record.
/// * [endTime]: The end time of the record.
/// * [dataOrigin]: The data origin of the record.
/// * [startZoneOffsetSeconds]: The start zone offset seconds of the record.
/// * [endZoneOffsetSeconds]: The end zone offset seconds of the record.
/// * [clientRecordId]: The client record ID of the record.
/// * [count]: The number of steps in the interval.
///

class StepsRecord extends BaseRecord {
  const StepsRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.count,
  });

  final int count;

  @override
  RecordType get recordType => RecordType.steps;

  factory StepsRecord.fromMap(Map<Object?, Object?> map) {
    return StepsRecord(
      id: map['id'] as String? ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(
        map['startTimeMillis']! as int,
        isUtc: true,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        map['endTimeMillis']! as int,
        isUtc: true,
      ),
      dataOrigin: _origin(map),
      startZoneOffsetSeconds: map['startZoneOffsetSeconds'] as int?,
      endZoneOffsetSeconds: map['endZoneOffsetSeconds'] as int?,
      clientRecordId: map['clientRecordId'] as String?,
      count: (map['count'] as num).toInt(),
    );
  }

  @override
  Map<String, Object?> toMap() => {
    'recordType': recordType.name,
    'id': id,
    'startTimeMillis': startTime.toUtc().millisecondsSinceEpoch,
    'endTimeMillis': endTime.toUtc().millisecondsSinceEpoch,
    'dataOrigin': dataOrigin?.toMap(),
    'startZoneOffsetSeconds': startZoneOffsetSeconds,
    'endZoneOffsetSeconds': endZoneOffsetSeconds,
    'clientRecordId': clientRecordId,
    'count': count,
  };
}

/// Distance traveled over an interval, in meters.
/// [DistanceRecord] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [id]: The ID of the record.
/// * [startTime]: The start time of the record.
/// * [endTime]: The end time of the record.
/// * [dataOrigin]: The data origin of the record.
/// * [startZoneOffsetSeconds]: The start zone offset seconds of the record.
class DistanceRecord extends BaseRecord {
  const DistanceRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.distanceMeters,
  });

  final double distanceMeters;

  @override
  RecordType get recordType => RecordType.distance;

  factory DistanceRecord.fromMap(Map<Object?, Object?> map) {
    return DistanceRecord(
      id: map['id'] as String? ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(
        map['startTimeMillis']! as int,
        isUtc: true,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        map['endTimeMillis']! as int,
        isUtc: true,
      ),
      dataOrigin: _origin(map),
      startZoneOffsetSeconds: map['startZoneOffsetSeconds'] as int?,
      endZoneOffsetSeconds: map['endZoneOffsetSeconds'] as int?,
      clientRecordId: map['clientRecordId'] as String?,
      distanceMeters: (map['distanceMeters'] as num).toDouble(),
    );
  }

  @override
  Map<String, Object?> toMap() => {
    'recordType': recordType.name,
    'id': id,
    'startTimeMillis': startTime.toUtc().millisecondsSinceEpoch,
    'endTimeMillis': endTime.toUtc().millisecondsSinceEpoch,
    'dataOrigin': dataOrigin?.toMap(),
    'startZoneOffsetSeconds': startZoneOffsetSeconds,
    'endZoneOffsetSeconds': endZoneOffsetSeconds,
    'clientRecordId': clientRecordId,
    'distanceMeters': distanceMeters,
  };
}

/// Active calories burned over an interval, in kilocalories.
/// [ActiveCaloriesBurnedRecord] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [id]: The ID of the record.
/// * [startTime]: The start time of the record.
/// * [endTime]: The end time of the record.
/// * [dataOrigin]: The data origin of the record.
/// * [startZoneOffsetSeconds]: The start zone offset seconds of the record.
/// * [endZoneOffsetSeconds]: The end zone offset seconds of the record.
/// * [clientRecordId]: The client record ID of the record.
/// * [energyKilocalories]: The energy in kilocalories.

class ActiveCaloriesBurnedRecord extends BaseRecord {
  const ActiveCaloriesBurnedRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.energyKilocalories,
  });

  /// Energy in kilocalories.
  final double energyKilocalories;

  @override
  RecordType get recordType => RecordType.activeCaloriesBurned;

  /// Creates from a platform map.
  factory ActiveCaloriesBurnedRecord.fromMap(Map<Object?, Object?> map) {
    return ActiveCaloriesBurnedRecord(
      id: map['id'] as String? ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(
        map['startTimeMillis']! as int,
        isUtc: true,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        map['endTimeMillis']! as int,
        isUtc: true,
      ),
      dataOrigin: _origin(map),
      startZoneOffsetSeconds: map['startZoneOffsetSeconds'] as int?,
      endZoneOffsetSeconds: map['endZoneOffsetSeconds'] as int?,
      clientRecordId: map['clientRecordId'] as String?,
      energyKilocalories: (map['energyKilocalories'] as num).toDouble(),
    );
  }

  @override
  Map<String, Object?> toMap() => {
    'recordType': recordType.name,
    'id': id,
    'startTimeMillis': startTime.toUtc().millisecondsSinceEpoch,
    'endTimeMillis': endTime.toUtc().millisecondsSinceEpoch,
    'dataOrigin': dataOrigin?.toMap(),
    'startZoneOffsetSeconds': startZoneOffsetSeconds,
    'endZoneOffsetSeconds': endZoneOffsetSeconds,
    'clientRecordId': clientRecordId,
    'energyKilocalories': energyKilocalories,
  };
}

/// Total calories burned over an interval, in kilocalories.
/// [TotalCaloriesBurnedRecord] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [id]: The ID of the record.
/// * [startTime]: The start time of the record.
/// * [endTime]: The end time of the record.
/// * [dataOrigin]: The data origin of the record.
/// * [startZoneOffsetSeconds]: The start zone offset seconds of the record.
/// * [endZoneOffsetSeconds]: The end zone offset seconds of the record.
/// * [clientRecordId]: The client record ID of the record.
/// * [energyKilocalories]: The energy in kilocalories.

class TotalCaloriesBurnedRecord extends BaseRecord {
  const TotalCaloriesBurnedRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.energyKilocalories,
  });

  /// Energy in kilocalories.
  final double energyKilocalories;

  @override
  RecordType get recordType => RecordType.totalCaloriesBurned;

  /// Creates from a platform map.
  factory TotalCaloriesBurnedRecord.fromMap(Map<Object?, Object?> map) {
    return TotalCaloriesBurnedRecord(
      id: map['id'] as String? ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(
        map['startTimeMillis']! as int,
        isUtc: true,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        map['endTimeMillis']! as int,
        isUtc: true,
      ),
      dataOrigin: _origin(map),
      startZoneOffsetSeconds: map['startZoneOffsetSeconds'] as int?,
      endZoneOffsetSeconds: map['endZoneOffsetSeconds'] as int?,
      clientRecordId: map['clientRecordId'] as String?,
      energyKilocalories: (map['energyKilocalories'] as num).toDouble(),
    );
  }

  @override
  Map<String, Object?> toMap() => {
    'recordType': recordType.name,
    'id': id,
    'startTimeMillis': startTime.toUtc().millisecondsSinceEpoch,
    'endTimeMillis': endTime.toUtc().millisecondsSinceEpoch,
    'dataOrigin': dataOrigin?.toMap(),
    'startZoneOffsetSeconds': startZoneOffsetSeconds,
    'endZoneOffsetSeconds': endZoneOffsetSeconds,
    'clientRecordId': clientRecordId,
    'energyKilocalories': energyKilocalories,
  };
}

/// Floors climbed over an interval.
/// [FloorsClimbedRecord] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [id]: The ID of the record.
/// * [startTime]: The start time of the record.
/// * [endTime]: The end time of the record.
/// * [dataOrigin]: The data origin of the record.
/// * [startZoneOffsetSeconds]: The start zone offset seconds of the record.
/// * [endZoneOffsetSeconds]: The end zone offset seconds of the record.
/// * [clientRecordId]: The client record ID of the record.
/// * [floors]: The number of floors climbed.

class FloorsClimbedRecord extends BaseRecord {
  const FloorsClimbedRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.floors,
  });

  final double floors;

  @override
  RecordType get recordType => RecordType.floorsClimbed;

  factory FloorsClimbedRecord.fromMap(Map<Object?, Object?> map) {
    return FloorsClimbedRecord(
      id: map['id'] as String? ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(
        map['startTimeMillis']! as int,
        isUtc: true,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        map['endTimeMillis']! as int,
        isUtc: true,
      ),
      dataOrigin: _origin(map),
      startZoneOffsetSeconds: map['startZoneOffsetSeconds'] as int?,
      endZoneOffsetSeconds: map['endZoneOffsetSeconds'] as int?,
      clientRecordId: map['clientRecordId'] as String?,
      floors: (map['floors'] as num).toDouble(),
    );
  }

  @override
  Map<String, Object?> toMap() => {
    'recordType': recordType.name,
    'id': id,
    'startTimeMillis': startTime.toUtc().millisecondsSinceEpoch,
    'endTimeMillis': endTime.toUtc().millisecondsSinceEpoch,
    'dataOrigin': dataOrigin?.toMap(),
    'startZoneOffsetSeconds': startZoneOffsetSeconds,
    'endZoneOffsetSeconds': endZoneOffsetSeconds,
    'clientRecordId': clientRecordId,
    'floors': floors,
  };
}

/// An exercise / workout session.
/// [ExerciseSessionRecord] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [id]: The ID of the record.
/// * [startTime]: The start time of the record.
/// * [endTime]: The end time of the record.
/// * [dataOrigin]: The data origin of the record.
/// * [startZoneOffsetSeconds]: The start zone offset seconds of the record.
/// * [endZoneOffsetSeconds]: The end zone offset seconds of the record.
/// * [clientRecordId]: The client record ID of the record.
/// * [exerciseType]: The exercise type.
/// * [title]: The title of the session.
/// * [notes]: The notes of the session.

class ExerciseSessionRecord extends BaseRecord {
  const ExerciseSessionRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.exerciseType,
    this.title,
    this.notes,
  });

  final String exerciseType;
  final String? title;
  final String? notes;

  @override
  RecordType get recordType => RecordType.exerciseSession;

  factory ExerciseSessionRecord.fromMap(Map<Object?, Object?> map) {
    return ExerciseSessionRecord(
      id: map['id'] as String? ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(
        map['startTimeMillis']! as int,
        isUtc: true,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        map['endTimeMillis']! as int,
        isUtc: true,
      ),
      dataOrigin: _origin(map),
      startZoneOffsetSeconds: map['startZoneOffsetSeconds'] as int?,
      endZoneOffsetSeconds: map['endZoneOffsetSeconds'] as int?,
      clientRecordId: map['clientRecordId'] as String?,
      exerciseType: map['exerciseType'] as String? ?? 'OTHER_WORKOUT',
      title: map['title'] as String?,
      notes: map['notes'] as String?,
    );
  }

  @override
  Map<String, Object?> toMap() => {
    'recordType': recordType.name,
    'id': id,
    'startTimeMillis': startTime.toUtc().millisecondsSinceEpoch,
    'endTimeMillis': endTime.toUtc().millisecondsSinceEpoch,
    'dataOrigin': dataOrigin?.toMap(),
    'startZoneOffsetSeconds': startZoneOffsetSeconds,
    'endZoneOffsetSeconds': endZoneOffsetSeconds,
    'clientRecordId': clientRecordId,
    'exerciseType': exerciseType,
    'title': title,
    'notes': notes,
  };
}

HealthDataOrigin? _origin(Map<Object?, Object?> map) {
  final raw = map['dataOrigin'];
  if (raw is Map<Object?, Object?>) {
    return HealthDataOrigin.fromMap(raw);
  }
  return null;
}
