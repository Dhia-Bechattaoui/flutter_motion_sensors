import 'dart:async';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'src/platform_interface.dart';
import 'src/sensor_data.dart';

/// Web implementation of FlutterMotionSensorsPlatform
class FlutterMotionSensorsWeb extends FlutterMotionSensorsPlatform {
  /// Creates a new instance of FlutterMotionSensorsWeb.
  ///
  /// This constructor initializes the web-specific implementation
  /// for motion sensor access using DeviceMotion API and sensors_plus.
  FlutterMotionSensorsWeb();

  /// Registers this plugin with the Flutter web plugin registrar.
  ///
  /// This method should be called during plugin initialization
  /// to set up the web-specific implementation.
  static void registerWith(Registrar registrar) {
    final instance = FlutterMotionSensorsWeb();
    FlutterMotionSensorsPlatform.instance = instance;
  }

  @override
  Future<bool> isMotionSensorAvailable() async {
    // sensors_plus handles web support
    return true;
  }

  @override
  Future<AccelerometerData?> getAccelerometerData() async {
    try {
      final subscription = accelerometerEventStream().listen((event) {});
      await Future.delayed(const Duration(milliseconds: 100));
      final event = await accelerometerEventStream().first;
      subscription.cancel();

      return AccelerometerData(
        x: event.x,
        y: event.y,
        z: event.z,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<GyroscopeData?> getGyroscopeData() async {
    try {
      final subscription = gyroscopeEventStream().listen((event) {});
      await Future.delayed(const Duration(milliseconds: 100));
      final event = await gyroscopeEventStream().first;
      subscription.cancel();

      return GyroscopeData(
        x: event.x,
        y: event.y,
        z: event.z,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<MagnetometerData?> getMagnetometerData() async {
    try {
      final subscription = magnetometerEventStream().listen((event) {});
      await Future.delayed(const Duration(milliseconds: 100));
      final event = await magnetometerEventStream().first;
      subscription.cancel();

      return MagnetometerData(
        x: event.x,
        y: event.y,
        z: event.z,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<MotionSensorData> getAllMotionSensorData() async {
    final accel = await getAccelerometerData();
    final gyro = await getGyroscopeData();
    final mag = await getMagnetometerData();

    return MotionSensorData(
      accelerometer: accel,
      gyroscope: gyro,
      magnetometer: mag,
      timestamp: DateTime.now(),
    );
  }

  @override
  Stream<AccelerometerData> get accelerometerEvents {
    return accelerometerEventStream().map((event) {
      return AccelerometerData(
        x: event.x,
        y: event.y,
        z: event.z,
        timestamp: DateTime.now(),
      );
    });
  }

  @override
  Stream<GyroscopeData> get gyroscopeEvents {
    return gyroscopeEventStream().map((event) {
      return GyroscopeData(
        x: event.x,
        y: event.y,
        z: event.z,
        timestamp: DateTime.now(),
      );
    });
  }

  @override
  Stream<MagnetometerData> get magnetometerEvents {
    return magnetometerEventStream().map((event) {
      return MagnetometerData(
        x: event.x,
        y: event.y,
        z: event.z,
        timestamp: DateTime.now(),
      );
    });
  }

  @override
  Stream<MotionSensorData> get motionSensorEvents {
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
