package dev.fluttercommunity.flutter_health_connect

import dev.fluttercommunity.flutter_health_connect.converters.TimeConverters
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNull
import org.junit.jupiter.api.Test
import java.time.Instant
import java.time.ZoneOffset

class TimeConvertersTest {
    @Test
    fun epochRoundTripPreservesInstant() {
        val millis = 1_710_046_200_000L // 2024-03-10T07:30:00Z near US DST
        val instant = TimeConverters.toInstant(millis)
        assertEquals(millis, TimeConverters.toEpochMillis(instant))
    }

    @Test
    fun zoneOffsetSecondsHandlesNull() {
        assertNull(TimeConverters.zoneOffsetSeconds(null))
        assertEquals(19800, TimeConverters.zoneOffsetSeconds(ZoneOffset.ofTotalSeconds(19800)))
    }

    @Test
    fun zoneOffsetFromSecondsRoundTrip() {
        val offset = TimeConverters.zoneOffsetFromSeconds(-18000)
        assertEquals(-18000, offset!!.totalSeconds)
    }

    @Test
    fun systemZoneOffsetIsStableForInstant() {
        val instant = Instant.parse("2024-11-03T06:30:00Z") // near US DST fall back
        val offset = TimeConverters.systemZoneOffset(instant)
        // Just ensure a valid ZoneOffset is produced.
        assertEquals(offset, ZoneOffset.ofTotalSeconds(offset.totalSeconds))
    }
}
