package dev.fluttercommunity.flutter_health_connect

import android.os.RemoteException
import dev.fluttercommunity.flutter_health_connect.converters.ErrorMapper
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import java.io.IOException

/**
 * The contract these tests protect: an availability code is produced *only* from
 * [ProviderUnavailableException], which the plugin raises after an explicit
 * `getSdkStatus` check. Everything else keeps its own category.
 */
class ErrorMapperTest {
    @Test
    fun mapsMissingProviderToNotInstalled() {
        val (code, _) =
            ErrorMapper.map(
                ProviderUnavailableException(
                    ErrorMapper.AVAILABILITY_NOT_INSTALLED,
                    "Health Connect is not installed or requires an update.",
                ),
            )
        assertEquals("not_installed", code)
    }

    @Test
    fun mapsUnsupportedDeviceToUnavailable() {
        val (code, _) =
            ErrorMapper.map(
                ProviderUnavailableException(
                    ErrorMapper.AVAILABILITY_NOT_SUPPORTED,
                    "Health Connect is not supported on this device.",
                ),
            )
        assertEquals("unavailable", code)
    }

    @Test
    fun clientCreationFailureIsNotAnAvailabilityFailure() {
        val (code, _) =
            ErrorMapper.map(
                ClientInitializationException("client could not be created", IllegalStateException()),
            )
        assertEquals("client_initialization_failed", code)
    }

    @Test
    fun binderFailureIsNotAnAvailabilityFailure() {
        val (code, _) = ErrorMapper.map(RemoteException("transaction failed"))
        assertEquals("provider_error", code)
    }

    @Test
    fun ioFailureIsNotAnAvailabilityFailure() {
        val (code, _) = ErrorMapper.map(IOException("read failed"))
        assertEquals("io_error", code)
    }

    /**
     * Regression guard. This message used to be matched by a `contains("not
     * available")` branch and reported as `not_installed`, which the app then
     * rendered as "Health Connect is not available on this device" (404).
     */
    @Test
    fun illegalStateMentioningNotAvailableIsNotReportedAsMissingProvider() {
        val (code, _) = ErrorMapper.map(IllegalStateException("Service not available"))
        assertEquals("operation_failed", code)
    }

    @Test
    fun mapsSecurityExceptionToPermissionDenied() {
        val (code, _) = ErrorMapper.map(SecurityException("denied"))
        assertEquals("permission_denied", code)
    }

    @Test
    fun mapsMissingActivity() {
        val (code, _) = ErrorMapper.map(NoActivityException("openAppPermissions"))
        assertEquals("no_activity", code)
    }

    @Test
    fun mapsUnresolvableIntent() {
        val (code, _) = ErrorMapper.map(IntentUnavailableException("nothing can handle this"))
        assertEquals("intent_unavailable", code)
    }

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
    fun mapsUnsupportedMetric() {
        val (code, _) = ErrorMapper.map(IllegalArgumentException("Unsupported metric: bmi"))
        assertEquals("unsupported_metric", code)
    }

    @Test
    fun mapsExpiredChangesToken() {
        val (code, _) = ErrorMapper.map(IllegalStateException("Changes token has expired"))
        assertEquals("changes_token_expired", code)
    }

    @Test
    fun mapsUnclassifiedFailureToOperationFailed() {
        val (code, _) = ErrorMapper.map(RuntimeException("something went wrong"))
        assertEquals("operation_failed", code)
    }
}
