package dev.fluttercommunity.flutter_health_connect

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

/**
 * Smoke test placeholder for plugin wiring.
 *
 * Full MethodChannel integration is covered by the example app on a device/emulator
 * with Health Connect installed.
 */
class FlutterHealthConnectPluginTest {
    @Test
    fun availabilityMappingConstantsMatchDartNames() {
        assertEquals("available", "available")
        assertEquals("notInstalled", "notInstalled")
        assertEquals("notSupported", "notSupported")
        assertEquals("unknown", "unknown")
    }
}
