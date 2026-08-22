package dev.fluttercommunity.flutter_health_connect

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.health.connect.client.HealthConnectClient

/**
 * Launches the three distinct Health Connect destinations.
 *
 * Health Connect ships either as the `com.google.android.apps.healthdata` APK
 * (Android 13 and lower) or as a platform component (Android 14+). The two
 * expose *different* Intent actions, and even on Android 14+ the platform
 * actions are not guaranteed to be resolvable. Every action is therefore
 * probed with [Intent.resolveActivity] before it is started, and each
 * destination falls back through its own ordered candidate list.
 *
 * Checking `Build.VERSION.SDK_INT` alone is not sufficient: on this project's
 * Android 13 test device `android.health.connect.action.MANAGE_HEALTH_PERMISSIONS`
 * does not resolve at all, while the `androidx.health.*` actions do.
 */
internal class SettingsManager {
    /** Opens the Health Connect home / settings screen. */
    fun openHealthConnectSettings(activity: Activity) {
        val candidates = mutableListOf<Intent>()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            candidates += Intent(ACTION_PLATFORM_HEALTH_HOME_SETTINGS)
        }
        candidates += Intent(ACTION_ANDROIDX_HEALTH_CONNECT_SETTINGS)
        candidates += manageDataIntent(activity)

        start(activity, candidates, "Health Connect settings")
    }

    /**
     * Opens the screen listing *this* application's Health Connect permissions.
     *
     * This only navigates the user to the permission screen. Granting is done by
     * the Health Connect UI itself via
     * `PermissionController.createRequestPermissionResultContract`; the plugin
     * never attempts to grant permissions, which would require the privileged
     * `android.permission.GRANT_RUNTIME_PERMISSIONS`.
     */
    fun openAppPermissions(activity: Activity) {
        val candidates = mutableListOf<Intent>()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            candidates +=
                Intent(ACTION_PLATFORM_MANAGE_HEALTH_PERMISSIONS)
                    .putExtra(Intent.EXTRA_PACKAGE_NAME, activity.packageName)
        }
        // The APK provider has no per-app permission action; its settings screen
        // is the entry point for reviewing and revoking app access.
        candidates += Intent(ACTION_ANDROIDX_HEALTH_CONNECT_SETTINGS)
        candidates += manageDataIntent(activity)

        start(activity, candidates, "Health Connect app permissions")
    }

    /** Opens the Health Connect data-and-access management screen. */
    fun openDataManagement(activity: Activity) {
        val candidates =
            mutableListOf(
                manageDataIntent(activity),
                Intent(ACTION_ANDROIDX_HEALTH_CONNECT_SETTINGS),
            )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            candidates += Intent(ACTION_PLATFORM_HEALTH_HOME_SETTINGS)
        }

        start(activity, candidates, "Health Connect data management")
    }

    /**
     * The provider-appropriate "manage data" Intent.
     *
     * The AndroidX helper already picks between the platform and APK providers,
     * so it is preferred over a hardcoded action. It needs package visibility to
     * work, which the plugin manifest declares.
     */
    private fun manageDataIntent(context: Context): Intent =
        try {
            HealthConnectClient.getHealthConnectManageDataIntent(context)
        } catch (error: Exception) {
            Intent(ACTION_ANDROIDX_MANAGE_HEALTH_DATA)
        }

    private fun start(
        activity: Activity,
        candidates: List<Intent>,
        destination: String,
    ) {
        for (intent in candidates) {
            if (startIfResolvable(activity, intent)) return
        }

        // Last resort: the provider's own launcher entry. Generic Android
        // settings is deliberately not used, because landing the user on an
        // unrelated screen is indistinguishable from a broken button.
        val launchIntent =
            activity.packageManager.getLaunchIntentForPackage(HEALTH_CONNECT_PACKAGE)
        if (launchIntent != null && startIfResolvable(activity, launchIntent)) return

        throw IntentUnavailableException(
            "No installed component can open $destination on this device.",
        )
    }

    private fun startIfResolvable(
        activity: Activity,
        intent: Intent,
    ): Boolean {
        if (!intent.canBeHandled(activity)) return false
        return try {
            activity.startActivity(intent)
            true
        } catch (error: Exception) {
            // Another app may have been disabled or the component may be guarded
            // by a permission we do not hold. Fall through to the next candidate.
            false
        }
    }

    private fun Intent.canBeHandled(context: Context): Boolean =
        resolveActivity(context.packageManager) != null

    private companion object {
        const val HEALTH_CONNECT_PACKAGE = "com.google.android.apps.healthdata"

        /**
         * Provided by the Health Connect APK on Android 13 and lower, and
         * confirmed resolvable on this project's Android 13 test device.
         * Declared as literals rather than through the deprecated
         * `HealthConnectClient.ACTION_HEALTH_CONNECT_SETTINGS` constant.
         */
        const val ACTION_ANDROIDX_HEALTH_CONNECT_SETTINGS =
            "androidx.health.ACTION_HEALTH_CONNECT_SETTINGS"
        const val ACTION_ANDROIDX_MANAGE_HEALTH_DATA = "androidx.health.ACTION_MANAGE_HEALTH_DATA"

        /** Platform-only actions, present from Android 14 (UPSIDE_DOWN_CAKE). */
        const val ACTION_PLATFORM_HEALTH_HOME_SETTINGS =
            "android.health.connect.action.HEALTH_HOME_SETTINGS"
        const val ACTION_PLATFORM_MANAGE_HEALTH_PERMISSIONS =
            "android.health.connect.action.MANAGE_HEALTH_PERMISSIONS"
    }
}
