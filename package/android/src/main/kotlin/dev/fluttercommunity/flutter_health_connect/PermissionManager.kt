package dev.fluttercommunity.flutter_health_connect

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.PermissionController
import dev.fluttercommunity.flutter_health_connect.converters.RecordTypeMapper
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

internal class PermissionManager(
    private val clientProvider: () -> HealthConnectClient,
) : PluginRegistry.ActivityResultListener {
    private var activity: Activity? = null
    private var pendingResult: ((Result<Set<String>>) -> Unit)? = null
    private val contract = PermissionController.createRequestPermissionResultContract()

    fun attachActivity(activity: Activity) {
        this.activity = activity
    }

    fun detachActivity(retainPending: Boolean = false) {
        activity = null
        if (!retainPending) {
            pendingResult?.invoke(Result.failure(NoActivityException("requestPermissions")))
            pendingResult = null
        }
    }

    suspend fun getGrantedPermissions(): Set<String> =
        withContext(Dispatchers.IO) {
            clientProvider().permissionController.getGrantedPermissions()
        }

    /** Returns the subset of [requested] that Health Connect currently grants. */
    suspend fun checkPermissions(requested: List<Map<String, Any?>>): List<Map<String, String>> {
        val granted = getGrantedPermissions()
        return requested.mapNotNull { item ->
            val type = item["recordType"] as? String ?: return@mapNotNull null
            val access = item["access"] as? String ?: return@mapNotNull null
            val permission = RecordTypeMapper.permissionString(type, access)
            if (granted.contains(permission)) {
                mapOf("recordType" to type, "access" to access)
            } else {
                null
            }
        }
    }

    /**
     * Launches the Health Connect permission UI.
     *
     * The result is delivered through [onActivityResult]. [callback] reports
     * whether *all* requested permissions ended up granted; partial grants are
     * reported as `false` and the caller can re-read the granted set.
     */
    fun requestPermissions(
        requested: List<Map<String, Any?>>,
        callback: (Result<Boolean>) -> Unit,
    ) {
        val activity = this.activity
        if (activity == null) {
            callback(Result.failure(NoActivityException("requestPermissions")))
            return
        }
        if (pendingResult != null) {
            callback(Result.failure(PermissionRequestInProgressException()))
            return
        }

        val permissionStrings =
            try {
                requested
                    .mapNotNull {
                        val type = it["recordType"] as? String
                        val access = it["access"] as? String
                        if (type != null && access != null) {
                            RecordTypeMapper.permissionString(type, access)
                        } else {
                            null
                        }
                    }.toSet()
            } catch (error: Exception) {
                callback(Result.failure(error))
                return
            }

        if (permissionStrings.isEmpty()) {
            callback(Result.success(true))
            return
        }

        pendingResult = { result ->
            result
                .onSuccess { granted -> callback(Result.success(granted.containsAll(permissionStrings))) }
                .onFailure { error -> callback(Result.failure(error)) }
        }

        try {
            activity.startActivityForResult(contract.createIntent(activity, permissionStrings), REQUEST_CODE)
        } catch (error: ActivityNotFoundException) {
            pendingResult = null
            callback(
                Result.failure(
                    IntentUnavailableException(
                        "The Health Connect permission screen could not be opened.",
                    ),
                ),
            )
        } catch (error: Exception) {
            pendingResult = null
            callback(Result.failure(error))
        }
    }

    suspend fun getGrantedPermissionMaps(): List<Map<String, String>> =
        getGrantedPermissions().mapNotNull { RecordTypeMapper.permissionMap(it) }

    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?,
    ): Boolean {
        if (requestCode != REQUEST_CODE) return false
        val callback = pendingResult ?: return false
        pendingResult = null

        try {
            callback(Result.success(contract.parseResult(resultCode, data)))
        } catch (error: Exception) {
            callback(Result.failure(error))
        }
        return true
    }

    private companion object {
        const val REQUEST_CODE = 99147
    }
}
