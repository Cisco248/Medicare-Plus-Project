package dev.fluttercommunity.flutter_health_connect

import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.records.ActiveCaloriesBurnedRecord
import androidx.health.connect.client.records.DistanceRecord
import androidx.health.connect.client.records.FloorsClimbedRecord
import androidx.health.connect.client.records.HeartRateRecord
import androidx.health.connect.client.records.RestingHeartRateRecord
import androidx.health.connect.client.records.SleepSessionRecord
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.records.TotalCaloriesBurnedRecord
import androidx.health.connect.client.records.WeightRecord
import androidx.health.connect.client.request.AggregateRequest
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter
import dev.fluttercommunity.flutter_health_connect.converters.TimeConverters
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.time.ZoneId

internal class AggregationManager( private val clientProvider: () -> HealthConnectClient) {
    suspend fun aggregate(
        metric: String,
        startTimeMillis: Long,
        endTimeMillis: Long,
    ): Map<String, Any?> =
        withContext(Dispatchers.IO) {
            if (endTimeMillis <= startTimeMillis) {
                throw IllegalArgumentException("endTime must be after startTime")
            }
            val start = TimeConverters.toInstant(startTimeMillis)
            val end = TimeConverters.toInstant(endTimeMillis)
            val client = clientProvider()
            
            val value: Double? =
                when (metric) {
                    "stepsTotal" -> {
                        val response =
                            client.aggregate(
                                AggregateRequest(
                                    metrics = setOf(StepsRecord.COUNT_TOTAL),
                                    timeRangeFilter = TimeRangeFilter.between(start, end),
                                ),
                            )
                        response[StepsRecord.COUNT_TOTAL]?.toDouble()
                    }
                    "distanceTotal" -> {
                        val response =
                            client.aggregate(
                                AggregateRequest(
                                    metrics = setOf(DistanceRecord.DISTANCE_TOTAL),
                                    timeRangeFilter = TimeRangeFilter.between(start, end),
                                ),
                            )
                        response[DistanceRecord.DISTANCE_TOTAL]?.inMeters
                    }
                    "activeCaloriesTotal" -> {
                        val response =
                            client.aggregate(
                                AggregateRequest(
                                    metrics = setOf(ActiveCaloriesBurnedRecord.ACTIVE_CALORIES_TOTAL),
                                    timeRangeFilter = TimeRangeFilter.between(start, end),
                                ),
                            )
                        response[ActiveCaloriesBurnedRecord.ACTIVE_CALORIES_TOTAL]?.inKilocalories
                    }
                    "totalCaloriesTotal" -> {
                        val response =
                            client.aggregate(
                                AggregateRequest(
                                    metrics = setOf(TotalCaloriesBurnedRecord.ENERGY_TOTAL),
                                    timeRangeFilter = TimeRangeFilter.between(start, end),
                                ),
                            )
                        response[TotalCaloriesBurnedRecord.ENERGY_TOTAL]?.inKilocalories
                    }
                    "floorsClimbedTotal" -> {
                        val response =
                            client.aggregate(
                                AggregateRequest(
                                    metrics = setOf(FloorsClimbedRecord.FLOORS_CLIMBED_TOTAL),
                                    timeRangeFilter = TimeRangeFilter.between(start, end),
                                ),
                            )
                        response[FloorsClimbedRecord.FLOORS_CLIMBED_TOTAL]
                    }
                    "heartRateAvg" -> {
                        val response =
                            client.aggregate(
                                AggregateRequest(
                                    metrics = setOf(HeartRateRecord.BPM_AVG),
                                    timeRangeFilter = TimeRangeFilter.between(start, end),
                                ),
                            )
                        response[HeartRateRecord.BPM_AVG]?.toDouble()
                    }
                    "heartRateMin" -> {
                        val response =
                            client.aggregate(
                                AggregateRequest(
                                    metrics = setOf(HeartRateRecord.BPM_MIN),
                                    timeRangeFilter = TimeRangeFilter.between(start, end),
                                ),
                            )
                        response[HeartRateRecord.BPM_MIN]?.toDouble()
                    }
                    "heartRateMax" -> {
                        val response =
                            client.aggregate(
                                AggregateRequest(
                                    metrics = setOf(HeartRateRecord.BPM_MAX),
                                    timeRangeFilter = TimeRangeFilter.between(start, end),
                                ),
                            )
                        response[HeartRateRecord.BPM_MAX]?.toDouble()
                    }
                    "restingHeartRateAvg" -> {
                        val response =
                            client.aggregate(
                                AggregateRequest(
                                    metrics = setOf(RestingHeartRateRecord.BPM_AVG),
                                    timeRangeFilter = TimeRangeFilter.between(start, end),
                                ),
                            )
                        response[RestingHeartRateRecord.BPM_AVG]?.toDouble()
                    }
                    "weightAvg" -> {
                        val response =
                            client.aggregate(
                                AggregateRequest(
                                    metrics = setOf(WeightRecord.WEIGHT_AVG),
                                    timeRangeFilter = TimeRangeFilter.between(start, end),
                                ),
                            )
                        response[WeightRecord.WEIGHT_AVG]?.inKilograms
                    }
                    else -> throw IllegalArgumentException("Unsupported metric: $metric")
                }

            mapOf(
                "metric" to metric,
                "startTimeMillis" to startTimeMillis,
                "endTimeMillis" to endTimeMillis,
                "value" to value,
            )
        }

    suspend fun getDailyHealthSummary(dateMillis: Long): Map<String, Any?> =
        withContext(Dispatchers.IO) {
            val zone = ZoneId.systemDefault()
            val localDate =
                InstantOf(dateMillis).atZone(zone).toLocalDate()
            val dayStart = localDate.atStartOfDay(zone).toInstant()
            val dayEnd = localDate.plusDays(1).atStartOfDay(zone).toInstant()
            val startMillis = dayStart.toEpochMilli()
            val endMillis = dayEnd.toEpochMilli()

            val steps = aggregate("stepsTotal", startMillis, endMillis)["value"] as Double?
            val distance = aggregate("distanceTotal", startMillis, endMillis)["value"] as Double?
            val activeCalories =
                aggregate("activeCaloriesTotal", startMillis, endMillis)["value"] as Double?
            val totalCalories =
                aggregate("totalCaloriesTotal", startMillis, endMillis)["value"] as Double?
            val avgHr = aggregate("heartRateAvg", startMillis, endMillis)["value"] as Double?
            val restingHr =
                aggregate("restingHeartRateAvg", startMillis, endMillis)["value"] as Double?
            val weight = aggregate("weightAvg", startMillis, endMillis)["value"] as Double?
            val sleepMillis = readSleepDurationMillis(dayStart.toEpochMilli(), dayEnd.toEpochMilli())

            mapOf(
                "dateMillis" to localDate.atStartOfDay(zone).toInstant().toEpochMilli(),
                "steps" to steps?.toLong(),
                "distanceMeters" to distance,
                "activeCalories" to activeCalories,
                "totalCalories" to totalCalories,
                "averageHeartRate" to avgHr,
                "restingHeartRate" to restingHr,
                "sleepDurationMillis" to sleepMillis,
                "weight" to weight,
            )
        }

    private suspend fun readSleepDurationMillis(
        startMillis: Long,
        endMillis: Long,
    ): Long? {
        val start = TimeConverters.toInstant(startMillis)
        val end = TimeConverters.toInstant(endMillis)
        val response =
            clientProvider().readRecords(
                ReadRecordsRequest(
                    recordType = SleepSessionRecord::class,
                    timeRangeFilter = TimeRangeFilter.between(start, end),
                ),
            )
        if (response.records.isEmpty()) return null
        val total =
            response.records.sumOf { record ->
                java.time.Duration.between(record.startTime, record.endTime).toMillis()
            }
        return total
    }

    private fun InstantOf(millis: Long) = TimeConverters.toInstant(millis)
}
