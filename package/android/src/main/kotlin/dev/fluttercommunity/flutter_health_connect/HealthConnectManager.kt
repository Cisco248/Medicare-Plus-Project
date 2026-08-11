package dev.fluttercommunity.flutter_health_connect

import android.content.Context
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.HealthConnectFeatures

internal class HealthConnectManager(
    private val context: Context,
) {
    @Volatile
    private var client: HealthConnectClient? = null

    var enableLogging: Boolean = false

    fun getAvailability(): String {
        val status = HealthConnectClient.getSdkStatus(context)
        return when (status) {
            HealthConnectClient.SDK_AVAILABLE -> "available"
            HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED -> "notInstalled"
            HealthConnectClient.SDK_UNAVAILABLE -> "notSupported"
            else -> "unknown"
        }
    }

    fun requireClient(): HealthConnectClient {
        val status = HealthConnectClient.getSdkStatus(context)
        when (status) {
            HealthConnectClient.SDK_UNAVAILABLE ->
                throw IllegalStateException("Health Connect is not supported on this device")
            HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED ->
                throw IllegalStateException("Health Connect provider is not available")
            HealthConnectClient.SDK_AVAILABLE -> Unit
            else -> throw IllegalStateException("Unknown Health Connect availability status")
        }
        return client ?: HealthConnectClient.getOrCreate(context).also { client = it }
    }

    fun log(message: String) {
        if (enableLogging) {
            android.util.Log.d(TAG, message)
        }
    }

    companion object {
        private const val TAG = "FlutterHealthConnect"
    }
}
