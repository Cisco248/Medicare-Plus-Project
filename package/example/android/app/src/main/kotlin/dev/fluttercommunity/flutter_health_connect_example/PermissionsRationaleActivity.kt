package dev.fluttercommunity.flutter_health_connect_example

import android.app.Activity
import android.os.Bundle
import android.widget.TextView

/**
 * Minimal privacy-policy / permission rationale screen required by Health Connect.
 *
 * Host apps must replace this with their real privacy policy content/URL.
 */
class PermissionsRationaleActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val textView =
            TextView(this).apply {
                setPadding(48, 48, 48, 48)
                text =
                    "This example app reads and writes selected Health Connect data " +
                        "types only after you grant permission. Data stays on-device " +
                        "unless your application explicitly syncs it elsewhere.\n\n" +
                        "Replace this screen with your production privacy policy."
            }
        setContentView(textView)
    }
}
