package dev.fluttercommunity.flutter_health_connect

import androidx.health.connect.client.records.StepsRecord
import dev.fluttercommunity.flutter_health_connect.converters.RecordTypeMapper
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.api.Test

class RecordTypeMapperTest {
    @Test
    fun mapsKnownRecordTypes() {
        assertEquals(StepsRecord::class, RecordTypeMapper.recordClass("steps"))
    }

    @Test
    fun rejectsUnknownRecordType() {
        assertThrows(IllegalArgumentException::class.java) {
            RecordTypeMapper.recordClass("bmi")
        }
    }

    @Test
    fun permissionStringsAreDistinctForReadAndWrite() {
        val read = RecordTypeMapper.permissionString("steps", "read")
        val write = RecordTypeMapper.permissionString("steps", "write")
        assertNotNull(read)
        assertNotNull(write)
        assert(read != write)
    }

    @Test
    fun permissionMapRoundTrip() {
        val permission = RecordTypeMapper.permissionString("heartRate", "read")
        val mapped = RecordTypeMapper.permissionMap(permission)
        assertEquals("heartRate", mapped!!["recordType"])
        assertEquals("read", mapped["access"])
    }
}
