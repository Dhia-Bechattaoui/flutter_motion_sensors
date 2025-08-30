import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter/services.dart';
import 'sensor_data.dart';

/// The interface that implementations of flutter_motion_sensors must implement.
///
/// Platform implementations should extend this class rather than implement it as `flutter_motion_sensors`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// methods.
abstract class FlutterMotionSensorsPlatform extends PlatformInterface {
  /// Constructs a FlutterMotionSensorsPlatform.
  FlutterMotionSensorsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMotionSensorsPlatform _instance =
      MethodChannelFlutterMotionSensors();

  /// The default instance of [FlutterMotionSensorsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMotionSensors].
  static FlutterMotionSensorsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMotionSensorsPlatform] when
  /// they register themselves.
  static set instance(FlutterMotionSensorsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Check if the device supports motion sensors
  Future<bool> isMotionSensorAvailable() {
    throw UnimplementedError(
        'isMotionSensorAvailable() has not been implemented.');
  }

  /// Get the current accelerometer data
  Future<AccelerometerData?> getAccelerometerData() {
    throw UnimplementedError(
        'getAccelerometerData() has not been implemented.');
  }

  /// Get the current gyroscope data
  Future<GyroscopeData?> getGyroscopeData() {
    throw UnimplementedError('getGyroscopeData() has not been implemented.');
  }

  /// Get the current magnetometer data
  Future<MagnetometerData?> getMagnetometerData() {
    throw UnimplementedError('getMagnetometerData() has not been implemented.');
  }

  /// Get all available motion sensor data
  Future<MotionSensorData> getAllMotionSensorData() {
    throw UnimplementedError(
        'getAllMotionSensorData() has not been implemented.');
  }

  /// Start listening to accelerometer events
  Stream<AccelerometerData> get accelerometerEvents {
    throw UnimplementedError(
        'accelerometerEvents getter has not been implemented.');
  }

  /// Start listening to gyroscope events
  Stream<GyroscopeData> get gyroscopeEvents {
    throw UnimplementedError(
        'gyroscopeEvents getter has not been implemented.');
  }

  /// Start listening to magnetometer events
  Stream<MagnetometerData> get magnetometerEvents {
    throw UnimplementedError(
        'magnetometerEvents getter has not been implemented.');
  }

  /// Start listening to all motion sensor events
  Stream<MotionSensorData> get motionSensorEvents {
    throw UnimplementedError(
        'motionSensorEvents getter has not been implemented.');
  }
}

/// An implementation of [FlutterMotionSensorsPlatform] that uses method channels.
class MethodChannelFlutterMotionSensors extends FlutterMotionSensorsPlatform {
  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('flutter_motion_sensors');

  @override
  Future<bool> isMotionSensorAvailable() async {
    final bool result =
        await methodChannel.invokeMethod('isMotionSensorAvailable');
    return result;
  }

  @override
  Future<AccelerometerData?> getAccelerometerData() async {
    final Map<dynamic, dynamic>? result =
        await methodChannel.invokeMethod('getAccelerometerData');
    if (result == null) return null;

    return AccelerometerData(
      x: result['x']?.toDouble() ?? 0.0,
      y: result['y']?.toDouble() ?? 0.0,
      z: result['z']?.toDouble() ?? 0.0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(result['timestamp'] ?? 0),
    );
  }

  @override
  Future<GyroscopeData?> getGyroscopeData() async {
    final Map<dynamic, dynamic>? result =
        await methodChannel.invokeMethod('getGyroscopeData');
    if (result == null) return null;

    return GyroscopeData(
      x: result['x']?.toDouble() ?? 0.0,
      y: result['y']?.toDouble() ?? 0.0,
      z: result['z']?.toDouble() ?? 0.0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(result['timestamp'] ?? 0),
    );
  }

  @override
  Future<MagnetometerData?> getMagnetometerData() async {
    final Map<dynamic, dynamic>? result =
        await methodChannel.invokeMethod('getMagnetometerData');
    if (result == null) return null;

    return MagnetometerData(
      x: result['x']?.toDouble() ?? 0.0,
      y: result['y']?.toDouble() ?? 0.0,
      z: result['z']?.toDouble() ?? 0.0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(result['timestamp'] ?? 0),
    );
  }

  @override
  Future<MotionSensorData> getAllMotionSensorData() async {
    final Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('getAllMotionSensorData');

    return MotionSensorData(
      accelerometer: result['accelerometer'] != null
          ? AccelerometerData(
              x: result['accelerometer']['x']?.toDouble() ?? 0.0,
              y: result['accelerometer']['y']?.toDouble() ?? 0.0,
              z: result['accelerometer']['z']?.toDouble() ?? 0.0,
              timestamp: DateTime.fromMillisecondsSinceEpoch(
                  result['accelerometer']['timestamp'] ?? 0),
            )
          : null,
      gyroscope: result['gyroscope'] != null
          ? GyroscopeData(
              x: result['gyroscope']['x']?.toDouble() ?? 0.0,
              y: result['gyroscope']['y']?.toDouble() ?? 0.0,
              z: result['gyroscope']['z']?.toDouble() ?? 0.0,
              timestamp: DateTime.fromMillisecondsSinceEpoch(
                  result['gyroscope']['timestamp'] ?? 0),
            )
          : null,
      magnetometer: result['magnetometer'] != null
          ? MagnetometerData(
              x: result['magnetometer']['x']?.toDouble() ?? 0.0,
              y: result['magnetometer']['y']?.toDouble() ?? 0.0,
              z: result['magnetometer']['z']?.toDouble() ?? 0.0,
              timestamp: DateTime.fromMillisecondsSinceEpoch(
                  result['magnetometer']['timestamp'] ?? 0),
            )
          : null,
      timestamp: DateTime.fromMillisecondsSinceEpoch(result['timestamp'] ?? 0),
    );
  }

  @override
  Stream<AccelerometerData> get accelerometerEvents {
    return const EventChannel('flutter_motion_sensors/accelerometer')
        .receiveBroadcastStream()
        .map((dynamic event) {
      final Map<dynamic, dynamic> data = event as Map<dynamic, dynamic>;
      return AccelerometerData(
        x: data['x']?.toDouble() ?? 0.0,
        y: data['y']?.toDouble() ?? 0.0,
        z: data['z']?.toDouble() ?? 0.0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp'] ?? 0),
      );
    });
  }

  @override
  Stream<GyroscopeData> get gyroscopeEvents {
    return const EventChannel('flutter_motion_sensors/gyroscope')
        .receiveBroadcastStream()
        .map((dynamic event) {
      final Map<dynamic, dynamic> data = event as Map<dynamic, dynamic>;
      return GyroscopeData(
        x: data['x']?.toDouble() ?? 0.0,
        y: data['y']?.toDouble() ?? 0.0,
        z: data['z']?.toDouble() ?? 0.0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp'] ?? 0),
      );
    });
  }

  @override
  Stream<MagnetometerData> get magnetometerEvents {
    return const EventChannel('flutter_motion_sensors/magnetometer')
        .receiveBroadcastStream()
        .map((dynamic event) {
      final Map<dynamic, dynamic> data = event as Map<dynamic, dynamic>;
      return MagnetometerData(
        x: data['x']?.toDouble() ?? 0.0,
        y: data['y']?.toDouble() ?? 0.0,
        z: data['z']?.toDouble() ?? 0.0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp'] ?? 0),
      );
    });
  }

  @override
  Stream<MotionSensorData> get motionSensorEvents {
    return const EventChannel('flutter_motion_sensors/motion')
        .receiveBroadcastStream()
        .map((dynamic event) {
      final Map<dynamic, dynamic> data = event as Map<dynamic, dynamic>;
      return MotionSensorData(
        accelerometer: data['accelerometer'] != null
            ? AccelerometerData(
                x: data['accelerometer']['x']?.toDouble() ?? 0.0,
                y: data['accelerometer']['y']?.toDouble() ?? 0.0,
                z: data['accelerometer']['z']?.toDouble() ?? 0.0,
                timestamp: DateTime.fromMillisecondsSinceEpoch(
                    data['accelerometer']['timestamp'] ?? 0),
              )
            : null,
        gyroscope: data['gyroscope'] != null
            ? GyroscopeData(
                x: data['gyroscope']['x']?.toDouble() ?? 0.0,
                y: data['gyroscope']['y']?.toDouble() ?? 0.0,
                z: data['gyroscope']['z']?.toDouble() ?? 0.0,
                timestamp: DateTime.fromMillisecondsSinceEpoch(
                    data['gyroscope']['timestamp'] ?? 0),
              )
            : null,
        magnetometer: data['magnetometer'] != null
            ? MagnetometerData(
                x: data['magnetometer']['x']?.toDouble() ?? 0.0,
                y: data['magnetometer']['y']?.toDouble() ?? 0.0,
                z: data['magnetometer']['z']?.toDouble() ?? 0.0,
                timestamp: DateTime.fromMillisecondsSinceEpoch(
                    data['magnetometer']['timestamp'] ?? 0),
              )
            : null,
        timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp'] ?? 0),
      );
    });
  }
}
