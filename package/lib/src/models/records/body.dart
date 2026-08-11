import 'package:flutter_health_connect/src/enums/export.dart';
import 'package:flutter_health_connect/src/models/export.dart';

/// Body weight instantaneous measurement in kilograms.
/// [WeightRecord] is a subclass of [BaseRecord].
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
/// * [weightKilograms]: The weight in kilograms.

class WeightRecord extends BaseRecord {
  const WeightRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.weightKilograms,
  });

  final double weightKilograms;

  @override
  RecordType get recordType => RecordType.weight;

  factory WeightRecord.fromMap(Map<Object?, Object?> map) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      map['startTimeMillis']! as int,
      isUtc: true,
    );
    return WeightRecord(
      id: map['id'] as String? ?? '',
      startTime: time,
      endTime: DateTime.fromMillisecondsSinceEpoch(
        (map['endTimeMillis'] as int?) ?? time.millisecondsSinceEpoch,
        isUtc: true,
      ),
      dataOrigin: _origin(map),
      startZoneOffsetSeconds: map['startZoneOffsetSeconds'] as int?,
      endZoneOffsetSeconds: map['endZoneOffsetSeconds'] as int?,
      clientRecordId: map['clientRecordId'] as String?,
      weightKilograms: (map['weightKilograms'] as num).toDouble(),
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
    'weightKilograms': weightKilograms,
  };
}

/// Body height instantaneous measurement in meters.
/// [HeightRecord] is a subclass of [BaseRecord].
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
/// * [heightMeters]: The height in meters.

class HeightRecord extends BaseRecord {
  const HeightRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.heightMeters,
  });

  final double heightMeters;

  @override
  RecordType get recordType => RecordType.height;

  factory HeightRecord.fromMap(Map<Object?, Object?> map) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      map['startTimeMillis']! as int,
      isUtc: true,
    );
    return HeightRecord(
      id: map['id'] as String? ?? '',
      startTime: time,
      endTime: DateTime.fromMillisecondsSinceEpoch(
        (map['endTimeMillis'] as int?) ?? time.millisecondsSinceEpoch,
        isUtc: true,
      ),
      dataOrigin: _origin(map),
      startZoneOffsetSeconds: map['startZoneOffsetSeconds'] as int?,
      endZoneOffsetSeconds: map['endZoneOffsetSeconds'] as int?,
      clientRecordId: map['clientRecordId'] as String?,
      heightMeters: (map['heightMeters'] as num).toDouble(),
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
    'heightMeters': heightMeters,
  };
}

/// Body fat percentage instantaneous measurement (0–100).
/// [BodyFatRecord] is a subclass of [BaseRecord].
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
/// * [percentage]: The body fat percentage.

class BodyFatRecord extends BaseRecord {
  const BodyFatRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.percentage,
  });

  final double percentage;

  @override
  RecordType get recordType => RecordType.bodyFat;

  factory BodyFatRecord.fromMap(Map<Object?, Object?> map) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      map['startTimeMillis']! as int,
      isUtc: true,
    );
    return BodyFatRecord(
      id: map['id'] as String? ?? '',
      startTime: time,
      endTime: DateTime.fromMillisecondsSinceEpoch(
        (map['endTimeMillis'] as int?) ?? time.millisecondsSinceEpoch,
        isUtc: true,
      ),
      dataOrigin: _origin(map),
      startZoneOffsetSeconds: map['startZoneOffsetSeconds'] as int?,
      endZoneOffsetSeconds: map['endZoneOffsetSeconds'] as int?,
      clientRecordId: map['clientRecordId'] as String?,
      percentage: (map['percentage'] as num).toDouble(),
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
    'percentage': percentage,
  };
}

HealthDataOrigin? _origin(Map<Object?, Object?> map) {
  final raw = map['dataOrigin'];
  if (raw is Map<Object?, Object?>) {
    return HealthDataOrigin.fromMap(raw);
  }
  return null;
}
