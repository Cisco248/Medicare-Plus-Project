import 'package:flutter_health_connect/src/enums/export.dart';
import 'package:flutter_health_connect/src/models/export.dart';

/// A sleep stage nested inside a [SleepSessionRecord].
/// [SleepStage] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [startTime]: The start time of the stage.
/// * [endTime]: The end time of the stage.
/// * [stage]: The stage name.

class SleepStage {
  const SleepStage({
    required this.startTime,
    required this.endTime,
    required this.stage,
  });

  final DateTime startTime;
  final DateTime endTime;
  final String stage;

  factory SleepStage.fromMap(Map<Object?, Object?> map) {
    return SleepStage(
      startTime: DateTime.fromMillisecondsSinceEpoch(
        map['startTimeMillis']! as int,
        isUtc: true,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        map['endTimeMillis']! as int,
        isUtc: true,
      ),
      stage: map['stage'] as String? ?? 'UNKNOWN',
    );
  }

  Map<String, Object?> toMap() => {
    'startTimeMillis': startTime.toUtc().millisecondsSinceEpoch,
    'endTimeMillis': endTime.toUtc().millisecondsSinceEpoch,
    'stage': stage,
  };
}

/// A sleep session, optionally containing stages.
/// [SleepSessionRecord] is a subclass of [BaseRecord].
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
/// * [title]: The title of the record.
/// * [notes]: The notes of the record.
/// * [stages]: The stages of the record.

class SleepSessionRecord extends BaseRecord {
  const SleepSessionRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    this.title,
    this.notes,
    this.stages = const [],
  });

  final String? title;
  final String? notes;
  final List<SleepStage> stages;

  Duration get duration => endTime.difference(startTime);

  @override
  RecordType get recordType => RecordType.sleepSession;

  factory SleepSessionRecord.fromMap(Map<Object?, Object?> map) {
    final rawStages = (map['stages'] as List<Object?>? ?? const [])
        .cast<Map<Object?, Object?>>();
    return SleepSessionRecord(
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
      title: map['title'] as String?,
      notes: map['notes'] as String?,
      stages: rawStages.map(SleepStage.fromMap).toList(growable: false),
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
    'title': title,
    'notes': notes,
    'stages': stages.map((s) => s.toMap()).toList(growable: false),
  };
}

HealthDataOrigin? _origin(Map<Object?, Object?> map) {
  final raw = map['dataOrigin'];
  if (raw is Map<Object?, Object?>) {
    return HealthDataOrigin.fromMap(raw);
  }
  return null;
}
