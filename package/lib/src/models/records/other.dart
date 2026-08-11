import 'package:flutter_health_connect/src/enums/export.dart';
import 'package:flutter_health_connect/src/models/export.dart';

/// Oxygen saturation instantaneous measurement (percentage 0–100).
/// [OxygenSaturationRecord] is a subclass of [BaseRecord].
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
/// * [percentage]: The oxygen saturation percentage.

class OxygenSaturationRecord extends BaseRecord {
  const OxygenSaturationRecord({
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
  RecordType get recordType => RecordType.oxygenSaturation;

  factory OxygenSaturationRecord.fromMap(Map<Object?, Object?> map) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      map['startTimeMillis']! as int,
      isUtc: true,
    );
    return OxygenSaturationRecord(
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

/// Body temperature instantaneous measurement in Celsius.
/// [BodyTemperatureRecord] is a subclass of [BaseRecord].
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
/// * [temperatureCelsius]: The temperature in Celsius.
/// * [measurementLocation]: The measurement location.

class BodyTemperatureRecord extends BaseRecord {
  const BodyTemperatureRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.temperatureCelsius,
    this.measurementLocation,
  });

  final double temperatureCelsius;
  final String? measurementLocation;

  @override
  RecordType get recordType => RecordType.bodyTemperature;

  factory BodyTemperatureRecord.fromMap(Map<Object?, Object?> map) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      map['startTimeMillis']! as int,
      isUtc: true,
    );
    return BodyTemperatureRecord(
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
      temperatureCelsius: (map['temperatureCelsius'] as num).toDouble(),
      measurementLocation: map['measurementLocation'] as String?,
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
    'temperatureCelsius': temperatureCelsius,
    'measurementLocation': measurementLocation,
  };
}

/// Nutrition nutrients consumed over an interval.
///
/// Only fields present in Health Connect's [NutritionRecord] are exposed.
/// [NutritionRecord] is a subclass of [BaseRecord].
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
/// * [name]: The name of the record.
/// * [energyKilocalories]: The energy in kilocalories.
/// * [proteinGrams]: The protein in grams.
/// * [totalCarbohydrateGrams]: The total carbohydrate in grams.
/// * [totalFatGrams]: The total fat in grams.
/// * [sugarGrams]: The sugar in grams.
/// * [dietaryFiberGrams]: The dietary fiber in grams.
/// * [sodiumMilligrams]: The sodium in milligrams.

class NutritionRecord extends BaseRecord {
  const NutritionRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    this.name,
    this.energyKilocalories,
    this.proteinGrams,
    this.totalCarbohydrateGrams,
    this.totalFatGrams,
    this.sugarGrams,
    this.dietaryFiberGrams,
    this.sodiumMilligrams,
  });

  final String? name;
  final double? energyKilocalories;
  final double? proteinGrams;
  final double? totalCarbohydrateGrams;
  final double? totalFatGrams;
  final double? sugarGrams;
  final double? dietaryFiberGrams;
  final double? sodiumMilligrams;

  @override
  RecordType get recordType => RecordType.nutrition;

  factory NutritionRecord.fromMap(Map<Object?, Object?> map) {
    return NutritionRecord(
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
      name: map['name'] as String?,
      energyKilocalories: (map['energyKilocalories'] as num?)?.toDouble(),
      proteinGrams: (map['proteinGrams'] as num?)?.toDouble(),
      totalCarbohydrateGrams: (map['totalCarbohydrateGrams'] as num?)
          ?.toDouble(),
      totalFatGrams: (map['totalFatGrams'] as num?)?.toDouble(),
      sugarGrams: (map['sugarGrams'] as num?)?.toDouble(),
      dietaryFiberGrams: (map['dietaryFiberGrams'] as num?)?.toDouble(),
      sodiumMilligrams: (map['sodiumMilligrams'] as num?)?.toDouble(),
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
    'name': name,
    'energyKilocalories': energyKilocalories,
    'proteinGrams': proteinGrams,
    'totalCarbohydrateGrams': totalCarbohydrateGrams,
    'totalFatGrams': totalFatGrams,
    'sugarGrams': sugarGrams,
    'dietaryFiberGrams': dietaryFiberGrams,
    'sodiumMilligrams': sodiumMilligrams,
  };
}

/// Blood glucose instantaneous measurement in millimoles per liter.
/// [BloodGlucoseRecord] is a subclass of [BaseRecord].
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
/// * [levelMillimolesPerLiter]: The blood glucose level in millimoles per liter.
/// * [specimenSource]: The specimen source.
/// * [mealType]: The meal type.
/// * [relationToMeal]: The relation to meal.

class BloodGlucoseRecord extends BaseRecord {
  const BloodGlucoseRecord({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.dataOrigin,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.clientRecordId,
    required this.levelMillimolesPerLiter,
    this.specimenSource,
    this.mealType,
    this.relationToMeal,
  });

  final double levelMillimolesPerLiter;
  final String? specimenSource;
  final String? mealType;
  final String? relationToMeal;

  @override
  RecordType get recordType => RecordType.bloodGlucose;

  factory BloodGlucoseRecord.fromMap(Map<Object?, Object?> map) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      map['startTimeMillis']! as int,
      isUtc: true,
    );
    return BloodGlucoseRecord(
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
      levelMillimolesPerLiter: (map['levelMillimolesPerLiter'] as num)
          .toDouble(),
      specimenSource: map['specimenSource'] as String?,
      mealType: map['mealType'] as String?,
      relationToMeal: map['relationToMeal'] as String?,
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
    'levelMillimolesPerLiter': levelMillimolesPerLiter,
    'specimenSource': specimenSource,
    'mealType': mealType,
    'relationToMeal': relationToMeal,
  };
}

HealthDataOrigin? _origin(Map<Object?, Object?> map) {
  final raw = map['dataOrigin'];
  if (raw is Map<Object?, Object?>) {
    return HealthDataOrigin.fromMap(raw);
  }
  return null;
}
