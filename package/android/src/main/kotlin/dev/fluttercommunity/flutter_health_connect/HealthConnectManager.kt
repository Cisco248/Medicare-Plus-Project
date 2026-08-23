package dev.fluttercommunity.flutter_health_connect

import android.content.Context
import androidx.health.connect.client.HealthConnectClient
import dev.fluttercommunity.flutter_health_connect.converters.ErrorMapper

internal class HealthConnectManager(
    private val context: Context,
) {
    @Volatile
    private var client: HealthConnectClient? = null

    private val clientLock = Any()

    var enableLogging: Boolean = false

    /**
     * Maps `HealthConnectClient.getSdkStatus` onto the Dart `Availability` enum.
     *
     * `SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED` means the provider APK is absent
     * *or* too old to serve this client version; both are resolved by the user
     * installing/updating Health Connect, which is what `notInstalled` conveys.
     */
    fun getAvailability(): String =
        when (HealthConnectClient.getSdkStatus(context)) {
            HealthConnectClient.SDK_AVAILABLE -> ErrorMapper.AVAILABILITY_AVAILABLE
            HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED ->
                ErrorMapper.AVAILABILITY_NOT_INSTALLED
            HealthConnectClient.SDK_UNAVAILABLE -> ErrorMapper.AVAILABILITY_NOT_SUPPORTED
            else -> ErrorMapper.AVAILABILITY_UNKNOWN
        }

    /**
     * Returns a cached client, creating it on first use.
     *
     * Availability is re-checked on every call because the user can install,
     * update, or disable Health Connect while the app is running. A failure to
     * construct the client once availability has been confirmed is reported as
     * [ClientInitializationException] rather than as an availability problem, so
     * a transient provider fault is never presented as "Health Connect missing".
     */
    fun requireClient(): HealthConnectClient {
        when (val availability = getAvailability()) {
            ErrorMapper.AVAILABILITY_AVAILABLE -> Unit
            ErrorMapper.AVAILABILITY_NOT_INSTALLED ->
                throw ProviderUnavailableException(
                    availability,
                    "Health Connect is not installed or requires an update.",
                )
            ErrorMapper.AVAILABILITY_NOT_SUPPORTED ->
                throw ProviderUnavailableException(
                    availability,
                    "Health Connect is not supported on this device.",
                )
            else ->
                throw ProviderUnavailableException(
                    availability,
                    "Health Connect availability could not be determined.",
                )
        }

        client?.let { return it }
        return synchronized(clientLock) {
            client ?: createClient().also { client = it }
        }
    }

    private fun createClient(): HealthConnectClient =
        try {
            HealthConnectClient.getOrCreate(context)
        } catch (error: Exception) {
            throw ClientInitializationException(
                "Health Connect is installed but the client could not be created.",
                error,
            )
        }

    /** Drops the cached client so the next call rebinds to the provider. */
    fun invalidateClient() {
        synchronized(clientLock) { client = null }
    }

    /**
     * Diagnostic logging only. Never pass health record values or tokens here:
     * this writes to logcat, which is readable by other tooling on the device.
     */
    fun log(message: String) {
        if (enableLogging) {
            android.util.Log.d(TAG, message)
        }
    }

    companion object {
        private const val TAG = "FlutterHealthConnect"
    }
}
