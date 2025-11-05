import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'sensor_data.dart';
import 'platform_interface.dart';

/// A controller that manages motion sensor data streams and provides
/// convenient access to sensor data.
class MotionSensorController extends ChangeNotifier {
  /// Creates a [MotionSensorController] instance
  MotionSensorController();

  final FlutterMotionSensorsPlatform _platform =
      FlutterMotionSensorsPlatform.instance;

  StreamSubscription<AccelerometerData>? _accelerometerSubscription;
  StreamSubscription<GyroscopeData>? _gyroscopeSubscription;
  StreamSubscription<MagnetometerData>? _magnetometerSubscription;
  StreamSubscription<MotionSensorData>? _motionSubscription;

  AccelerometerData? _lastAccelerometerData;
  GyroscopeData? _lastGyroscopeData;
  MagnetometerData? _lastMagnetometerData;
  MotionSensorData? _lastMotionData;

  bool _isListening = false;

  /// Whether the controller is currently listening to sensor events
  bool get isListening => _isListening;

  /// The most recent accelerometer data
  AccelerometerData? get lastAccelerometerData => _lastAccelerometerData;

  /// The most recent gyroscope data
  GyroscopeData? get lastGyroscopeData => _lastGyroscopeData;

  /// The most recent magnetometer data
  MagnetometerData? get lastMagnetometerData => _lastMagnetometerData;

  /// The most recent combined motion sensor data
  MotionSensorData? get lastMotionData => _lastMotionData;

  /// Check if motion sensors are available on the device
  Future<bool> get isMotionSensorAvailable async {
    return await _platform.isMotionSensorAvailable();
  }

  /// Get the current accelerometer data
  Future<AccelerometerData?> getAccelerometerData() async {
    _lastAccelerometerData = await _platform.getAccelerometerData();
    return _lastAccelerometerData;
  }

  /// Get the current gyroscope data
  Future<GyroscopeData?> getGyroscopeData() async {
    _lastGyroscopeData = await _platform.getGyroscopeData();
    return _lastGyroscopeData;
  }

  /// Get the current magnetometer data
  Future<MagnetometerData?> getMagnetometerData() async {
    _lastMagnetometerData = await _platform.getMagnetometerData();
    return _lastMagnetometerData;
  }

  /// Get all available motion sensor data
  Future<MotionSensorData> getAllMotionSensorData() async {
    _lastMotionData = await _platform.getAllMotionSensorData();
    return _lastMotionData!;
  }

  /// Start listening to accelerometer events
  void startAccelerometerListening() {
    if (_accelerometerSubscription != null) return;

    _accelerometerSubscription = _platform.accelerometerEvents.listen(
      (data) {
        _lastAccelerometerData = data;
        notifyListeners();
      },
      onError: (error) {
        // Ignore cancellation-related errors
        if (error is PlatformException &&
            error.code == 'error' &&
            error.message?.contains('No active stream') == true) {
          return;
        }
        debugPrint('Error listening to accelerometer: $error');
      },
      cancelOnError: false,
    );

    _updateListeningState();
  }

  /// Start listening to gyroscope events
  void startGyroscopeListening() {
    if (_gyroscopeSubscription != null) return;

    _gyroscopeSubscription = _platform.gyroscopeEvents.listen(
      (data) {
        _lastGyroscopeData = data;
        notifyListeners();
      },
      onError: (error) {
        // Ignore cancellation-related errors
        if (error is PlatformException &&
            error.code == 'error' &&
            error.message?.contains('No active stream') == true) {
          return;
        }
        debugPrint('Error listening to gyroscope: $error');
      },
      cancelOnError: false,
    );

    _updateListeningState();
  }

  /// Start listening to magnetometer events
  void startMagnetometerListening() {
    if (_magnetometerSubscription != null) return;

    _magnetometerSubscription = _platform.magnetometerEvents.listen(
      (data) {
        _lastMagnetometerData = data;
        notifyListeners();
      },
      onError: (error) {
        // Ignore cancellation-related errors
        if (error is PlatformException &&
            error.code == 'error' &&
            error.message?.contains('No active stream') == true) {
          return;
        }
        debugPrint('Error listening to magnetometer: $error');
      },
      cancelOnError: false,
    );

    _updateListeningState();
  }

  /// Start listening to all motion sensor events
  void startMotionListening() {
    if (_motionSubscription != null) return;

    _motionSubscription = _platform.motionSensorEvents.listen(
      (data) {
        _lastMotionData = data;
        _lastAccelerometerData = data.accelerometer;
        _lastGyroscopeData = data.gyroscope;
        _lastMagnetometerData = data.magnetometer;
        notifyListeners();
      },
      onError: (error) {
        // Ignore cancellation-related errors
        if (error is PlatformException &&
            error.code == 'error' &&
            error.message?.contains('No active stream') == true) {
          return;
        }
        debugPrint('Error listening to motion sensors: $error');
      },
      cancelOnError: false,
    );

    _updateListeningState();
  }

  /// Start listening to all sensor types
  void startListening() {
    startAccelerometerListening();
    startGyroscopeListening();
    startMagnetometerListening();
    startMotionListening();
  }

  /// Stop listening to accelerometer events
  void stopAccelerometerListening() {
    try {
      _accelerometerSubscription?.cancel();
    } catch (e) {
      // Ignore cancellation errors
    }
    _accelerometerSubscription = null;
    _updateListeningState();
  }

  /// Stop listening to gyroscope events
  void stopGyroscopeListening() {
    try {
      _gyroscopeSubscription?.cancel();
    } catch (e) {
      // Ignore cancellation errors
    }
    _gyroscopeSubscription = null;
    _updateListeningState();
  }

  /// Stop listening to magnetometer events
  void stopMagnetometerListening() {
    try {
      _magnetometerSubscription?.cancel();
    } catch (e) {
      // Ignore cancellation errors
    }
    _magnetometerSubscription = null;
    _updateListeningState();
  }

  /// Stop listening to motion sensor events
  void stopMotionListening() {
    try {
      _motionSubscription?.cancel();
    } catch (e) {
      // Ignore cancellation errors
    }
    _motionSubscription = null;
    _updateListeningState();
  }

  /// Stop listening to all sensor types
  void stopListening() {
    stopAccelerometerListening();
    stopGyroscopeListening();
    stopMagnetometerListening();
    stopMotionListening();
  }

  void _updateListeningState() {
    final wasListening = _isListening;
    _isListening =
        _accelerometerSubscription != null ||
        _gyroscopeSubscription != null ||
        _magnetometerSubscription != null ||
        _motionSubscription != null;

    if (wasListening != _isListening) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
