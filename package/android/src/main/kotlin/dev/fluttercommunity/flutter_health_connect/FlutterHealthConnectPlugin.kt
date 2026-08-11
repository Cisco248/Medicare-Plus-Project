package dev.fluttercommunity.flutter_health_connect

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import dev.fluttercommunity.flutter_health_connect.converters.ErrorMapper

/** FlutterHealthConnectPlugin */
class FlutterHealthConnectPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware {
    private lateinit var channel: MethodChannel
    private var activityBinding: ActivityPluginBinding? = null
    private var activity: Activity? = null

    private var manager: HealthConnectManager? = null
    private lateinit var permissionManager: PermissionManager
    private lateinit var recordManager: RecordManager
    private lateinit var aggregationManager: AggregationManager
    private lateinit var changesManager: ChangesManager
    private val settingsManager = SettingsManager()

    private var scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
            MethodChannel(
                flutterPluginBinding.binaryMessenger,
                "dev.fluttercommunity.flutter_health_connect",
            )
        channel.setMethodCallHandler(this)

        val appContext = flutterPluginBinding.applicationContext
        manager = HealthConnectManager(appContext)
        val clientProvider = { manager!!.requireClient() }
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
                manager?.enableLogging = call.argument<Boolean>("enableLogging") ?: false
                manager?.log("initialized")
                result.success(null)
            }
            "getAvailability" -> {
                result.success(manager?.getAvailability() ?: "unknown")
            }
            "checkPermissions" -> {
                launch(result) {
                    val permissions = castMapList(call.argument("permissions"))
                    result.success(mapOf("granted" to permissionManager.checkPermissions(permissions)))
                }
            }
            "requestPermissions" -> {
                val permissions = castMapList(call.argument("permissions"))
                permissionManager.requestPermissions(permissions) { outcome ->
                    outcome
                        .onSuccess { result.success(it) }
                        .onFailure { ErrorMapper.error(result, it) }
                }
            }
            "getGrantedPermissions" -> {
                launch(result) {
                    result.success(permissionManager.getGrantedPermissionMaps())
                }
            }
            "openHealthConnectSettings" -> {
                val current = activity
                if (current == null) {
                    result.error("unavailable", "No Activity available", null)
                } else {
                    try {
                        settingsManager.openHealthConnectSettings(current)
                        result.success(null)
                    } catch (error: Exception) {
                        ErrorMapper.error(result, error)
                    }
                }
            }
            "openAppPermissions" -> {
                val current = activity
                if (current == null) {
                    result.error("unavailable", "No Activity available", null)
                } else {
                    try {
                        settingsManager.openAppPermissions(current)
                        result.success(null)
                    } catch (error: Exception) {
                        ErrorMapper.error(result, error)
                    }
                }
            }
            "readRecords" -> {
                launch(result) {
                    val records =
                        recordManager.readRecords(
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
                    result.success(recordManager.writeRecords(records))
                }
            }
            "deleteRecord" -> {
                launch(result) {
                    recordManager.deleteRecord(
                        recordType = call.argument<String>("recordType")!!,
                        recordId = call.argument<String>("recordId")!!,
                    )
                    result.success(null)
                }
            }
            "deleteRecordsByTimeRange" -> {
                launch(result) {
                    recordManager.deleteRecordsByTimeRange(
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
                        aggregationManager.aggregate(
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
                        aggregationManager.getDailyHealthSummary(
                            dateMillis = call.argument<Number>("dateMillis")!!.toLong(),
                        )
                    result.success(response)
                }
            }
            "getChangesToken" -> {
                launch(result) {
                    val types = castStringList(call.argument("recordTypes"))
                    result.success(changesManager.getChangesToken(types))
                }
            }
            "getChanges" -> {
                launch(result) {
                    val token = call.argument<String>("token")!!
                    val types = castStringList(call.argument("recordTypes"))
                    result.success(changesManager.getChanges(token, types))
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun launch(
        result: Result,
        block: suspend () -> Unit,
    ) {
        scope.launch {
            try {
                block()
            } catch (error: Throwable) {
                val availability = manager?.getAvailability()
                when (availability) {
                    "notInstalled" ->
                        result.error(
                            "not_installed",
                            error.message ?: "Health Connect is not installed",
                            null,
                        )
                    "notSupported" ->
                        result.error(
                            "unavailable",
                            error.message ?: "Health Connect is unavailable",
                            null,
                        )
                    else -> ErrorMapper.error(result, error)
                }
            }
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun castMapList(raw: Any?): List<Map<String, Any?>> {
        val list = raw as? List<*> ?: return emptyList()
        return list.map { item ->
            val map = item as Map<*, *>
            map.entries.associate { (k, v) -> k.toString() to v as Any? }
        }
    }

    private fun castStringList(raw: Any?): List<String> {
        val list = raw as? List<*> ?: return emptyList()
        return list.map { it.toString() }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        scope.cancel()
        manager = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        activity = binding.activity
        permissionManager.attachActivity(binding.activity)
        binding.addActivityResultListener(permissionManager)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding?.removeActivityResultListener(permissionManager)
        permissionManager.detachActivity()
        activity = null
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activityBinding?.removeActivityResultListener(permissionManager)
        permissionManager.detachActivity()
        activity = null
        activityBinding = null
    }
}
