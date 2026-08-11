package dev.fluttercommunity.flutter_health_connect.converters

import android.os.RemoteException
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

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
            is IllegalArgumentException -> {
                when {
                    message.contains("time", ignoreCase = true) ->
                        "invalid_time_range" to message
                    message.contains("Unsupported record", ignoreCase = true) ->
                        "unsupported_record" to message
                    else -> "record" to message
                }
            }
            is SecurityException -> "security" to message
            is RemoteException -> "unavailable" to message
            is IOException -> "record" to message
            is IllegalStateException -> {
                when {
                    message.contains("not available", ignoreCase = true) ->
                        "not_installed" to message
                    message.contains("token", ignoreCase = true) ->
                        "changes" to message
                    else -> "unknown" to message
                }
            }
            else -> {
                when {
                    message.contains("permission", ignoreCase = true) ->
                        "permission_denied" to message
                    message.contains("Changes token", ignoreCase = true) ||
                        message.contains("change token", ignoreCase = true) ->
                        "changes_token_expired" to message
                    else -> "unknown" to message
                }
            }
        }
    }
}
