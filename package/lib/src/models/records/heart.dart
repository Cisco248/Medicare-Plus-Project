import 'package:flutter_health_connect/src/enums/export.dart';
import 'package:flutter_health_connect/src/models/export.dart';

/// [HeartRateRecord] A single heart-rate sample.
///
/// ### Params
///
/// * [time]: The time of the sample.
/// * [beatsPerMinute]: The beats per minute of the sample.
///
/// ### Returns
///
/// A [HeartRateSample] object.

class HeartRateSample {
  final DateTime time;
  final int beatsPerMinute;

  const HeartRateSample({required this.time, required this.beatsPerMinute});

  factory HeartRateSample.fromMap(Map<Object?, Object?> map) {
    return HeartRateSample(
      time: DateTime.fromMillisecondsSinceEpoch(
        map['timeMillis']! as int,
        isUtc: true,
      ),
      beatsPerMinute: (map['beatsPerMinute'] as num).toInt(),
    );
  }

  Map<String, Object?> toMap() => {
    'timeMillis': time.toUtc().millisecondsSinceEpoch,
    'beatsPerMinute': beatsPerMinute,
  };
}

/// Heart rate series over an interval.
/// [HeartRateRecord] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [id]: The ID of the record.
/// * [startTime]: The start time of the record.
/// * [endTime]: The end time of the record.
/// * [dataOrigin]: The data origin of the record.
/// * [startZoneOffsetSeconds]: The start zone offset seconds of the record.

class HeartRateRecord extends BaseRecord {
  const HeartRateRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.samples,
  });

  final List<HeartRateSample> samples;

  @override
  RecordType get recordType => RecordType.heartRate;

  factory HeartRateRecord.fromMap(Map<Object?, Object?> map) {
    final rawSamples = (map['samples'] as List<Object?>? ?? const [])
        .cast<Map<Object?, Object?>>();
    return HeartRateRecord(
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
      samples: rawSamples.map(HeartRateSample.fromMap).toList(growable: false),
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
    'samples': samples.map((s) => s.toMap()).toList(growable: false),
  };
}

/// Resting heart rate instantaneous measurement.
/// [RestingHeartRateRecord] is a subclass of [BaseRecord].
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
/// * [beatsPerMinute]: The beats per minute of the record.

class RestingHeartRateRecord extends BaseRecord {
  const RestingHeartRateRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.beatsPerMinute,
  });

  final int beatsPerMinute;

  @override
  RecordType get recordType => RecordType.restingHeartRate;

  factory RestingHeartRateRecord.fromMap(Map<Object?, Object?> map) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      map['startTimeMillis']! as int,
      isUtc: true,
    );
    return RestingHeartRateRecord(
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
      beatsPerMinute: (map['beatsPerMinute'] as num).toInt(),
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
    'beatsPerMinute': beatsPerMinute,
  };
}

/// Heart rate variability (RMSSD) instantaneous measurement, in milliseconds.
/// [HeartRateVariabilityRmssdRecord] is a subclass of [BaseRecord].
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
/// * [heartRateVariabilityMillis]: The heart rate variability in milliseconds.

class HeartRateVariabilityRmssdRecord extends BaseRecord {
  const HeartRateVariabilityRmssdRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.heartRateVariabilityMillis,
  });

  final double heartRateVariabilityMillis;

  @override
  RecordType get recordType => RecordType.heartRateVariabilityRmssd;

  factory HeartRateVariabilityRmssdRecord.fromMap(Map<Object?, Object?> map) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      map['startTimeMillis']! as int,
      isUtc: true,
    );
    return HeartRateVariabilityRmssdRecord(
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
      heartRateVariabilityMillis: (map['heartRateVariabilityMillis'] as num)
          .toDouble(),
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
    'heartRateVariabilityMillis': heartRateVariabilityMillis,
  };
}

/// Blood pressure instantaneous measurement.
/// [BloodPressureRecord] is a subclass of [BaseRecord].
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
/// * [systolicMmHg]: The systolic pressure in millimeters of mercury.
/// * [diastolicMmHg]: The diastolic pressure in millimeters of mercury.

class BloodPressureRecord extends BaseRecord {
  const BloodPressureRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.systolicMmHg,
    required this.diastolicMmHg,
  });

  final double systolicMmHg;
  final double diastolicMmHg;

  @override
  RecordType get recordType => RecordType.bloodPressure;

  factory BloodPressureRecord.fromMap(Map<Object?, Object?> map) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      map['startTimeMillis']! as int,
      isUtc: true,
    );
    return BloodPressureRecord(
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
      systolicMmHg: (map['systolicMmHg'] as num).toDouble(),
      diastolicMmHg: (map['diastolicMmHg'] as num).toDouble(),
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
    'systolicMmHg': systolicMmHg,
    'diastolicMmHg': diastolicMmHg,
  };
}

HealthDataOrigin? _origin(Map<Object?, Object?> map) {
  final raw = map['dataOrigin'];
  if (raw is Map<Object?, Object?>) {
    return HealthDataOrigin.fromMap(raw);
  }
  return null;
}
