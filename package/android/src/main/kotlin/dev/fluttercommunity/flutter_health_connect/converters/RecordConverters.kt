package dev.fluttercommunity.flutter_health_connect.converters

import androidx.health.connect.client.records.ActiveCaloriesBurnedRecord
import androidx.health.connect.client.records.BloodGlucoseRecord
import androidx.health.connect.client.records.BloodPressureRecord
import androidx.health.connect.client.records.BodyFatRecord
import androidx.health.connect.client.records.BodyTemperatureRecord
import androidx.health.connect.client.records.DistanceRecord
import androidx.health.connect.client.records.ExerciseSessionRecord
import androidx.health.connect.client.records.FloorsClimbedRecord
import androidx.health.connect.client.records.HeartRateRecord
import androidx.health.connect.client.records.HeartRateVariabilityRmssdRecord
import androidx.health.connect.client.records.HeightRecord
import androidx.health.connect.client.records.NutritionRecord
import androidx.health.connect.client.records.OxygenSaturationRecord
import androidx.health.connect.client.records.Record
import androidx.health.connect.client.records.RestingHeartRateRecord
import androidx.health.connect.client.records.SleepSessionRecord
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.records.TotalCaloriesBurnedRecord
import androidx.health.connect.client.records.WeightRecord
import androidx.health.connect.client.records.metadata.Device
import androidx.health.connect.client.records.metadata.Metadata
import androidx.health.connect.client.units.BloodGlucose
import androidx.health.connect.client.units.Energy
import androidx.health.connect.client.units.Length
import androidx.health.connect.client.units.Mass
import androidx.health.connect.client.units.Percentage
import androidx.health.connect.client.units.Pressure
import androidx.health.connect.client.units.Temperature
import java.time.Instant

internal object RecordConverters {
    fun toMap(record: Record): Map<String, Any?> {
        val base = linkedMapOf<String, Any?>(
            "recordType" to RecordTypeMapper.typeName(record),
            "id" to record.metadata.id,
            "clientRecordId" to record.metadata.clientRecordId,
            "dataOrigin" to mapOf(
                "packageName" to record.metadata.dataOrigin.packageName,
                "applicationName" to null,
            ),
        )

        return when (record) {
            is StepsRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.startTime),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.endTime),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.startZoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.endZoneOffset),
                "count" to record.count,
            )
            is DistanceRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.startTime),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.endTime),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.startZoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.endZoneOffset),
                "distanceMeters" to record.distance.inMeters,
            )
            is ActiveCaloriesBurnedRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.startTime),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.endTime),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.startZoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.endZoneOffset),
                "energyKilocalories" to record.energy.inKilocalories,
            )
            is TotalCaloriesBurnedRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.startTime),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.endTime),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.startZoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.endZoneOffset),
                "energyKilocalories" to record.energy.inKilocalories,
            )
            is FloorsClimbedRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.startTime),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.endTime),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.startZoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.endZoneOffset),
                "floors" to record.floors,
            )
            is ExerciseSessionRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.startTime),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.endTime),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.startZoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.endZoneOffset),
                "exerciseType" to exerciseTypeName(record.exerciseType),
                "title" to record.title,
                "notes" to record.notes,
            )
            is HeartRateRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.startTime),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.endTime),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.startZoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.endZoneOffset),
                "samples" to record.samples.map {
                    mapOf(
                        "timeMillis" to TimeConverters.toEpochMillis(it.time),
                        "beatsPerMinute" to it.beatsPerMinute,
                    )
                },
            )
            is RestingHeartRateRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "beatsPerMinute" to record.beatsPerMinute,
            )
            is HeartRateVariabilityRmssdRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "heartRateVariabilityMillis" to record.heartRateVariabilityMillis,
            )
            is BloodPressureRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "systolicMmHg" to record.systolic.inMillimetersOfMercury,
                "diastolicMmHg" to record.diastolic.inMillimetersOfMercury,
            )
            is WeightRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "weightKilograms" to record.weight.inKilograms,
            )
            is HeightRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "heightMeters" to record.height.inMeters,
            )
            is BodyFatRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "percentage" to record.percentage.value,
            )
            is SleepSessionRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.startTime),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.endTime),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.startZoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.endZoneOffset),
                "title" to record.title,
                "notes" to record.notes,
                "stages" to record.stages.map {
                    mapOf(
                        "startTimeMillis" to TimeConverters.toEpochMillis(it.startTime),
                        "endTimeMillis" to TimeConverters.toEpochMillis(it.endTime),
                        "stage" to sleepStageName(it.stage),
                    )
                },
            )
            is OxygenSaturationRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "percentage" to record.percentage.value,
            )
            is BodyTemperatureRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "temperatureCelsius" to record.temperature.inCelsius,
                "measurementLocation" to null,
            )
            is NutritionRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.startTime),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.endTime),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.startZoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.endZoneOffset),
                "name" to record.name,
                "energyKilocalories" to record.energy?.inKilocalories,
                "proteinGrams" to record.protein?.inGrams,
                "totalCarbohydrateGrams" to record.totalCarbohydrate?.inGrams,
                "totalFatGrams" to record.totalFat?.inGrams,
                "sugarGrams" to record.sugar?.inGrams,
                "dietaryFiberGrams" to record.dietaryFiber?.inGrams,
                "sodiumMilligrams" to record.sodium?.inMilligrams,
            )
            is BloodGlucoseRecord -> base + mapOf(
                "startTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "endTimeMillis" to TimeConverters.toEpochMillis(record.time),
                "startZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "endZoneOffsetSeconds" to TimeConverters.zoneOffsetSeconds(record.zoneOffset),
                "levelMillimolesPerLiter" to record.level.inMillimolesPerLiter,
                "specimenSource" to null,
                "mealType" to null,
                "relationToMeal" to null,
            )
            else -> throw IllegalArgumentException("Unsupported record: ${record::class.java.simpleName}")
        }
    }

    @Suppress("UNCHECKED_CAST")
    fun fromMap(map: Map<String, Any?>): Record {
        val type = map["recordType"] as String
        val start = TimeConverters.toInstant((map["startTimeMillis"] as Number).toLong())
        val end = TimeConverters.toInstant((map["endTimeMillis"] as Number).toLong())
        val startOffset = TimeConverters.zoneOffsetFromSeconds(
            (map["startZoneOffsetSeconds"] as Number?)?.toInt(),
        ) ?: TimeConverters.systemZoneOffset(start)
        val endOffset = TimeConverters.zoneOffsetFromSeconds(
            (map["endZoneOffsetSeconds"] as Number?)?.toInt(),
        ) ?: TimeConverters.systemZoneOffset(end)
        val clientRecordId = map["clientRecordId"] as String?
        val metadata =
            if (clientRecordId.isNullOrEmpty()) {
                Metadata.manualEntry(device = Device(type = Device.TYPE_PHONE))
            } else {
                Metadata.manualEntry(
                    device = Device(type = Device.TYPE_PHONE),
                    clientRecordId = clientRecordId,
                )
            }

        return when (type) {
            "steps" -> StepsRecord(
                startTime = start,
                startZoneOffset = startOffset,
                endTime = end,
                endZoneOffset = endOffset,
                count = (map["count"] as Number).toLong(),
                metadata = metadata,
            )
            "distance" -> DistanceRecord(
                startTime = start,
                startZoneOffset = startOffset,
                endTime = end,
                endZoneOffset = endOffset,
                distance = Length.meters((map["distanceMeters"] as Number).toDouble()),
                metadata = metadata,
            )
            "activeCaloriesBurned" -> ActiveCaloriesBurnedRecord(
                startTime = start,
                startZoneOffset = startOffset,
                endTime = end,
                endZoneOffset = endOffset,
                energy = Energy.kilocalories((map["energyKilocalories"] as Number).toDouble()),
                metadata = metadata,
            )
            "totalCaloriesBurned" -> TotalCaloriesBurnedRecord(
                startTime = start,
                startZoneOffset = startOffset,
                endTime = end,
                endZoneOffset = endOffset,
                energy = Energy.kilocalories((map["energyKilocalories"] as Number).toDouble()),
                metadata = metadata,
            )
            "floorsClimbed" -> FloorsClimbedRecord(
                startTime = start,
                startZoneOffset = startOffset,
                endTime = end,
                endZoneOffset = endOffset,
                floors = (map["floors"] as Number).toDouble(),
                metadata = metadata,
            )
            "exerciseSession" -> ExerciseSessionRecord(
                startTime = start,
                startZoneOffset = startOffset,
                endTime = end,
                endZoneOffset = endOffset,
                exerciseType = exerciseTypeValue(map["exerciseType"] as String? ?: "OTHER_WORKOUT"),
                title = map["title"] as String?,
                notes = map["notes"] as String?,
                metadata = metadata,
            )
            "heartRate" -> {
                val samples = asMapList(map["samples"]).map {
                    HeartRateRecord.Sample(
                        time = TimeConverters.toInstant((it["timeMillis"] as Number).toLong()),
                        beatsPerMinute = (it["beatsPerMinute"] as Number).toLong(),
                    )
                }
                HeartRateRecord(
                    startTime = start,
                    startZoneOffset = startOffset,
                    endTime = end,
                    endZoneOffset = endOffset,
                    samples = samples,
                    metadata = metadata,
                )
            }
            "restingHeartRate" -> RestingHeartRateRecord(
                time = start,
                zoneOffset = startOffset,
                beatsPerMinute = (map["beatsPerMinute"] as Number).toLong(),
                metadata = metadata,
            )
            "heartRateVariabilityRmssd" -> HeartRateVariabilityRmssdRecord(
                time = start,
                zoneOffset = startOffset,
                heartRateVariabilityMillis =
                    (map["heartRateVariabilityMillis"] as Number).toDouble(),
                metadata = metadata,
            )
            "bloodPressure" -> BloodPressureRecord(
                time = start,
                zoneOffset = startOffset,
                systolic = Pressure.millimetersOfMercury((map["systolicMmHg"] as Number).toDouble()),
                diastolic = Pressure.millimetersOfMercury((map["diastolicMmHg"] as Number).toDouble()),
                metadata = metadata,
            )
            "weight" -> WeightRecord(
                time = start,
                zoneOffset = startOffset,
                weight = Mass.kilograms((map["weightKilograms"] as Number).toDouble()),
                metadata = metadata,
            )
            "height" -> HeightRecord(
                time = start,
                zoneOffset = startOffset,
                height = Length.meters((map["heightMeters"] as Number).toDouble()),
                metadata = metadata,
            )
            "bodyFat" -> BodyFatRecord(
                time = start,
                zoneOffset = startOffset,
                percentage = Percentage((map["percentage"] as Number).toDouble()),
                metadata = metadata,
            )
            "sleepSession" -> {
                val stages = asMapList(map["stages"]).map {
                    SleepSessionRecord.Stage(
                        startTime = TimeConverters.toInstant((it["startTimeMillis"] as Number).toLong()),
                        endTime = TimeConverters.toInstant((it["endTimeMillis"] as Number).toLong()),
                        stage = sleepStageValue(it["stage"] as String? ?: "SLEEPING"),
                    )
                }
                SleepSessionRecord(
                    startTime = start,
                    startZoneOffset = startOffset,
                    endTime = end,
                    endZoneOffset = endOffset,
                    title = map["title"] as String?,
                    notes = map["notes"] as String?,
                    stages = stages,
                    metadata = metadata,
                )
            }
            "oxygenSaturation" -> OxygenSaturationRecord(
                time = start,
                zoneOffset = startOffset,
                percentage = Percentage((map["percentage"] as Number).toDouble()),
                metadata = metadata,
            )
            "bodyTemperature" -> BodyTemperatureRecord(
                time = start,
                zoneOffset = startOffset,
                temperature = Temperature.celsius((map["temperatureCelsius"] as Number).toDouble()),
                metadata = metadata,
            )
            "nutrition" -> NutritionRecord(
                startTime = start,
                startZoneOffset = startOffset,
                endTime = end,
                endZoneOffset = endOffset,
                name = map["name"] as String?,
                energy = (map["energyKilocalories"] as Number?)?.toDouble()?.let { Energy.kilocalories(it) },
                protein = (map["proteinGrams"] as Number?)?.toDouble()?.let { Mass.grams(it) },
                totalCarbohydrate = (map["totalCarbohydrateGrams"] as Number?)?.toDouble()?.let { Mass.grams(it) },
                totalFat = (map["totalFatGrams"] as Number?)?.toDouble()?.let { Mass.grams(it) },
                sugar = (map["sugarGrams"] as Number?)?.toDouble()?.let { Mass.grams(it) },
                dietaryFiber = (map["dietaryFiberGrams"] as Number?)?.toDouble()?.let { Mass.grams(it) },
                sodium = (map["sodiumMilligrams"] as Number?)?.toDouble()?.let { Mass.milligrams(it) },
                metadata = metadata,
            )
            "bloodGlucose" -> BloodGlucoseRecord(
                time = start,
                zoneOffset = startOffset,
                level = BloodGlucose.millimolesPerLiter(
                    (map["levelMillimolesPerLiter"] as Number).toDouble(),
                ),
                metadata = metadata,
            )
            else -> throw IllegalArgumentException("Unsupported record type: $type")
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun asMapList(raw: Any?): List<Map<String, Any?>> {
        val list = raw as? List<*> ?: return emptyList()
        return list.map { item ->
            val map = item as Map<*, *>
            map.entries.associate { (k, v) -> k.toString() to v as Any? }
        }
    }

    private fun exerciseTypeName(value: Int): String =
        when (value) {
            ExerciseSessionRecord.EXERCISE_TYPE_RUNNING -> "RUNNING"
            ExerciseSessionRecord.EXERCISE_TYPE_WALKING -> "WALKING"
            ExerciseSessionRecord.EXERCISE_TYPE_BIKING -> "BIKING"
            ExerciseSessionRecord.EXERCISE_TYPE_STRENGTH_TRAINING -> "STRENGTH_TRAINING"
            ExerciseSessionRecord.EXERCISE_TYPE_YOGA -> "YOGA"
            ExerciseSessionRecord.EXERCISE_TYPE_SWIMMING_POOL -> "SWIMMING_POOL"
            else -> "OTHER_WORKOUT"
        }

    private fun exerciseTypeValue(name: String): Int =
        when (name.uppercase()) {
            "RUNNING" -> ExerciseSessionRecord.EXERCISE_TYPE_RUNNING
            "WALKING" -> ExerciseSessionRecord.EXERCISE_TYPE_WALKING
            "BIKING" -> ExerciseSessionRecord.EXERCISE_TYPE_BIKING
            "STRENGTH_TRAINING" -> ExerciseSessionRecord.EXERCISE_TYPE_STRENGTH_TRAINING
            "YOGA" -> ExerciseSessionRecord.EXERCISE_TYPE_YOGA
            "SWIMMING_POOL" -> ExerciseSessionRecord.EXERCISE_TYPE_SWIMMING_POOL
            else -> ExerciseSessionRecord.EXERCISE_TYPE_OTHER_WORKOUT
        }

    private fun sleepStageName(value: Int): String =
        when (value) {
            SleepSessionRecord.STAGE_TYPE_AWAKE -> "AWAKE"
            SleepSessionRecord.STAGE_TYPE_SLEEPING -> "SLEEPING"
            SleepSessionRecord.STAGE_TYPE_OUT_OF_BED -> "OUT_OF_BED"
            SleepSessionRecord.STAGE_TYPE_LIGHT -> "LIGHT"
            SleepSessionRecord.STAGE_TYPE_DEEP -> "DEEP"
            SleepSessionRecord.STAGE_TYPE_REM -> "REM"
            else -> "UNKNOWN"
        }

    private fun sleepStageValue(name: String): Int =
        when (name.uppercase()) {
            "AWAKE" -> SleepSessionRecord.STAGE_TYPE_AWAKE
            "SLEEPING" -> SleepSessionRecord.STAGE_TYPE_SLEEPING
            "OUT_OF_BED" -> SleepSessionRecord.STAGE_TYPE_OUT_OF_BED
            "LIGHT" -> SleepSessionRecord.STAGE_TYPE_LIGHT
            "DEEP" -> SleepSessionRecord.STAGE_TYPE_DEEP
            "REM" -> SleepSessionRecord.STAGE_TYPE_REM
            else -> SleepSessionRecord.STAGE_TYPE_SLEEPING
        }
}
