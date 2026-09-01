package com.example.client

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.Handler
import android.os.HandlerThread
import android.os.IBinder
import android.os.PowerManager
import android.os.SystemClock
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import org.json.JSONArray
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import java.time.Instant
import java.util.concurrent.CopyOnWriteArrayList

/**
 * Captures accelerometer + gyroscope X/Y/Z while the Flutter UI is closed
 * and POSTs batches to `/api-har/samples`.
 */
class HarMotionService : Service(), SensorEventListener {
    data class Sample(
        val timestamp: String,
        val accX: Double,
        val accY: Double,
        val accZ: Double,
        val gyroX: Double,
        val gyroY: Double,
        val gyroZ: Double,
    )

    private var sensorManager: SensorManager? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private var sensorThread: HandlerThread? = null
    private var sensorHandler: Handler? = null
    private var flushHandler: Handler? = null
    private var token: String = ""
    private var baseUrl: String = ""
    private var captureEnabled: Boolean = true
    private var lastAcc: FloatArray? = null
    private var lastGyro: FloatArray? = null
    private var lastEmitElapsedMs: Long = 0
    private val buffer = CopyOnWriteArrayList<Sample>()
    private var uploading = false

    private val flushRunnable =
        object : Runnable {
            override fun run() {
                flush()
                flushHandler?.postDelayed(this, FLUSH_EVERY_MS)
            }
        }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        createChannel()
        startInForeground()
        acquireWakeLock()
        val thread = HandlerThread("har-motion-sensors").also { it.start() }
        sensorThread = thread
        sensorHandler = Handler(thread.looper)
        flushHandler = Handler(thread.looper)
    }

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int,
    ): Int {
        val prefs = getSharedPreferences(PREFS, MODE_PRIVATE)
        token = intent?.getStringExtra(EXTRA_TOKEN) ?: prefs.getString(KEY_TOKEN, "") ?: ""
        baseUrl = intent?.getStringExtra(EXTRA_BASE_URL) ?: prefs.getString(KEY_BASE_URL, "") ?: ""
        captureEnabled =
            if (intent != null && intent.hasExtra(EXTRA_CAPTURE)) {
                intent.getBooleanExtra(EXTRA_CAPTURE, true)
            } else {
                prefs.getBoolean(KEY_CAPTURE, true)
            }
        if (token.isNotEmpty() && baseUrl.isNotEmpty()) {
            prefs
                .edit()
                .putString(KEY_TOKEN, token)
                .putString(KEY_BASE_URL, baseUrl)
                .putBoolean(KEY_CAPTURE, captureEnabled)
                .apply()
        }
        isRunning = true
        flushHandler?.removeCallbacks(flushRunnable)
        if (captureEnabled) {
            registerSensors()
            flushHandler?.postDelayed(flushRunnable, FLUSH_EVERY_MS)
        } else {
            unregisterSensors()
        }
        return START_STICKY
    }

    override fun onDestroy() {
        flushHandler?.removeCallbacks(flushRunnable)
        unregisterSensors()
        flush()
        sensorThread?.quitSafely()
        sensorThread = null
        sensorHandler = null
        flushHandler = null
        releaseWakeLock()
        isRunning = false
        super.onDestroy()
    }

    override fun onSensorChanged(event: SensorEvent) {
        when (event.sensor.type) {
            Sensor.TYPE_ACCELEROMETER -> lastAcc = event.values.copyOf(3)
            Sensor.TYPE_GYROSCOPE -> lastGyro = event.values.copyOf(3)
            else -> return
        }
        emitIfReady()
    }

    override fun onAccuracyChanged(
        sensor: Sensor?,
        accuracy: Int,
    ) = Unit

    private fun emitIfReady() {
        if (!captureEnabled) return
        val acc = lastAcc ?: return
        val gyro = lastGyro ?: return
        val now = SystemClock.elapsedRealtime()
        if (lastEmitElapsedMs != 0L && now - lastEmitElapsedMs < MIN_INTERVAL_MS) {
            return
        }
        lastEmitElapsedMs = now
        buffer.add(
            Sample(
                timestamp = Instant.now().toString(),
                accX = acc[0].toDouble(),
                accY = acc[1].toDouble(),
                accZ = acc[2].toDouble(),
                gyroX = gyro[0].toDouble(),
                gyroY = gyro[1].toDouble(),
                gyroZ = gyro[2].toDouble(),
            ),
        )
        if (buffer.size >= BATCH_SIZE) {
            flush()
        }
    }

    private fun registerSensors() {
        unregisterSensors()
        val manager = getSystemService(SENSOR_SERVICE) as SensorManager
        sensorManager = manager
        val accelerometer = manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        val gyroscope = manager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
        if (accelerometer == null || gyroscope == null) {
            Log.e(TAG, "Accelerometer or gyroscope is missing on this device")
            stopSelf()
            return
        }
        val handler = sensorHandler
        val delay = SensorManager.SENSOR_DELAY_UI
        manager.registerListener(this, accelerometer, delay, handler)
        manager.registerListener(this, gyroscope, delay, handler)
    }

    private fun unregisterSensors() {
        sensorManager?.unregisterListener(this)
        sensorManager = null
        lastAcc = null
        lastGyro = null
        lastEmitElapsedMs = 0
    }

    private fun flush() {
        if (!captureEnabled || uploading || buffer.isEmpty() || token.isEmpty() || baseUrl.isEmpty()) {
            return
        }
        val batch = buffer.toList()
        buffer.clear()
        uploading = true
        Thread {
            try {
                upload(batch)
            } catch (error: Exception) {
                Log.w(TAG, "HAR sample upload failed", error)
                if (buffer.size + batch.size <= MAX_RETRY_BUFFER) {
                    buffer.addAll(0, batch)
                }
            } finally {
                uploading = false
            }
        }.start()
    }

    private fun upload(batch: List<Sample>) {
        val samples = JSONArray()
        for (sample in batch) {
            samples.put(
                JSONObject()
                    .put("timestamp", sample.timestamp)
                    .put("acc_x", sample.accX)
                    .put("acc_y", sample.accY)
                    .put("acc_z", sample.accZ)
                    .put("gyro_x", sample.gyroX)
                    .put("gyro_y", sample.gyroY)
                    .put("gyro_z", sample.gyroZ),
            )
        }
        val body = JSONObject().put("samples", samples).toString()
        val url = URL(baseUrl.trimEnd('/') + "/api-har/samples")
        val connection = url.openConnection() as HttpURLConnection
        try {
            connection.requestMethod = "POST"
            connection.connectTimeout = 15_000
            connection.readTimeout = 30_000
            connection.doOutput = true
            connection.setRequestProperty("Content-Type", "application/json")
            connection.setRequestProperty("X-Auth-Token", token)
            connection.outputStream.bufferedWriter(Charsets.UTF_8).use { writer ->
                writer.write(body)
            }
            val code = connection.responseCode
            if (code !in 200..299) {
                val detail =
                    (connection.errorStream ?: connection.inputStream)
                        ?.bufferedReader()
                        ?.readText()
                throw IllegalStateException("HTTP $code ${detail ?: ""}")
            }
        } finally {
            connection.disconnect()
        }
    }

    private fun startInForeground() {
        val notification = buildNotification()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE,
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
    }

    private fun buildNotification(): Notification =
        NotificationCompat
            .Builder(this, CHANNEL_ID)
            .setContentTitle("MediCare Plus")
            .setContentText("Recording accelerometer and gyroscope")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setOngoing(true)
            .setSilent(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()

    private fun createChannel() {
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                "Activity tracking",
                NotificationManager.IMPORTANCE_LOW,
            ).apply {
                description = "Keeps accelerometer and gyroscope capture running"
                setShowBadge(false)
            },
        )
    }

    private fun acquireWakeLock() {
        val power = getSystemService(POWER_SERVICE) as PowerManager
        wakeLock =
            power.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "medicare:har").apply {
                setReferenceCounted(false)
                acquire(12 * 60 * 60 * 1000L)
            }
    }

    private fun releaseWakeLock() {
        wakeLock?.let { lock ->
            if (lock.isHeld) lock.release()
        }
        wakeLock = null
    }

    companion object {
        private const val TAG = "HarMotionService"
        private const val PREFS = "har_motion"
        private const val KEY_TOKEN = "token"
        private const val KEY_BASE_URL = "base_url"
        const val EXTRA_TOKEN = "token"
        const val EXTRA_BASE_URL = "base_url"
        const val EXTRA_CAPTURE = "capture"
        private const val KEY_CAPTURE = "capture"
        private const val CHANNEL_ID = "har_motion"
        private const val NOTIFICATION_ID = 7102
        private const val BATCH_SIZE = 80
        private const val MAX_RETRY_BUFFER = 400
        private const val MIN_INTERVAL_MS = 50L
        private const val FLUSH_EVERY_MS = 6_000L

        @Volatile
        var isRunning: Boolean = false
            private set

        fun probe(context: Context): Map<String, Boolean> {
            val manager = context.getSystemService(SENSOR_SERVICE) as SensorManager
            return mapOf(
                "accelerometer" to (manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER) != null),
                "gyroscope" to (manager.getDefaultSensor(Sensor.TYPE_GYROSCOPE) != null),
            )
        }

        fun start(
            context: Context,
            token: String,
            baseUrl: String,
            capture: Boolean = true,
        ) {
            context
                .getSharedPreferences(PREFS, MODE_PRIVATE)
                .edit()
                .putString(KEY_TOKEN, token)
                .putString(KEY_BASE_URL, baseUrl)
                .putBoolean(KEY_CAPTURE, capture)
                .apply()
            val intent =
                Intent(context, HarMotionService::class.java).apply {
                    putExtra(EXTRA_TOKEN, token)
                    putExtra(EXTRA_BASE_URL, baseUrl)
                    putExtra(EXTRA_CAPTURE, capture)
                }
            ContextCompat.startForegroundService(context, intent)
        }

        fun startIfConfigured(context: Context) {
            val prefs = context.getSharedPreferences(PREFS, MODE_PRIVATE)
            val token = prefs.getString(KEY_TOKEN, "") ?: ""
            val baseUrl = prefs.getString(KEY_BASE_URL, "") ?: ""
            if (token.isEmpty() || baseUrl.isEmpty()) return
            start(context, token, baseUrl, capture = true)
        }

        fun stop(context: Context) {
            context
                .getSharedPreferences(PREFS, MODE_PRIVATE)
                .edit()
                .remove(KEY_TOKEN)
                .remove(KEY_BASE_URL)
                .remove(KEY_CAPTURE)
                .apply()
            context.stopService(Intent(context, HarMotionService::class.java))
        }
    }
}
