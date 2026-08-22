package dev.fluttercommunity.flutter_health_connect

/**
 * Failures the plugin itself raises, as opposed to failures raised by the
 * Health Connect client.
 *
 * These exist so that [dev.fluttercommunity.flutter_health_connect.converters.ErrorMapper]
 * can classify a failure from its *type* instead of guessing from its message.
 * Guessing from the message is how a permission or IPC failure used to be
 * reported to Dart as "Health Connect is not available".
 */
internal sealed class HealthConnectPluginException(
    message: String,
    cause: Throwable? = null,
) : Exception(message, cause)

/** The Health Connect provider is genuinely missing, disabled, or unsupported. */
internal class ProviderUnavailableException(
    val availability: String,
    message: String,
) : HealthConnectPluginException(message)

/**
 * The provider is available but a [androidx.health.connect.client.HealthConnectClient]
 * could not be constructed. This is an operational failure, not an availability one.
 */
internal class ClientInitializationException(
    message: String,
    cause: Throwable?,
) : HealthConnectPluginException(message, cause)

/** An operation that needs a foreground Activity was invoked while none was attached. */
internal class NoActivityException(
    operation: String,
) : HealthConnectPluginException("No Activity is attached; cannot perform '$operation'.")

/** A permission request was started while another one was still in flight. */
internal class PermissionRequestInProgressException :
    HealthConnectPluginException("Another Health Connect permission request is already in progress.")

/** No installed component can handle the requested Health Connect Intent. */
internal class IntentUnavailableException(
    message: String,
) : HealthConnectPluginException(message)

/** The plugin was detached from the Flutter engine while work was in flight. */
internal class PluginDetachedException :
    HealthConnectPluginException("The Health Connect plugin is detached from the Flutter engine.")
