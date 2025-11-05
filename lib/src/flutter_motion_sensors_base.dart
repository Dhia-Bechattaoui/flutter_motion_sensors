import 'package:flutter/services.dart';
import 'sensor_data.dart';
import 'platform_interface.dart';

/// Main class for accessing motion sensor functionality
///
/// This class provides static methods to access motion sensor data
/// including accelerometer, gyroscope, and magnetometer readings.
class FlutterMotionSensors {
  /// Creates a new instance of FlutterMotionSensors.
  ///
  /// Note: This class is primarily used for static method calls.
  /// Instantiating it directly is not necessary.
  FlutterMotionSensors();

  static const MethodChannel _channel = MethodChannel('flutter_motion_sensors');

  /// Check if motion sensors are available on the device
  static Future<bool> isMotionSensorAvailable() async {
    try {
      final bool result = await _channel.invokeMethod(
        'isMotionSensorAvailable',
      );
      return result;
    } on PlatformException {
      // Fallback to platform interface if method channel fails
      return FlutterMotionSensorsPlatform.instance.isMotionSensorAvailable();
    }
  }

  /// Get the current accelerometer data
  static Future<AccelerometerData?> getAccelerometerData() async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
        'getAccelerometerData',
      );
      if (result == null) return null;

      return AccelerometerData(
        x: result['x']?.toDouble() ?? 0.0,
        y: result['y']?.toDouble() ?? 0.0,
        z: result['z']?.toDouble() ?? 0.0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          result['timestamp'] ?? 0,
        ),
      );
    } on PlatformException {
      // Fallback to platform interface if method channel fails
      return FlutterMotionSensorsPlatform.instance.getAccelerometerData();
    }
  }

  /// Get the current gyroscope data
  static Future<GyroscopeData?> getGyroscopeData() async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
        'getGyroscopeData',
      );
      if (result == null) return null;

      return GyroscopeData(
        x: result['x']?.toDouble() ?? 0.0,
        y: result['y']?.toDouble() ?? 0.0,
        z: result['z']?.toDouble() ?? 0.0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          result['timestamp'] ?? 0,
        ),
      );
    } on PlatformException {
      // Fallback to platform interface if method channel fails
      return FlutterMotionSensorsPlatform.instance.getGyroscopeData();
    }
  }

  /// Get the current magnetometer data
  static Future<MagnetometerData?> getMagnetometerData() async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
        'getMagnetometerData',
      );
      if (result == null) return null;

      return MagnetometerData(
        x: result['x']?.toDouble() ?? 0.0,
        y: result['y']?.toDouble() ?? 0.0,
        z: result['z']?.toDouble() ?? 0.0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          result['timestamp'] ?? 0,
        ),
      );
    } on PlatformException {
      // Fallback to platform interface if method_channel fails
      return FlutterMotionSensorsPlatform.instance.getMagnetometerData();
    }
  }

  /// Get all available motion sensor data
  static Future<MotionSensorData> getAllMotionSensorData() async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod(
        'getAllMotionSensorData',
      );

      return MotionSensorData(
        accelerometer: result['accelerometer'] != null
            ? AccelerometerData(
                x: result['accelerometer']['x']?.toDouble() ?? 0.0,
                y: result['accelerometer']['y']?.toDouble() ?? 0.0,
                z: result['accelerometer']['z']?.toDouble() ?? 0.0,
                timestamp: DateTime.fromMillisecondsSinceEpoch(
                  result['accelerometer']['timestamp'] ?? 0,
                ),
              )
            : null,
        gyroscope: result['gyroscope'] != null
            ? GyroscopeData(
                x: result['gyroscope']['x']?.toDouble() ?? 0.0,
                y: result['gyroscope']['y']?.toDouble() ?? 0.0,
                z: result['gyroscope']['z']?.toDouble() ?? 0.0,
                timestamp: DateTime.fromMillisecondsSinceEpoch(
                  result['gyroscope']['timestamp'] ?? 0,
                ),
              )
            : null,
        magnetometer: result['magnetometer'] != null
            ? MagnetometerData(
                x: result['magnetometer']['x']?.toDouble() ?? 0.0,
                y: result['magnetometer']['y']?.toDouble() ?? 0.0,
                z: result['magnetometer']['z']?.toDouble() ?? 0.0,
                timestamp: DateTime.fromMillisecondsSinceEpoch(
                  result['magnetometer']['timestamp'] ?? 0,
                ),
              )
            : null,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          result['timestamp'] ?? 0,
        ),
      );
    } on PlatformException {
      // Fallback to platform interface if method channel fails
      return FlutterMotionSensorsPlatform.instance.getAllMotionSensorData();
    }
  }

  /// Get accelerometer events stream
  static Stream<AccelerometerData> get accelerometerEvents {
    try {
      return const EventChannel(
        'flutter_motion_sensors/accelerometer',
      ).receiveBroadcastStream().map((dynamic event) {
        final Map<dynamic, dynamic> data = event as Map<dynamic, dynamic>;
        return AccelerometerData(
          x: data['x']?.toDouble() ?? 0.0,
          y: data['y']?.toDouble() ?? 0.0,
          z: data['z']?.toDouble() ?? 0.0,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            data['timestamp'] ?? 0,
          ),
        );
      });
    } catch (_) {
      // Fallback to platform interface if event channel fails
      return FlutterMotionSensorsPlatform.instance.accelerometerEvents;
    }
  }

  /// Get gyroscope events stream
  static Stream<GyroscopeData> get gyroscopeEvents {
    try {
      return const EventChannel(
        'flutter_motion_sensors/gyroscope',
      ).receiveBroadcastStream().map((dynamic event) {
        final Map<dynamic, dynamic> data = event as Map<dynamic, dynamic>;
        return GyroscopeData(
          x: data['x']?.toDouble() ?? 0.0,
          y: data['y']?.toDouble() ?? 0.0,
          z: data['z']?.toDouble() ?? 0.0,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            data['timestamp'] ?? 0,
          ),
        );
      });
    } catch (_) {
      // Fallback to platform interface if event channel fails
      return FlutterMotionSensorsPlatform.instance.gyroscopeEvents;
    }
  }

  /// Get magnetometer events stream
  static Stream<MagnetometerData> get magnetometerEvents {
    try {
      return const EventChannel(
        'flutter_motion_sensors/magnetometer',
      ).receiveBroadcastStream().map((dynamic event) {
        final Map<dynamic, dynamic> data = event as Map<dynamic, dynamic>;
        return MagnetometerData(
          x: data['x']?.toDouble() ?? 0.0,
          y: data['y']?.toDouble() ?? 0.0,
          z: data['z']?.toDouble() ?? 0.0,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            data['timestamp'] ?? 0,
          ),
        );
      });
    } catch (_) {
      // Fallback to platform interface if event channel fails
      return FlutterMotionSensorsPlatform.instance.magnetometerEvents;
    }
  }

  /// Get motion sensor events stream
  static Stream<MotionSensorData> get motionSensorEvents {
    try {
      return const EventChannel(
        'flutter_motion_sensors/motion',
      ).receiveBroadcastStream().map((dynamic event) {
        final Map<dynamic, dynamic> data = event as Map<dynamic, dynamic>;
        return MotionSensorData(
          accelerometer: data['accelerometer'] != null
              ? AccelerometerData(
                  x: data['accelerometer']['x']?.toDouble() ?? 0.0,
                  y: data['accelerometer']['y']?.toDouble() ?? 0.0,
                  z: data['accelerometer']['z']?.toDouble() ?? 0.0,
                  timestamp: DateTime.fromMillisecondsSinceEpoch(
                    data['accelerometer']['timestamp'] ?? 0,
                  ),
                )
              : null,
          gyroscope: data['gyroscope'] != null
              ? GyroscopeData(
                  x: data['gyroscope']['x']?.toDouble() ?? 0.0,
                  y: data['gyroscope']['y']?.toDouble() ?? 0.0,
                  z: data['gyroscope']['z']?.toDouble() ?? 0.0,
                  timestamp: DateTime.fromMillisecondsSinceEpoch(
                    data['gyroscope']['timestamp'] ?? 0,
                  ),
                )
              : null,
          magnetometer: data['magnetometer'] != null
              ? MagnetometerData(
                  x: data['magnetometer']['x']?.toDouble() ?? 0.0,
                  y: data['magnetometer']['y']?.toDouble() ?? 0.0,
                  z: data['magnetometer']['z']?.toDouble() ?? 0.0,
                  timestamp: DateTime.fromMillisecondsSinceEpoch(
                    data['magnetometer']['timestamp'] ?? 0,
                  ),
                )
              : null,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            data['timestamp'] ?? 0,
          ),
        );
      });
    } catch (_) {
      // Fallback to platform interface if event channel fails
      return FlutterMotionSensorsPlatform.instance.motionSensorEvents;
    }
  }
}
