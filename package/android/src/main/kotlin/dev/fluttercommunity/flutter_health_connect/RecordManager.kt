package dev.fluttercommunity.flutter_health_connect

import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.records.Record
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter
import dev.fluttercommunity.flutter_health_connect.converters.RecordConverters
import dev.fluttercommunity.flutter_health_connect.converters.RecordTypeMapper
import dev.fluttercommunity.flutter_health_connect.converters.TimeConverters
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

internal class RecordManager(
    private val clientProvider: () -> HealthConnectClient,
) {
    suspend fun readRecords(
        recordType: String,
        startTimeMillis: Long,
        endTimeMillis: Long,
    ): List<Map<String, Any?>> =
        withContext(Dispatchers.IO) {
            validateRange(startTimeMillis, endTimeMillis)
            val start = TimeConverters.toInstant(startTimeMillis)
            val end = TimeConverters.toInstant(endTimeMillis)
            val clazz = RecordTypeMapper.recordClass(recordType)
            val all = mutableListOf<Record>()
            var pageToken: String? = null
            do {
                val response =
                    clientProvider().readRecords(
                        ReadRecordsRequest(
                            recordType = clazz,
                            timeRangeFilter = TimeRangeFilter.between(start, end),
                            pageToken = pageToken,
                        ),
                    )
                all.addAll(response.records)
                pageToken = response.pageToken
            } while (pageToken != null)

            // Deduplicate by record ID while preserving order.
            val seen = linkedSetOf<String>()
            all
                .filter { seen.add(it.metadata.id) }
                .map { RecordConverters.toMap(it) }
        }

    suspend fun writeRecords(records: List<Map<String, Any?>>): List<String> =
        withContext(Dispatchers.IO) {
            val nativeRecords = records.map { RecordConverters.fromMap(it) }
            val response = clientProvider().insertRecords(nativeRecords)
            response.recordIdsList
        }

    suspend fun deleteRecord(
        recordType: String,
        recordId: String,
    ) = withContext(Dispatchers.IO) {
        val clazz = RecordTypeMapper.recordClass(recordType)
        clientProvider().deleteRecords(
            recordType = clazz,
            recordIdsList = listOf(recordId),
            clientRecordIdsList = emptyList(),
        )
    }

    suspend fun deleteRecordsByTimeRange(
        recordType: String,
        startTimeMillis: Long,
        endTimeMillis: Long,
    ) = withContext(Dispatchers.IO) {
        validateRange(startTimeMillis, endTimeMillis)
        val clazz = RecordTypeMapper.recordClass(recordType)
        clientProvider().deleteRecords(
            recordType = clazz,
            timeRangeFilter =
                TimeRangeFilter.between(
                    TimeConverters.toInstant(startTimeMillis),
                    TimeConverters.toInstant(endTimeMillis),
                ),
        )
    }

    private fun validateRange(
        start: Long,
        end: Long,
    ) {
        if (end <= start) {
            throw IllegalArgumentException("endTime must be after startTime")
        }
    }
}
