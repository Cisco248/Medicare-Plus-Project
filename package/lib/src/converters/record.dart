import '../enums/record_type.dart';
import '../exceptions/exception.dart';
import '../models/records/_base.dart';
import '../models/records/activity.dart';
import '../models/records/body.dart';
import '../models/records/heart.dart';
import '../models/records/other.dart';
import '../models/records/sleep.dart';

/// Converts between platform maps and strongly typed [HealthRecord]s.
///
/// Deserializes a platform map into a typed record.
///
/// - [map] - The platform map to deserialize.
///
/// - Returns a [HealthRecord] if the map is valid.
/// - Throws [HealthConnectUnsupportedRecordException] for unknown types.

class RecordConverter {
  const RecordConverter._();

  static BaseRecord fromMap(Map<Object?, Object?> map) {
    final typeName = map['recordType'] as String?;
    if (typeName == null) {
      throw const HealthConnectUnsupportedRecordException(
        'Missing recordType in platform payload.',
        code: 'missing_record_type',
      );
    }

    final type = RecordType.values.byName(typeName);
    switch (type) {
      case RecordType.steps:
        return StepsRecord.fromMap(map);
      case RecordType.distance:
        return DistanceRecord.fromMap(map);
      case RecordType.activeCaloriesBurned:
        return ActiveCaloriesBurnedRecord.fromMap(map);
      case RecordType.totalCaloriesBurned:
        return TotalCaloriesBurnedRecord.fromMap(map);
      case RecordType.floorsClimbed:
        return FloorsClimbedRecord.fromMap(map);
      case RecordType.exerciseSession:
        return ExerciseSessionRecord.fromMap(map);
      case RecordType.heartRate:
        return HeartRateRecord.fromMap(map);
      case RecordType.restingHeartRate:
        return RestingHeartRateRecord.fromMap(map);
      case RecordType.heartRateVariabilityRmssd:
        return HeartRateVariabilityRmssdRecord.fromMap(map);
      case RecordType.bloodPressure:
        return BloodPressureRecord.fromMap(map);
      case RecordType.weight:
        return WeightRecord.fromMap(map);
      case RecordType.height:
        return HeightRecord.fromMap(map);
      case RecordType.bodyFat:
        return BodyFatRecord.fromMap(map);
      case RecordType.sleepSession:
        return SleepSessionRecord.fromMap(map);
      case RecordType.oxygenSaturation:
        return OxygenSaturationRecord.fromMap(map);
      case RecordType.bodyTemperature:
        return BodyTemperatureRecord.fromMap(map);
      case RecordType.nutrition:
        return NutritionRecord.fromMap(map);
      case RecordType.bloodGlucose:
        return BloodGlucoseRecord.fromMap(map);
    }
  }

  static List<T> castAll<T extends BaseRecord>(List<BaseRecord> records) {
    return records
        .map((r) {
          if (r is T) return r;
          throw HealthConnectRecordException(
            'Expected $T but received ${r.runtimeType}.',
            code: 'record_type_mismatch',
          );
        })
        .toList(growable: false);
  }
}
