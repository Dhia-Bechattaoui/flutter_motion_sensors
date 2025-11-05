import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:rxdart/rxdart.dart';
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
      'isMotionSensorAvailable() has not been implemented.',
    );
  }

  /// Get the current accelerometer data
  Future<AccelerometerData?> getAccelerometerData() {
    throw UnimplementedError(
      'getAccelerometerData() has not been implemented.',
    );
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
      'getAllMotionSensorData() has not been implemented.',
    );
  }

  /// Start listening to accelerometer events
  Stream<AccelerometerData> get accelerometerEvents {
    throw UnimplementedError(
      'accelerometerEvents getter has not been implemented.',
    );
  }

  /// Start listening to gyroscope events
  Stream<GyroscopeData> get gyroscopeEvents {
    throw UnimplementedError(
      'gyroscopeEvents getter has not been implemented.',
    );
  }

  /// Start listening to magnetometer events
  Stream<MagnetometerData> get magnetometerEvents {
    throw UnimplementedError(
      'magnetometerEvents getter has not been implemented.',
    );
  }

  /// Start listening to all motion sensor events
  Stream<MotionSensorData> get motionSensorEvents {
    throw UnimplementedError(
      'motionSensorEvents getter has not been implemented.',
    );
  }
}

/// An implementation of [FlutterMotionSensorsPlatform] that uses method channels.
class MethodChannelFlutterMotionSensors extends FlutterMotionSensorsPlatform {
  /// Creates a new instance of MethodChannelFlutterMotionSensors.
  ///
  /// This constructor initializes the method channel implementation
  /// for communicating with native platform code.
  MethodChannelFlutterMotionSensors();

  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('flutter_motion_sensors');

  @override
  Future<bool> isMotionSensorAvailable() async {
    try {
      final bool result = await methodChannel.invokeMethod(
        'isMotionSensorAvailable',
      );
      return result;
    } on PlatformException {
      // Fallback: sensors_plus is available on all platforms
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AccelerometerData?> getAccelerometerData() async {
    try {
      final Map<dynamic, dynamic>? result = await methodChannel.invokeMethod(
        'getAccelerometerData',
      );
      if (result == null) throw PlatformException(code: 'NULL_RESULT');

      return AccelerometerData(
        x: result['x']?.toDouble() ?? 0.0,
        y: result['y']?.toDouble() ?? 0.0,
        z: result['z']?.toDouble() ?? 0.0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          result['timestamp'] ?? 0,
        ),
      );
    } on PlatformException {
      // Fallback to sensors_plus
      try {
        final event = await accelerometerEventStream().first;
        return AccelerometerData(
          x: event.x,
          y: event.y,
          z: event.z,
          timestamp: DateTime.now(),
        );
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<GyroscopeData?> getGyroscopeData() async {
    try {
      final Map<dynamic, dynamic>? result = await methodChannel.invokeMethod(
        'getGyroscopeData',
      );
      if (result == null) throw PlatformException(code: 'NULL_RESULT');

      return GyroscopeData(
        x: result['x']?.toDouble() ?? 0.0,
        y: result['y']?.toDouble() ?? 0.0,
        z: result['z']?.toDouble() ?? 0.0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          result['timestamp'] ?? 0,
        ),
      );
    } on PlatformException {
      // Fallback to sensors_plus
      try {
        final event = await gyroscopeEventStream().first;
        return GyroscopeData(
          x: event.x,
          y: event.y,
          z: event.z,
          timestamp: DateTime.now(),
        );
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<MagnetometerData?> getMagnetometerData() async {
    try {
      final Map<dynamic, dynamic>? result = await methodChannel.invokeMethod(
        'getMagnetometerData',
      );
      if (result == null) throw PlatformException(code: 'NULL_RESULT');

      return MagnetometerData(
        x: result['x']?.toDouble() ?? 0.0,
        y: result['y']?.toDouble() ?? 0.0,
        z: result['z']?.toDouble() ?? 0.0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          result['timestamp'] ?? 0,
        ),
      );
    } on PlatformException {
      // Fallback to sensors_plus
      try {
        final event = await magnetometerEventStream().first;
        return MagnetometerData(
          x: event.x,
          y: event.y,
          z: event.z,
          timestamp: DateTime.now(),
        );
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<MotionSensorData> getAllMotionSensorData() async {
    try {
      final Map<dynamic, dynamic> result = await methodChannel.invokeMethod(
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
      // Fallback to sensors_plus
      try {
        final accel = await getAccelerometerData();
        final gyro = await getGyroscopeData();
        final mag = await getMagnetometerData();
        return MotionSensorData(
          accelerometer: accel,
          gyroscope: gyro,
          magnetometer: mag,
          timestamp: DateTime.now(),
        );
      } catch (e) {
        return MotionSensorData(
          accelerometer: null,
          gyroscope: null,
          magnetometer: null,
          timestamp: DateTime.now(),
        );
      }
    } catch (e) {
      return MotionSensorData(
        accelerometer: null,
        gyroscope: null,
        magnetometer: null,
        timestamp: DateTime.now(),
      );
    }
  }

  @override
  Stream<AccelerometerData> get accelerometerEvents {
    try {
      return const EventChannel('flutter_motion_sensors/accelerometer')
          .receiveBroadcastStream()
          .handleError((error) {
            // Ignore cancellation errors when switching tabs
            if (error is PlatformException &&
                error.code == 'error' &&
                error.message?.contains('No active stream') == true) {
              return;
            }
            // Re-throw other errors
            throw error;
          }, test: (error) => error is PlatformException)
          .map((dynamic event) {
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
    } catch (e) {
      // Fallback to sensors_plus
      return accelerometerEventStream().map((event) {
        return AccelerometerData(
          x: event.x,
          y: event.y,
          z: event.z,
          timestamp: DateTime.now(),
        );
      });
    }
  }

  @override
  Stream<GyroscopeData> get gyroscopeEvents {
    try {
      return const EventChannel('flutter_motion_sensors/gyroscope')
          .receiveBroadcastStream()
          .handleError((error) {
            // Ignore cancellation errors when switching tabs
            if (error is PlatformException &&
                error.code == 'error' &&
                error.message?.contains('No active stream') == true) {
              return;
            }
            // Re-throw other errors
            throw error;
          }, test: (error) => error is PlatformException)
          .map((dynamic event) {
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
    } catch (e) {
      // Fallback to sensors_plus
      return gyroscopeEventStream().map((event) {
        return GyroscopeData(
          x: event.x,
          y: event.y,
          z: event.z,
          timestamp: DateTime.now(),
        );
      });
    }
  }

  @override
  Stream<MagnetometerData> get magnetometerEvents {
    try {
      return const EventChannel('flutter_motion_sensors/magnetometer')
          .receiveBroadcastStream()
          .handleError((error) {
            // Ignore cancellation errors when switching tabs
            if (error is PlatformException &&
                error.code == 'error' &&
                error.message?.contains('No active stream') == true) {
              return;
            }
            // Re-throw other errors
            throw error;
          }, test: (error) => error is PlatformException)
          .map((dynamic event) {
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
    } catch (e) {
      // Fallback to sensors_plus
      return magnetometerEventStream().map((event) {
        return MagnetometerData(
          x: event.x,
          y: event.y,
          z: event.z,
          timestamp: DateTime.now(),
        );
      });
    }
  }

  @override
  Stream<MotionSensorData> get motionSensorEvents {
    try {
      return const EventChannel('flutter_motion_sensors/motion')
          .receiveBroadcastStream()
          .handleError((error) {
            // Ignore cancellation errors when switching tabs
            if (error is PlatformException &&
                error.code == 'error' &&
                error.message?.contains('No active stream') == true) {
              return;
            }
            // Re-throw other errors
            throw error;
          }, test: (error) => error is PlatformException)
          .map((dynamic event) {
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
    } catch (e) {
      // Fallback to sensors_plus
      return CombineLatestStream.combine3(
        accelerometerEventStream(),
        gyroscopeEventStream(),
        magnetometerEventStream(),
        (accel, gyro, mag) {
          final timestamp = DateTime.now();
          return MotionSensorData(
            accelerometer: AccelerometerData(
              x: accel.x,
              y: accel.y,
              z: accel.z,
              timestamp: timestamp,
            ),
            gyroscope: GyroscopeData(
              x: gyro.x,
              y: gyro.y,
              z: gyro.z,
              timestamp: timestamp,
            ),
            magnetometer: MagnetometerData(
              x: mag.x,
              y: mag.y,
              z: mag.z,
              timestamp: timestamp,
            ),
            timestamp: timestamp,
          );
        },
      );
    }
  }
}
