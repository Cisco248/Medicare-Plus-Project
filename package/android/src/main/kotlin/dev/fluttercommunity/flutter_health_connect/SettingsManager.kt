package dev.fluttercommunity.flutter_health_connect

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.os.Build
import android.provider.Settings
import androidx.health.connect.client.HealthConnectClient

internal class SettingsManager {
    fun openHealthConnectSettings(activity: Activity) {
        try {
            val intent = Intent(HealthConnectClient.ACTION_HEALTH_CONNECT_SETTINGS)
            activity.startActivity(intent)
        } catch (e: ActivityNotFoundException) {
            val intent = Intent(Settings.ACTION_SETTINGS)
            activity.startActivity(intent)
        } catch (e: SecurityException) {
            val intent = Intent(Settings.ACTION_SETTINGS)
            activity.startActivity(intent)
        }
    }

    fun openAppPermissions(activity: Activity) {
        try {
            activity.startActivity(Intent(HealthConnectClient.ACTION_HEALTH_CONNECT_SETTINGS))
        } catch (e: ActivityNotFoundException) {
            activity.startActivity(Intent(Settings.ACTION_SETTINGS))
        }
//        val intent =
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
//                Intent("android.health.connect.action.MANAGE_HEALTH_PERMISSIONS")
//                    .putExtra(Intent.EXTRA_PACKAGE_NAME, activity.packageName)
//            } else {
//                Intent(HealthConnectClient.ACTION_HEALTH_CONNECT_SETTINGS)
//            }
//        activity.startActivity(intent)
    }
}
