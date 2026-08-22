package dev.fluttercommunity.flutter_health_connect.converters

import androidx.health.connect.client.permission.HealthPermission
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
import kotlin.reflect.KClass

internal object RecordTypeMapper {
    fun recordClass(type: String): KClass<out Record> =
        when (type) {
            "steps" -> StepsRecord::class
            "distance" -> DistanceRecord::class
            "activeCaloriesBurned" -> ActiveCaloriesBurnedRecord::class
            "totalCaloriesBurned" -> TotalCaloriesBurnedRecord::class
            "floorsClimbed" -> FloorsClimbedRecord::class
            "exerciseSession" -> ExerciseSessionRecord::class
            "heartRate" -> HeartRateRecord::class
            "restingHeartRate" -> RestingHeartRateRecord::class
            "heartRateVariabilityRmssd" -> HeartRateVariabilityRmssdRecord::class
            "bloodPressure" -> BloodPressureRecord::class
            "weight" -> WeightRecord::class
            "height" -> HeightRecord::class
            "bodyFat" -> BodyFatRecord::class
            "sleepSession" -> SleepSessionRecord::class
            "oxygenSaturation" -> OxygenSaturationRecord::class
            "bodyTemperature" -> BodyTemperatureRecord::class
            "nutrition" -> NutritionRecord::class
            "bloodGlucose" -> BloodGlucoseRecord::class
            else -> throw IllegalArgumentException("Unsupported record type: $type")
        }

    fun typeName(record: Record): String =
        when (record) {
            is StepsRecord -> "steps"
            is DistanceRecord -> "distance"
            is ActiveCaloriesBurnedRecord -> "activeCaloriesBurned"
            is TotalCaloriesBurnedRecord -> "totalCaloriesBurned"
            is FloorsClimbedRecord -> "floorsClimbed"
            is ExerciseSessionRecord -> "exerciseSession"
            is HeartRateRecord -> "heartRate"
            is RestingHeartRateRecord -> "restingHeartRate"
            is HeartRateVariabilityRmssdRecord -> "heartRateVariabilityRmssd"
            is BloodPressureRecord -> "bloodPressure"
            is WeightRecord -> "weight"
            is HeightRecord -> "height"
            is BodyFatRecord -> "bodyFat"
            is SleepSessionRecord -> "sleepSession"
            is OxygenSaturationRecord -> "oxygenSaturation"
            is BodyTemperatureRecord -> "bodyTemperature"
            is NutritionRecord -> "nutrition"
            is BloodGlucoseRecord -> "bloodGlucose"
            else -> throw IllegalArgumentException("Unsupported record: ${record::class.java.simpleName}")
        }

    fun permissionString(recordType: String, access: String): String {
        val clazz = recordClass(recordType)
        return when (access) {
            "read" -> HealthPermission.getReadPermission(clazz)
            "write" -> HealthPermission.getWritePermission(clazz)
            else -> throw IllegalArgumentException("Unsupported access: $access")
        }
    }

    /**
     * Resolves a raw Health Connect permission string back to a record type and
     * access mode, or `null` for permissions this plugin does not model (for
     * example `READ_HEALTH_DATA_IN_BACKGROUND`).
     */
    fun permissionMap(permission: String): Map<String, String>? = PERMISSION_INDEX[permission]

    private val PERMISSION_INDEX: Map<String, Map<String, String>> by lazy {
        buildMap {
            for (type in SUPPORTED_TYPES) {
                val clazz = recordClass(type)
                put(
                    HealthPermission.getReadPermission(clazz),
                    mapOf("recordType" to type, "access" to "read"),
                )
                put(
                    HealthPermission.getWritePermission(clazz),
                    mapOf("recordType" to type, "access" to "write"),
                )
            }
        }
    }

    val SUPPORTED_TYPES: List<String> =
        listOf(
            "steps",
            "distance",
            "activeCaloriesBurned",
            "totalCaloriesBurned",
            "floorsClimbed",
            "exerciseSession",
            "heartRate",
            "restingHeartRate",
            "heartRateVariabilityRmssd",
            "bloodPressure",
            "weight",
            "height",
            "bodyFat",
            "sleepSession",
            "oxygenSaturation",
            "bodyTemperature",
            "nutrition",
            "bloodGlucose",
        )
}
