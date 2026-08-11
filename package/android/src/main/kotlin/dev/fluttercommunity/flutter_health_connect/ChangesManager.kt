package dev.fluttercommunity.flutter_health_connect

import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.changes.DeletionChange
import androidx.health.connect.client.changes.UpsertionChange
import androidx.health.connect.client.records.Record
import androidx.health.connect.client.request.ChangesTokenRequest
import dev.fluttercommunity.flutter_health_connect.converters.RecordConverters
import dev.fluttercommunity.flutter_health_connect.converters.RecordTypeMapper
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

internal class ChangesManager(
    private val clientProvider: () -> HealthConnectClient,
) {
    suspend fun getChangesToken(recordTypes: List<String>): Map<String, Any?> =
        withContext(Dispatchers.IO) {
            if (recordTypes.isEmpty()) {
                throw IllegalArgumentException("recordTypes must not be empty")
            }
            val classes = recordTypes.map { RecordTypeMapper.recordClass(it) }.toSet()
            val token =
                clientProvider().getChangesToken(
                    ChangesTokenRequest(recordTypes = classes),
                )
            mapOf(
                "token" to token,
                "recordTypes" to recordTypes,
            )
        }

    suspend fun getChanges(
        token: String,
        recordTypes: List<String>,
    ): Map<String, Any?> =
        withContext(Dispatchers.IO) {
            val upserted = mutableListOf<Map<String, Any?>>()
            val deleted = mutableListOf<String>()
            var nextToken = token
            var hasMore = true
            var expired = false

            try {
                while (hasMore) {
                    val response = clientProvider().getChanges(nextToken)
                    if (response.changesTokenExpired) {
                        expired = true
                        hasMore = false
                        break
                    }
                    for (change in response.changes) {
                        when (change) {
                            is UpsertionChange -> {
                                upserted.add(RecordConverters.toMap(change.record))
                            }
                            is DeletionChange -> {
                                deleted.add(change.recordId)
                            }
                        }
                    }
                    nextToken = response.nextChangesToken
                    hasMore = response.hasMore
                }
            } catch (error: Exception) {
                val message = error.message.orEmpty()
                if (message.contains("token", ignoreCase = true) &&
                    message.contains("expir", ignoreCase = true)
                ) {
                    expired = true
                } else {
                    throw error
                }
            }

            mapOf(
                "upsertedRecords" to upserted,
                "deletedRecordIds" to deleted,
                "nextChangesToken" to
                    mapOf(
                        "token" to nextToken,
                        "recordTypes" to recordTypes,
                    ),
                "hasMore" to false,
                "changesTokenExpired" to expired,
            )
        }
}
