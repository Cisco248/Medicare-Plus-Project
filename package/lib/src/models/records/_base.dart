import 'package:flutter_health_connect/src/models/export.dart';
import 'package:flutter_health_connect/src/enums/export.dart';

/// [BaseRecord] Base class for all strongly typed Health Connect records.
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
/// * [recordType]: The type of the record.
/// * [toMap]: Serializes to a platform map.

abstract class BaseRecord {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final HealthDataOrigin? dataOrigin;
  final int? startZoneOffsetSeconds;
  final int? endZoneOffsetSeconds;
  final String? clientRecordId;
  RecordType get recordType;
  Map<String, Object?> toMap();

  const BaseRecord({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.dataOrigin,
    this.startZoneOffsetSeconds,
    this.endZoneOffsetSeconds,
    this.clientRecordId,
  });
}
