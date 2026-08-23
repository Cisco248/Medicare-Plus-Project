package dev.fluttercommunity.flutter_health_connect

import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.aggregate.AggregateMetric
import androidx.health.connect.client.aggregate.AggregationResult
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
import java.time.Duration
import java.time.Instant
import java.time.ZoneId

internal class AggregationManager(
    private val clientProvider: () -> HealthConnectClient,
) {
    suspend fun result(
        metric: String,
        startTimeMillis: Long,
        endTimeMillis: Long,
    ): Map<String, Any?> =
        withContext(Dispatchers.IO) {
            if (endTimeMillis <= startTimeMillis) {
                throw IllegalArgumentException("endTime must be after startTime")
            }
            val descriptor =
                METRICS[metric] ?: throw IllegalArgumentException("Unsupported metric: $metric")
            val start = TimeConverters.toInstant(startTimeMillis)
            val end = TimeConverters.toInstant(endTimeMillis)

            val response =
                clientProvider().aggregate(
                    AggregateRequest(
                        metrics = setOf(descriptor.metric),
                        timeRangeFilter = TimeRangeFilter.between(start, end),
                    ),
                )

            mapOf(
                "metric" to metric,
                "startTimeMillis" to startTimeMillis,
                "endTimeMillis" to endTimeMillis,
                "value" to descriptor.read(response),
            )
        }

    /**
     * Builds a summary for the local calendar day containing [dateMillis].
     *
     * All numeric metrics are requested in a single [AggregateRequest]. Health
     * Connect rate-limits foreground calls, so issuing one binder call instead of
     * one per metric matters. If the app is missing a read permission for any
     * metric in the batch the provider rejects the whole request, so that case
     * falls back to per-metric requests and reports the metrics it may read.
     */
    suspend fun getDailyHealthSummary(dateMillis: Long): Map<String, Any?> =
        withContext(Dispatchers.IO) {
            val zone = ZoneId.systemDefault()
            val localDate = TimeConverters.toInstant(dateMillis).atZone(zone).toLocalDate()
            val dayStart = localDate.atStartOfDay(zone).toInstant()
            val dayEnd = localDate.plusDays(1).atStartOfDay(zone).toInstant()
            val range = TimeRangeFilter.between(dayStart, dayEnd)

            val values = aggregateSummaryMetrics(range)

            mapOf(
                "dateMillis" to dayStart.toEpochMilli(),
                "steps" to values[SUMMARY_STEPS]?.toLong(),
                "distanceMeters" to values[SUMMARY_DISTANCE],
                "activeCalories" to values[SUMMARY_ACTIVE_CALORIES],
                "totalCalories" to values[SUMMARY_TOTAL_CALORIES],
                "averageHeartRate" to values[SUMMARY_HEART_RATE],
                "restingHeartRate" to values[SUMMARY_RESTING_HEART_RATE],
                "sleepDurationMillis" to readSleepDurationMillis(dayStart, dayEnd),
                "weight" to values[SUMMARY_WEIGHT],
            )
        }

    private suspend fun aggregateSummaryMetrics(range: TimeRangeFilter): Map<String, Double?> {
        val descriptors =
            SUMMARY_METRICS.mapNotNull { name ->
                METRICS[name]?.let { descriptor -> name to descriptor }
            }
        val client = clientProvider()

        return try {
            val response =
                client.aggregate(
                    AggregateRequest(
                        metrics = descriptors.map { it.second.metric }.toSet(),
                        timeRangeFilter = range,
                    ),
                )
            descriptors.associate { (name, descriptor) -> name to descriptor.read(response) }
        } catch (error: SecurityException) {
            // Partial permissions: keep the metrics the user did grant instead of
            // failing the whole summary.
            descriptors.associate { (name, descriptor) ->
                name to
                    try {
                        descriptor.read(
                            client.aggregate(
                                AggregateRequest(
                                    metrics = setOf(descriptor.metric),
                                    timeRangeFilter = range,
                                ),
                            ),
                        )
                    } catch (denied: SecurityException) {
                        null
                    }
            }
        }
    }

    /**
     * Total time asleep inside the day window.
     *
     * Sessions are clipped to the window so an overnight session is not counted
     * in full against both days, and the reader pages through results because
     * Health Connect caps the number of records per response.
     *
     * Sleep is the one summary field read through the records API rather than
     * aggregation, so it needs the same permission tolerance as
     * [aggregateSummaryMetrics]: a missing sleep grant leaves this field empty
     * instead of failing the whole summary.
     */
    private suspend fun readSleepDurationMillis(
        dayStart: Instant,
        dayEnd: Instant,
    ): Long? {
        val client = clientProvider()
        var pageToken: String? = null
        var total = 0L
        var found = false

        try {
            do {
                val response =
                    client.readRecords(
                        ReadRecordsRequest(
                            recordType = SleepSessionRecord::class,
                            timeRangeFilter = TimeRangeFilter.between(dayStart, dayEnd),
                            pageToken = pageToken,
                        ),
                    )
                for (record in response.records) {
                    found = true
                    val clippedStart = maxOf(record.startTime, dayStart)
                    val clippedEnd = minOf(record.endTime, dayEnd)
                    val duration = Duration.between(clippedStart, clippedEnd)
                    if (!duration.isNegative) total += duration.toMillis()
                }
                pageToken = response.pageToken?.takeIf { it.isNotEmpty() }
            } while (pageToken != null)
        } catch (denied: SecurityException) {
            return null
        }

        return if (found) total else null
    }

    private class MetricDescriptor(
        val metric: AggregateMetric<*>,
        val read: (AggregationResult) -> Double?,
    )

    private companion object {
        const val SUMMARY_STEPS = "stepsTotal"
        const val SUMMARY_DISTANCE = "distanceTotal"
        const val SUMMARY_ACTIVE_CALORIES = "activeCaloriesTotal"
        const val SUMMARY_TOTAL_CALORIES = "totalCaloriesTotal"
        const val SUMMARY_HEART_RATE = "heartRateAvg"
        const val SUMMARY_RESTING_HEART_RATE = "restingHeartRateAvg"
        const val SUMMARY_WEIGHT = "weightAvg"

        val SUMMARY_METRICS =
            listOf(
                SUMMARY_STEPS,
                SUMMARY_DISTANCE,
                SUMMARY_ACTIVE_CALORIES,
                SUMMARY_TOTAL_CALORIES,
                SUMMARY_HEART_RATE,
                SUMMARY_RESTING_HEART_RATE,
                SUMMARY_WEIGHT,
            )

        val METRICS: Map<String, MetricDescriptor> =
            mapOf(
                SUMMARY_STEPS to
                    MetricDescriptor(StepsRecord.COUNT_TOTAL) { it[StepsRecord.COUNT_TOTAL]?.toDouble() },
                SUMMARY_DISTANCE to
                    MetricDescriptor(DistanceRecord.DISTANCE_TOTAL) {
                        it[DistanceRecord.DISTANCE_TOTAL]?.inMeters
                    },
                SUMMARY_ACTIVE_CALORIES to
                    MetricDescriptor(ActiveCaloriesBurnedRecord.ACTIVE_CALORIES_TOTAL) {
                        it[ActiveCaloriesBurnedRecord.ACTIVE_CALORIES_TOTAL]?.inKilocalories
                    },
                SUMMARY_TOTAL_CALORIES to
                    MetricDescriptor(TotalCaloriesBurnedRecord.ENERGY_TOTAL) {
                        it[TotalCaloriesBurnedRecord.ENERGY_TOTAL]?.inKilocalories
                    },
                "floorsClimbedTotal" to
                    MetricDescriptor(FloorsClimbedRecord.FLOORS_CLIMBED_TOTAL) {
                        it[FloorsClimbedRecord.FLOORS_CLIMBED_TOTAL]
                    },
                SUMMARY_HEART_RATE to
                    MetricDescriptor(HeartRateRecord.BPM_AVG) { it[HeartRateRecord.BPM_AVG]?.toDouble() },
                "heartRateMin" to
                    MetricDescriptor(HeartRateRecord.BPM_MIN) { it[HeartRateRecord.BPM_MIN]?.toDouble() },
                "heartRateMax" to
                    MetricDescriptor(HeartRateRecord.BPM_MAX) { it[HeartRateRecord.BPM_MAX]?.toDouble() },
                SUMMARY_RESTING_HEART_RATE to
                    MetricDescriptor(RestingHeartRateRecord.BPM_AVG) {
                        it[RestingHeartRateRecord.BPM_AVG]?.toDouble()
                    },
                SUMMARY_WEIGHT to
                    MetricDescriptor(WeightRecord.WEIGHT_AVG) { it[WeightRecord.WEIGHT_AVG]?.inKilograms },
            )
    }
}
