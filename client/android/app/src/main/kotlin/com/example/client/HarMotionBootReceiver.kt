package com.example.client

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class HarMotionBootReceiver : BroadcastReceiver() {
    override fun onReceive(
        context: Context,
        intent: Intent,
    ) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED &&
            intent.action != Intent.ACTION_LOCKED_BOOT_COMPLETED
        ) {
            return
        }
        HarMotionService.startIfConfigured(context)
    }
}
