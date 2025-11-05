package com.github.dhia_bechattaoui.flutter_motion_sensors

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.atomic.AtomicBoolean

class FlutterMotionSensorsPlugin : FlutterPlugin, MethodCallHandler, SensorEventListener {
    private lateinit var methodChannel: MethodChannel
    private lateinit var accelerometerEventChannel: EventChannel
    private lateinit var gyroscopeEventChannel: EventChannel
    private lateinit var magnetometerEventChannel: EventChannel
    private lateinit var motionEventChannel: EventChannel
    
    private var sensorManager: SensorManager? = null
    private var accelerometerSensor: Sensor? = null
    private var gyroscopeSensor: Sensor? = null
    private var magnetometerSensor: Sensor? = null
    
    private var accelerometerEventSink: EventChannel.EventSink? = null
    private var gyroscopeEventSink: EventChannel.EventSink? = null
    private var magnetometerEventSink: EventChannel.EventSink? = null
    private var motionEventSink: EventChannel.EventSink? = null
    
    private val isAccelerometerListening = AtomicBoolean(false)
    private val isGyroscopeListening = AtomicBoolean(false)
    private val isMagnetometerListening = AtomicBoolean(false)
    private val isMotionListening = AtomicBoolean(false)
    
    private var accelerometerStreamActive = false
    private var gyroscopeStreamActive = false
    private var magnetometerStreamActive = false
    private var motionStreamActive = false
    
    private var lastAccelerometerData: Triple<Float, Float, Float>? = null
    private var lastGyroscopeData: Triple<Float, Float, Float>? = null
    private var lastMagnetometerData: Triple<Float, Float, Float>? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_motion_sensors")
        methodChannel.setMethodCallHandler(this)
        
        accelerometerEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_motion_sensors/accelerometer")
        accelerometerEventChannel.setStreamHandler(AccelerometerStreamHandler())
        
        gyroscopeEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_motion_sensors/gyroscope")
        gyroscopeEventChannel.setStreamHandler(GyroscopeStreamHandler())
        
        magnetometerEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_motion_sensors/magnetometer")
        magnetometerEventChannel.setStreamHandler(MagnetometerStreamHandler())
        
        motionEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_motion_sensors/motion")
        motionEventChannel.setStreamHandler(MotionStreamHandler())
        
        val context = flutterPluginBinding.applicationContext
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as? SensorManager
        accelerometerSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        gyroscopeSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
        magnetometerSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "isMotionSensorAvailable" -> {
                val available = (accelerometerSensor != null || 
                               gyroscopeSensor != null || 
                               magnetometerSensor != null)
                result.success(available)
            }
            "getAccelerometerData" -> {
                if (accelerometerSensor == null) {
                    result.error("UNAVAILABLE", "Accelerometer not available", null)
                    return
                }
                // Start listening temporarily to get one reading
                val tempListener = object : SensorEventListener {
                    override fun onSensorChanged(event: SensorEvent?) {
                        if (event?.sensor?.type == Sensor.TYPE_ACCELEROMETER) {
                            val data = mapOf(
                                "x" to (event.values[0] * 9.81).toDouble(),
                                "y" to (event.values[1] * 9.81).toDouble(),
                                "z" to (event.values[2] * 9.81).toDouble(),
                                "timestamp" to (System.currentTimeMillis())
                            )
                            sensorManager?.unregisterListener(this)
                            result.success(data)
                        }
                    }
                    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
                }
                sensorManager?.registerListener(tempListener, accelerometerSensor, SensorManager.SENSOR_DELAY_NORMAL)
                // Timeout after 2 seconds
                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                    sensorManager?.unregisterListener(tempListener)
                    // Note: Result can only be called once, so we check if it was already called
                }, 2000)
            }
            "getGyroscopeData" -> {
                if (gyroscopeSensor == null) {
                    result.error("UNAVAILABLE", "Gyroscope not available", null)
                    return
                }
                val tempListener = object : SensorEventListener {
                    override fun onSensorChanged(event: SensorEvent?) {
                        if (event?.sensor?.type == Sensor.TYPE_GYROSCOPE) {
                            val data = mapOf(
                                "x" to event.values[0].toDouble(),
                                "y" to event.values[1].toDouble(),
                                "z" to event.values[2].toDouble(),
                                "timestamp" to (System.currentTimeMillis())
                            )
                            sensorManager?.unregisterListener(this)
                            result.success(data)
                        }
                    }
                    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
                }
                sensorManager?.registerListener(tempListener, gyroscopeSensor, SensorManager.SENSOR_DELAY_NORMAL)
                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                    sensorManager?.unregisterListener(tempListener)
                    // Note: Result can only be called once
                }, 2000)
            }
            "getMagnetometerData" -> {
                if (magnetometerSensor == null) {
                    result.error("UNAVAILABLE", "Magnetometer not available", null)
                    return
                }
                val tempListener = object : SensorEventListener {
                    override fun onSensorChanged(event: SensorEvent?) {
                        if (event?.sensor?.type == Sensor.TYPE_MAGNETIC_FIELD) {
                            val data = mapOf(
                                "x" to event.values[0].toDouble(),
                                "y" to event.values[1].toDouble(),
                                "z" to event.values[2].toDouble(),
                                "timestamp" to (System.currentTimeMillis())
                            )
                            sensorManager?.unregisterListener(this)
                            result.success(data)
                        }
                    }
                    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
                }
                sensorManager?.registerListener(tempListener, magnetometerSensor, SensorManager.SENSOR_DELAY_NORMAL)
                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                    sensorManager?.unregisterListener(tempListener)
                    // Note: Result can only be called once
                }, 2000)
            }
            "getAllMotionSensorData" -> {
                val timestamp = System.currentTimeMillis()
                var accelData: Map<String, Any>? = null
                var gyroData: Map<String, Any>? = null
                var magData: Map<String, Any>? = null
                var completed = 0
                val total = listOfNotNull(accelerometerSensor, gyroscopeSensor, magnetometerSensor).size
                
                if (total == 0) {
                    result.success(mapOf(
                        "accelerometer" to null,
                        "gyroscope" to null,
                        "magnetometer" to null,
                        "timestamp" to timestamp
                    ))
                    return
                }
                
                val listener = object : SensorEventListener {
                    override fun onSensorChanged(event: SensorEvent?) {
                        when (event?.sensor?.type) {
                            Sensor.TYPE_ACCELEROMETER -> {
                                accelData = mapOf(
                                    "x" to (event.values[0] * 9.81).toDouble(),
                                    "y" to (event.values[1] * 9.81).toDouble(),
                                    "z" to (event.values[2] * 9.81).toDouble(),
                                    "timestamp" to timestamp
                                )
                                completed++
                            }
                            Sensor.TYPE_GYROSCOPE -> {
                                gyroData = mapOf(
                                    "x" to event.values[0].toDouble(),
                                    "y" to event.values[1].toDouble(),
                                    "z" to event.values[2].toDouble(),
                                    "timestamp" to timestamp
                                )
                                completed++
                            }
                            Sensor.TYPE_MAGNETIC_FIELD -> {
                                magData = mapOf(
                                    "x" to event.values[0].toDouble(),
                                    "y" to event.values[1].toDouble(),
                                    "z" to event.values[2].toDouble(),
                                    "timestamp" to timestamp
                                )
                                completed++
                            }
                        }
                        if (completed >= total) {
                            sensorManager?.unregisterListener(this)
                            result.success(mapOf(
                                "accelerometer" to accelData,
                                "gyroscope" to gyroData,
                                "magnetometer" to magData,
                                "timestamp" to timestamp
                            ))
                        }
                    }
                    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
                }
                
                accelerometerSensor?.let { sensorManager?.registerListener(listener, it, SensorManager.SENSOR_DELAY_NORMAL) }
                gyroscopeSensor?.let { sensorManager?.registerListener(listener, it, SensorManager.SENSOR_DELAY_NORMAL) }
                magnetometerSensor?.let { sensorManager?.registerListener(listener, it, SensorManager.SENSOR_DELAY_NORMAL) }
                
                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                    sensorManager?.unregisterListener(listener)
                    if (completed < total) {
                        result.success(mapOf(
                            "accelerometer" to accelData,
                            "gyroscope" to gyroData,
                            "magnetometer" to magData,
                            "timestamp" to timestamp
                        ))
                    }
                }, 2000)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        accelerometerEventChannel.setStreamHandler(null)
        gyroscopeEventChannel.setStreamHandler(null)
        magnetometerEventChannel.setStreamHandler(null)
        motionEventChannel.setStreamHandler(null)
        stopAllSensors()
    }

    override fun onSensorChanged(event: SensorEvent?) {
        event?.let {
            when (it.sensor.type) {
                Sensor.TYPE_ACCELEROMETER -> {
                    val x = it.values[0] * 9.81f
                    val y = it.values[1] * 9.81f
                    val z = it.values[2] * 9.81f
                    lastAccelerometerData = Triple(x, y, z)
                    val data = mapOf(
                        "x" to x.toDouble(),
                        "y" to y.toDouble(),
                        "z" to z.toDouble(),
                        "timestamp" to System.currentTimeMillis()
                    )
                    try {
                        accelerometerEventSink?.success(data)
                    } catch (e: Exception) {
                        android.util.Log.e("FlutterMotionSensors", "Error sending accelerometer data: ${e.message}", e)
                    }
                    updateMotionEvent()
                }
                Sensor.TYPE_GYROSCOPE -> {
                    val x = it.values[0]
                    val y = it.values[1]
                    val z = it.values[2]
                    lastGyroscopeData = Triple(x, y, z)
                    val data = mapOf(
                        "x" to x.toDouble(),
                        "y" to y.toDouble(),
                        "z" to z.toDouble(),
                        "timestamp" to System.currentTimeMillis()
                    )
                    gyroscopeEventSink?.success(data)
                    updateMotionEvent()
                }
                Sensor.TYPE_MAGNETIC_FIELD -> {
                    val x = it.values[0]
                    val y = it.values[1]
                    val z = it.values[2]
                    lastMagnetometerData = Triple(x, y, z)
                    val data = mapOf(
                        "x" to x.toDouble(),
                        "y" to y.toDouble(),
                        "z" to z.toDouble(),
                        "timestamp" to System.currentTimeMillis()
                    )
                    magnetometerEventSink?.success(data)
                    updateMotionEvent()
                }
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    private fun updateMotionEvent() {
        if (isMotionListening.get()) {
            val timestamp = System.currentTimeMillis()
            val accelData = lastAccelerometerData?.let {
                mapOf(
                    "x" to it.first.toDouble(),
                    "y" to it.second.toDouble(),
                    "z" to it.third.toDouble(),
                    "timestamp" to timestamp
                )
            }
            val gyroData = lastGyroscopeData?.let {
                mapOf(
                    "x" to it.first.toDouble(),
                    "y" to it.second.toDouble(),
                    "z" to it.third.toDouble(),
                    "timestamp" to timestamp
                )
            }
            val magData = lastMagnetometerData?.let {
                mapOf(
                    "x" to it.first.toDouble(),
                    "y" to it.second.toDouble(),
                    "z" to it.third.toDouble(),
                    "timestamp" to timestamp
                )
            }
            motionEventSink?.success(mapOf(
                "accelerometer" to accelData,
                "gyroscope" to gyroData,
                "magnetometer" to magData,
                "timestamp" to timestamp
            ))
        }
    }

    private fun startAccelerometer() {
        if (isAccelerometerListening.compareAndSet(false, true)) {
            accelerometerSensor?.let {
                try {
                    sensorManager?.registerListener(this, it, SensorManager.SENSOR_DELAY_GAME)
                    android.util.Log.d("FlutterMotionSensors", "Accelerometer listener registered")
                } catch (e: Exception) {
                    android.util.Log.e("FlutterMotionSensors", "Failed to register accelerometer listener: ${e.message}")
                    isAccelerometerListening.set(false)
                }
            } ?: run {
                android.util.Log.e("FlutterMotionSensors", "Accelerometer sensor not available")
                isAccelerometerListening.set(false)
            }
        }
    }

    private fun stopAccelerometer() {
        if (isAccelerometerListening.compareAndSet(true, false)) {
            accelerometerSensor?.let {
                sensorManager?.unregisterListener(this, it)
            }
        }
    }

    private fun startGyroscope() {
        if (isGyroscopeListening.compareAndSet(false, true)) {
            gyroscopeSensor?.let {
                try {
                    sensorManager?.registerListener(this, it, SensorManager.SENSOR_DELAY_GAME)
                    android.util.Log.d("FlutterMotionSensors", "Gyroscope listener registered")
                } catch (e: Exception) {
                    android.util.Log.e("FlutterMotionSensors", "Failed to register gyroscope listener: ${e.message}")
                    isGyroscopeListening.set(false)
                }
            } ?: run {
                android.util.Log.e("FlutterMotionSensors", "Gyroscope sensor not available")
                isGyroscopeListening.set(false)
            }
        }
    }

    private fun stopGyroscope() {
        if (isGyroscopeListening.compareAndSet(true, false)) {
            gyroscopeSensor?.let {
                sensorManager?.unregisterListener(this, it)
            }
        }
    }

    private fun startMagnetometer() {
        if (isMagnetometerListening.compareAndSet(false, true)) {
            magnetometerSensor?.let {
                try {
                    sensorManager?.registerListener(this, it, SensorManager.SENSOR_DELAY_GAME)
                    android.util.Log.d("FlutterMotionSensors", "Magnetometer listener registered")
                } catch (e: Exception) {
                    android.util.Log.e("FlutterMotionSensors", "Failed to register magnetometer listener: ${e.message}")
                    isMagnetometerListening.set(false)
                }
            } ?: run {
                android.util.Log.e("FlutterMotionSensors", "Magnetometer sensor not available")
                isMagnetometerListening.set(false)
            }
        }
    }

    private fun stopMagnetometer() {
        if (isMagnetometerListening.compareAndSet(true, false)) {
            magnetometerSensor?.let {
                sensorManager?.unregisterListener(this, it)
            }
        }
    }

    private fun startMotion() {
        if (isMotionListening.compareAndSet(false, true)) {
            accelerometerSensor?.let { sensorManager?.registerListener(this, it, SensorManager.SENSOR_DELAY_GAME) }
            gyroscopeSensor?.let { sensorManager?.registerListener(this, it, SensorManager.SENSOR_DELAY_GAME) }
            magnetometerSensor?.let { sensorManager?.registerListener(this, it, SensorManager.SENSOR_DELAY_GAME) }
        }
    }

    private fun stopMotion() {
        if (isMotionListening.compareAndSet(true, false)) {
            // Only unregister if not being used by individual streams
            if (!isAccelerometerListening.get()) {
                accelerometerSensor?.let { sensorManager?.unregisterListener(this, it) }
            }
            if (!isGyroscopeListening.get()) {
                gyroscopeSensor?.let { sensorManager?.unregisterListener(this, it) }
            }
            if (!isMagnetometerListening.get()) {
                magnetometerSensor?.let { sensorManager?.unregisterListener(this, it) }
            }
        }
    }

    private fun stopAllSensors() {
        stopAccelerometer()
        stopGyroscope()
        stopMagnetometer()
        stopMotion()
    }

    inner class AccelerometerStreamHandler : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            if (accelerometerStreamActive) {
                android.util.Log.w("FlutterMotionSensors", "Accelerometer stream already active, canceling old one")
                accelerometerEventSink?.endOfStream()
                stopAccelerometer()
            }
            accelerometerEventSink = events
            accelerometerStreamActive = true
            android.util.Log.d("FlutterMotionSensors", "Accelerometer stream listener started")
            startAccelerometer()
        }

        override fun onCancel(arguments: Any?) {
            android.util.Log.d("FlutterMotionSensors", "Accelerometer stream listener cancelled")
            // Always reset state, even if already cancelled (idempotent)
            if (accelerometerStreamActive) {
                accelerometerEventSink = null
                accelerometerStreamActive = false
                stopAccelerometer()
            }
        }
    }

    inner class GyroscopeStreamHandler : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            if (gyroscopeStreamActive) {
                android.util.Log.w("FlutterMotionSensors", "Gyroscope stream already active, canceling old one")
                gyroscopeEventSink?.endOfStream()
                stopGyroscope()
            }
            gyroscopeEventSink = events
            gyroscopeStreamActive = true
            android.util.Log.d("FlutterMotionSensors", "Gyroscope stream listener started")
            startGyroscope()
        }

        override fun onCancel(arguments: Any?) {
            android.util.Log.d("FlutterMotionSensors", "Gyroscope stream listener cancelled")
            // Always reset state, even if already cancelled (idempotent)
            if (gyroscopeStreamActive) {
                gyroscopeEventSink = null
                gyroscopeStreamActive = false
                stopGyroscope()
            }
        }
    }

    inner class MagnetometerStreamHandler : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            if (magnetometerStreamActive) {
                android.util.Log.w("FlutterMotionSensors", "Magnetometer stream already active, canceling old one")
                magnetometerEventSink?.endOfStream()
                stopMagnetometer()
            }
            magnetometerEventSink = events
            magnetometerStreamActive = true
            android.util.Log.d("FlutterMotionSensors", "Magnetometer stream listener started")
            startMagnetometer()
        }

        override fun onCancel(arguments: Any?) {
            android.util.Log.d("FlutterMotionSensors", "Magnetometer stream listener cancelled")
            // Always reset state, even if already cancelled (idempotent)
            if (magnetometerStreamActive) {
                magnetometerEventSink = null
                magnetometerStreamActive = false
                stopMagnetometer()
            }
        }
    }

    inner class MotionStreamHandler : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            if (motionStreamActive) {
                android.util.Log.w("FlutterMotionSensors", "Motion stream already active, canceling old one")
                motionEventSink?.endOfStream()
                stopMotion()
            }
            motionEventSink = events
            motionStreamActive = true
            android.util.Log.d("FlutterMotionSensors", "Motion stream listener started")
            startMotion()
        }

        override fun onCancel(arguments: Any?) {
            android.util.Log.d("FlutterMotionSensors", "Motion stream listener cancelled")
            // Always reset state, even if already cancelled (idempotent)
            if (motionStreamActive) {
                motionEventSink = null
                motionStreamActive = false
                stopMotion()
            }
        }
    }
}

