package dev.fluttercommunity.flutter_health_connect

import android.app.Activity
import dev.fluttercommunity.flutter_health_connect.converters.ErrorMapper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

/** FlutterHealthConnectPlugin */
class FlutterHealthConnectPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware {
    private var channel: MethodChannel? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var activity: Activity? = null

    private var manager: HealthConnectManager? = null
    private var permissionManager: PermissionManager? = null
    private var recordManager: RecordManager? = null
    private var aggregationManager: AggregationManager? = null
    private var changesManager: ChangesManager? = null
    private val settingsManager = SettingsManager()

    private var scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
            MethodChannel(
                flutterPluginBinding.binaryMessenger,
                CHANNEL_NAME,
            ).also { it.setMethodCallHandler(this) }

        val healthConnectManager = HealthConnectManager(flutterPluginBinding.applicationContext)
        manager = healthConnectManager

        // Resolve the manager through the field on every call so that a detached
        // plugin surfaces a typed error instead of a NullPointerException.
        val clientProvider = { (manager ?: throw PluginDetachedException()).requireClient() }
        permissionManager = PermissionManager(clientProvider)
        recordManager = RecordManager(clientProvider)
        aggregationManager = AggregationManager(clientProvider)
        changesManager = ChangesManager(clientProvider)
        scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result,
    ) {
        when (call.method) {
            "initialize" -> {
                val healthConnectManager = manager
                if (healthConnectManager == null) {
                    ErrorMapper.error(result, PluginDetachedException())
                } else {
                    healthConnectManager.enableLogging =
                        call.argument<Boolean>("enableLogging") ?: false
                    healthConnectManager.log("initialized")
                    result.success(null)
                }
            }
            "getAvailability" -> {
                val healthConnectManager = manager
                if (healthConnectManager == null) {
                    ErrorMapper.error(result, PluginDetachedException())
                } else {
                    result.success(healthConnectManager.getAvailability())
                }
            }
            "checkPermissions" -> {
                launch(result) {
                    val permissions = castMapList(call.argument("permissions"))
                    val granted = requirePermissionManager().checkPermissions(permissions)
                    result.success(mapOf("granted" to granted))
                }
            }
            "requestPermissions" -> {
                val permissions = castMapList(call.argument("permissions"))
                try {
                    requirePermissionManager().requestPermissions(permissions) { outcome ->
                        outcome
                            .onSuccess { result.success(it) }
                            .onFailure { ErrorMapper.error(result, it) }
                    }
                } catch (error: Exception) {
                    ErrorMapper.error(result, error)
                }
            }
            "getGrantedPermissions" -> {
                launch(result) {
                    result.success(requirePermissionManager().getGrantedPermissionMaps())
                }
            }
            "openHealthConnectSettings" -> {
                withActivity(result, "openHealthConnectSettings") { current ->
                    settingsManager.openHealthConnectSettings(current)
                }
            }
            "openAppPermissions" -> {
                withActivity(result, "openAppPermissions") { current ->
                    settingsManager.openAppPermissions(current)
                }
            }
            "openHealthConnectDataManagement" -> {
                withActivity(result, "openHealthConnectDataManagement") { current ->
                    settingsManager.openDataManagement(current)
                }
            }
            "readRecords" -> {
                launch(result) {
                    val records =
                        requireRecordManager().readRecords(
                            recordType = call.argument<String>("recordType")!!,
                            startTimeMillis = call.argument<Number>("startTimeMillis")!!.toLong(),
                            endTimeMillis = call.argument<Number>("endTimeMillis")!!.toLong(),
                        )
                    result.success(records)
                }
            }
            "writeRecords" -> {
                launch(result) {
                    val records = castMapList(call.argument("records"))
                    result.success(requireRecordManager().writeRecords(records))
                }
            }
            "deleteRecord" -> {
                launch(result) {
                    requireRecordManager().deleteRecord(
                        recordType = call.argument<String>("recordType")!!,
                        recordId = call.argument<String>("recordId")!!,
                    )
                    result.success(null)
                }
            }
            "deleteRecordsByTimeRange" -> {
                launch(result) {
                    requireRecordManager().deleteRecordsByTimeRange(
                        recordType = call.argument<String>("recordType")!!,
                        startTimeMillis = call.argument<Number>("startTimeMillis")!!.toLong(),
                        endTimeMillis = call.argument<Number>("endTimeMillis")!!.toLong(),
                    )
                    result.success(null)
                }
            }
            "aggregate" -> {
                launch(result) {
                    val response =
                        requireAggregationManager().result(
                            metric = call.argument<String>("metric")!!,
                            startTimeMillis = call.argument<Number>("startTimeMillis")!!.toLong(),
                            endTimeMillis = call.argument<Number>("endTimeMillis")!!.toLong(),
                        )
                    result.success(response)
                }
            }
            "getDailyHealthSummary" -> {
                launch(result) {
                    val response =
                        requireAggregationManager().getDailyHealthSummary(
                            dateMillis = call.argument<Number>("dateMillis")!!.toLong(),
                        )
                    result.success(response)
                }
            }
            "getChangesToken" -> {
                launch(result) {
                    val types = castStringList(call.argument("recordTypes"))
                    result.success(requireChangesManager().getChangesToken(types))
                }
            }
            "getChanges" -> {
                launch(result) {
                    val token = call.argument<String>("token")!!
                    val types = castStringList(call.argument("recordTypes"))
                    result.success(requireChangesManager().getChanges(token, types))
                }
            }
            else -> result.notImplemented()
        }
    }

    /**
     * Runs [block] on the main scope and reports any failure through [ErrorMapper].
     *
     * The failure is mapped from its own type. It is deliberately *not*
     * reinterpreted by re-reading Health Connect availability: doing that turned
     * every permission and provider error into "Health Connect is not available".
     */
    private fun launch(
        result: Result,
        block: suspend () -> Unit,
    ) {
        scope.launch {
            try {
                block()
            } catch (cancellation: CancellationException) {
                // The scope was cancelled because the engine detached. There is no
                // channel left to answer on, and swallowing this would break
                // structured concurrency.
                throw cancellation
            } catch (error: Exception) {
                if (error is ClientInitializationException) {
                    // Force a rebind on the next call in case the provider process died.
                    manager?.invalidateClient()
                }
                ErrorMapper.error(result, error)
            }
        }
    }

    private fun withActivity(
        result: Result,
        operation: String,
        block: (Activity) -> Unit,
    ) {
        val current = activity
        if (current == null) {
            ErrorMapper.error(result, NoActivityException(operation))
            return
        }
        try {
            block(current)
            result.success(null)
        } catch (error: Exception) {
            ErrorMapper.error(result, error)
        }
    }

    private fun requirePermissionManager(): PermissionManager =
        permissionManager ?: throw PluginDetachedException()

    private fun requireRecordManager(): RecordManager = recordManager ?: throw PluginDetachedException()

    private fun requireAggregationManager(): AggregationManager =
        aggregationManager ?: throw PluginDetachedException()

    private fun requireChangesManager(): ChangesManager =
        changesManager ?: throw PluginDetachedException()

    private fun castMapList(raw: Any?): List<Map<String, Any?>> {
        val list = raw as? List<*> ?: return emptyList()
        return list.mapNotNull { item ->
            val map = item as? Map<*, *> ?: return@mapNotNull null
            map.entries.associate { (key, value) -> key.toString() to value }
        }
    }

    private fun castStringList(raw: Any?): List<String> {
        val list = raw as? List<*> ?: return emptyList()
        return list.mapNotNull { it?.toString() }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        scope.cancel()
        manager = null
        permissionManager = null
        recordManager = null
        aggregationManager = null
        changesManager = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        activity = binding.activity
        permissionManager?.let {
            it.attachActivity(binding.activity)
            binding.addActivityResultListener(it)
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        permissionManager?.let {
            activityBinding?.removeActivityResultListener(it)
            it.detachActivity(retainPending = true)
        }
        activity = null
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        permissionManager?.let {
            activityBinding?.removeActivityResultListener(it)
            it.detachActivity()
        }
        activity = null
        activityBinding = null
    }

    private companion object {
        const val CHANNEL_NAME = "dev.fluttercommunity.flutter_health_connect"
    }
}
