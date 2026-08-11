package dev.fluttercommunity.flutter_health_connect

import dev.fluttercommunity.flutter_health_connect.converters.ErrorMapper
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

class ErrorMapperTest {
    @Test
    fun mapsInvalidTimeRange() {
        val (code, _) = ErrorMapper.map(IllegalArgumentException("endTime must be after startTime"))
        assertEquals("invalid_time_range", code)
    }

    @Test
    fun mapsUnsupportedRecord() {
        val (code, _) = ErrorMapper.map(IllegalArgumentException("Unsupported record type: bmi"))
        assertEquals("unsupported_record", code)
    }

    @Test
    fun mapsSecurityException() {
        val (code, _) = ErrorMapper.map(SecurityException("denied"))
        assertEquals("security", code)
    }

    @Test
    fun mapsExpiredChangesToken() {
        val (code, _) =
            ErrorMapper.map(IllegalStateException("Changes token has expired"))
        assertEquals("changes", code)
    }

    @Test
    fun mapsPermissionMessage() {
        val (code, _) = ErrorMapper.map(RuntimeException("Missing permission for steps"))
        assertEquals("permission_denied", code)
    }
}
