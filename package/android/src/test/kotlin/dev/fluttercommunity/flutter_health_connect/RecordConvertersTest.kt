package dev.fluttercommunity.flutter_health_connect

import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.records.WeightRecord
import androidx.health.connect.client.records.metadata.Device
import androidx.health.connect.client.records.metadata.Metadata
import androidx.health.connect.client.units.Mass
import dev.fluttercommunity.flutter_health_connect.converters.RecordConverters
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import java.time.Instant
import java.time.ZoneOffset

class RecordConvertersTest {
    @Test
    fun stepsFromMapAndToMap() {
        val start = Instant.parse("2024-01-01T10:00:00Z")
        val end = Instant.parse("2024-01-01T11:00:00Z")
        val map =
            mapOf<String, Any?>(
                "recordType" to "steps",
                "startTimeMillis" to start.toEpochMilli(),
                "endTimeMillis" to end.toEpochMilli(),
                "startZoneOffsetSeconds" to 0,
                "endZoneOffsetSeconds" to 0,
                "count" to 1500,
            )
        val record = RecordConverters.fromMap(map) as StepsRecord
        assertEquals(1500L, record.count)
        val out = RecordConverters.toMap(record)
        assertEquals("steps", out["recordType"])
        assertEquals(1500L, out["count"])
    }

    @Test
    fun weightHandlesEqualStartAndEnd() {
        val time = Instant.parse("2024-06-01T12:00:00Z")
        val map =
            mapOf<String, Any?>(
                "recordType" to "weight",
                "startTimeMillis" to time.toEpochMilli(),
                "endTimeMillis" to time.toEpochMilli(),
                "weightKilograms" to 72.5,
            )
        val record = RecordConverters.fromMap(map) as WeightRecord
        assertEquals(72.5, record.weight.inKilograms, 0.001)
    }

    @Test
    fun heartRateSamplesRoundTrip() {
        val start = Instant.parse("2024-01-01T10:00:00Z")
        val end = Instant.parse("2024-01-01T10:05:00Z")
        val map =
            mapOf<String, Any?>(
                "recordType" to "heartRate",
                "startTimeMillis" to start.toEpochMilli(),
                "endTimeMillis" to end.toEpochMilli(),
                "samples" to
                    listOf(
                        mapOf(
                            "timeMillis" to start.toEpochMilli(),
                            "beatsPerMinute" to 72,
                        ),
                    ),
            )
        val record = RecordConverters.fromMap(map)
        val out = RecordConverters.toMap(record)
        assertEquals("heartRate", out["recordType"])
        assertEquals(1, (out["samples"] as List<*>).size)
    }

    @Test
    fun metadataIdSurfacesInToMap() {
        val start = Instant.parse("2024-01-01T10:00:00Z")
        val end = Instant.parse("2024-01-01T11:00:00Z")
        val record =
            StepsRecord(
                startTime = start,
                startZoneOffset = ZoneOffset.UTC,
                endTime = end,
                endZoneOffset = ZoneOffset.UTC,
                count = 10,
                metadata =
                    Metadata.manualEntry(
                        device = Device(type = Device.TYPE_PHONE),
                    ),
            )
        val map = RecordConverters.toMap(record)
        assertEquals("steps", map["recordType"])
        assertTrue(map.containsKey("id"))
    }
}
