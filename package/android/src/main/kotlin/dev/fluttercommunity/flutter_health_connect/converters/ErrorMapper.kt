package dev.fluttercommunity.flutter_health_connect.converters

import android.os.RemoteException
import dev.fluttercommunity.flutter_health_connect.ClientInitializationException
import dev.fluttercommunity.flutter_health_connect.IntentUnavailableException
import dev.fluttercommunity.flutter_health_connect.NoActivityException
import dev.fluttercommunity.flutter_health_connect.PermissionRequestInProgressException
import dev.fluttercommunity.flutter_health_connect.PluginDetachedException
import dev.fluttercommunity.flutter_health_connect.ProviderUnavailableException
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.util.concurrent.CancellationException

/**
 * Translates native failures into stable error codes consumed by the Dart layer.
 *
 * Availability codes (`unavailable`, `not_installed`) are only ever produced from
 * [ProviderUnavailableException], which is raised exclusively after an explicit
 * `HealthConnectClient.getSdkStatus` check. Every other failure keeps its own
 * category so the caller can tell "Health Connect is missing" apart from
 * "the call failed" or "the user has not granted access".
 */
internal object ErrorMapper {
    fun error(
        result: MethodChannel.Result,
        error: Throwable,
    ) {
        val (code, message) = map(error)
        result.error(code, message, error.javaClass.simpleName)
    }

    fun map(error: Throwable): Pair<String, String> {
        val message = error.message ?: error.javaClass.simpleName
        return when (error) {
            is ProviderUnavailableException ->
                when (error.availability) {
                    AVAILABILITY_NOT_INSTALLED -> CODE_NOT_INSTALLED to message
                    else -> CODE_UNAVAILABLE to message
                }

            is ClientInitializationException -> CODE_CLIENT_INITIALIZATION to message
            is NoActivityException -> CODE_NO_ACTIVITY to message
            is PermissionRequestInProgressException -> CODE_REQUEST_IN_PROGRESS to message
            is IntentUnavailableException -> CODE_INTENT_UNAVAILABLE to message
            is PluginDetachedException -> CODE_DETACHED to message

            // Health Connect denies reads/writes the user has not granted.
            is SecurityException -> CODE_PERMISSION_DENIED to message

            // Binder failure talking to the provider process. The provider is
            // installed; the call failed. This must not be reported as "unavailable".
            is RemoteException -> CODE_PROVIDER_ERROR to message

            is IOException -> CODE_IO_ERROR to message
            is CancellationException -> CODE_CANCELLED to message

            // The provider does not implement the requested feature on this
            // Android version (for example a record type added in a later SDK).
            is UnsupportedOperationException -> CODE_UNSUPPORTED_OPERATION to message

            is IllegalArgumentException -> classifyIllegalArgument(message)
            is IllegalStateException -> classifyIllegalState(message)

            else -> CODE_OPERATION_FAILED to message
        }
    }

    /**
     * [IllegalArgumentException] is raised both by this plugin's own validation and
     * by Health Connect request builders, so the specific cause is only
     * distinguishable from the message. The fallback stays inside the
     * "bad request" family and never escalates to an availability code.
     */
    private fun classifyIllegalArgument(message: String): Pair<String, String> =
        when {
            message.contains("Unsupported record", ignoreCase = true) ->
                CODE_UNSUPPORTED_RECORD to message
            message.contains("Unsupported metric", ignoreCase = true) ->
                CODE_UNSUPPORTED_METRIC to message
            message.contains("Unsupported access", ignoreCase = true) ->
                CODE_INVALID_REQUEST to message
            message.contains("startTime", ignoreCase = true) ||
                message.contains("endTime", ignoreCase = true) ->
                CODE_INVALID_TIME_RANGE to message
            else -> CODE_INVALID_REQUEST to message
        }

    /**
     * An expired changes token is the one [IllegalStateException] with a distinct
     * recovery path (obtain a new token and resync). Everything else is a generic
     * operation failure.
     */
    private fun classifyIllegalState(message: String): Pair<String, String> =
        when {
            message.contains("token", ignoreCase = true) &&
                message.contains("expir", ignoreCase = true) ->
                CODE_CHANGES_TOKEN_EXPIRED to message
            message.contains("token", ignoreCase = true) -> CODE_CHANGES to message
            else -> CODE_OPERATION_FAILED to message
        }

    const val AVAILABILITY_AVAILABLE = "available"
    const val AVAILABILITY_NOT_INSTALLED = "notInstalled"
    const val AVAILABILITY_NOT_SUPPORTED = "notSupported"
    const val AVAILABILITY_UNKNOWN = "unknown"

    private const val CODE_UNAVAILABLE = "unavailable"
    private const val CODE_NOT_INSTALLED = "not_installed"
    private const val CODE_CLIENT_INITIALIZATION = "client_initialization_failed"
    private const val CODE_NO_ACTIVITY = "no_activity"
    private const val CODE_REQUEST_IN_PROGRESS = "request_in_progress"
    private const val CODE_INTENT_UNAVAILABLE = "intent_unavailable"
    private const val CODE_DETACHED = "plugin_detached"
    private const val CODE_PERMISSION_DENIED = "permission_denied"
    private const val CODE_PROVIDER_ERROR = "provider_error"
    private const val CODE_IO_ERROR = "io_error"
    private const val CODE_CANCELLED = "cancelled"
    private const val CODE_UNSUPPORTED_OPERATION = "unsupported_operation"
    private const val CODE_UNSUPPORTED_RECORD = "unsupported_record"
    private const val CODE_UNSUPPORTED_METRIC = "unsupported_metric"
    private const val CODE_INVALID_REQUEST = "invalid_request"
    private const val CODE_INVALID_TIME_RANGE = "invalid_time_range"
    private const val CODE_CHANGES = "changes"
    private const val CODE_CHANGES_TOKEN_EXPIRED = "changes_token_expired"
    private const val CODE_OPERATION_FAILED = "operation_failed"
}
