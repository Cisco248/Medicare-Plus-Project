package com.example.client

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "probe" -> result.success(HarMotionService.probe(this))
                "start" -> {
                    val token = call.argument<String>("token").orEmpty()
                    val baseUrl = call.argument<String>("baseUrl").orEmpty()
                    if (token.isEmpty() || baseUrl.isEmpty()) {
                        result.error("invalid_args", "token and baseUrl are required", null)
                        return@setMethodCallHandler
                    }
                    requestNotificationPermission()
                    HarMotionService.start(this, token, baseUrl)
                    result.success(true)
                }
                "stop" -> {
                    HarMotionService.stop(this)
                    result.success(true)
                }
                "isRunning" -> result.success(HarMotionService.isRunning)
                else -> result.notImplemented()
            }
        }
    }

    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return
        if (checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            return
        }
        requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 7101)
    }

    companion object {
        private const val CHANNEL = "com.example.client/har_motion"
    }
}
