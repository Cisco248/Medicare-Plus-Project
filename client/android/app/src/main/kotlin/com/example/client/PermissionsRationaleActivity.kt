package com.example.client

import android.app.Activity
import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.util.TypedValue
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView

/**
 * Explains why MediCare Plus reads Health Connect data.
 *
 * Health Connect starts this screen for
 * `androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE` when the user taps the
 * privacy link in the permission sheet, and for
 * `android.intent.action.VIEW_PERMISSION_USAGE` from system settings. Both
 * intent filters are declared in AndroidManifest.xml; without this class those
 * declarations point at a missing component and the launch fails.
 *
 * The layout is built in code so the screen has no resource dependencies.
 */
class PermissionsRationaleActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val padding = dp(24)
        val container =
            LinearLayout(this).apply {
                orientation = LinearLayout.VERTICAL
                setPadding(padding, padding, padding, padding)
            }

        container.addView(
            TextView(this).apply {
                text = TITLE
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 22f)
            },
        )
        container.addView(
            TextView(this).apply {
                text = RATIONALE
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
                movementMethod = ScrollingMovementMethod()
                setPadding(0, dp(16), 0, 0)
            },
        )

        setContentView(ScrollView(this).apply { addView(container) })
    }

    private fun dp(value: Int): Int = (value * resources.displayMetrics.density).toInt()

    private companion object {
        const val TITLE = "How MediCare Plus uses your health data"

        const val RATIONALE =
            "MediCare Plus reads your Health Connect data to build your daily " +
                "health summary and to give your care team an accurate picture of " +
                "your activity, heart rate, sleep and vital signs.\n\n" +
                "Only the data types you approve are read. Nothing is read in the " +
                "background without your consent, and MediCare Plus never writes to " +
                "or deletes your Health Connect records.\n\n" +
                "You can review or withdraw any permission at any time from " +
                "Health Connect, or from the Permissions screen inside MediCare Plus."
    }
}
