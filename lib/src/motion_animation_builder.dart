import 'package:flutter/material.dart';
import 'motion_sensor_controller.dart';
import 'sensor_data.dart';

/// A widget that builds its child based on motion sensor data.
///
/// This widget automatically manages the motion sensor controller lifecycle
/// and provides the latest sensor data to the builder function.
class MotionAnimationBuilder extends StatefulWidget {
  /// Creates a [MotionAnimationBuilder]
  const MotionAnimationBuilder({
    super.key,
    required this.builder,
    this.accelerometerBuilder,
    this.gyroscopeBuilder,
    this.magnetometerBuilder,
    this.motionBuilder,
    this.autoStart = true,
    this.sensorTypes = const [SensorType.accelerometer],
  });

  /// Builder function that receives the motion sensor controller
  final Widget Function(BuildContext context, MotionSensorController controller)
  builder;

  /// Builder function specifically for accelerometer data
  final Widget Function(BuildContext context, AccelerometerData? data)?
  accelerometerBuilder;

  /// Builder function specifically for gyroscope data
  final Widget Function(BuildContext context, GyroscopeData? data)?
  gyroscopeBuilder;

  /// Builder function specifically for magnetometer data
  final Widget Function(BuildContext context, MagnetometerData? data)?
  magnetometerBuilder;

  /// Builder function for combined motion sensor data
  final Widget Function(BuildContext context, MotionSensorData? data)?
  motionBuilder;

  /// Whether to automatically start listening to sensors
  final bool autoStart;

  /// Types of sensors to listen to
  final List<SensorType> sensorTypes;

  @override
  State<MotionAnimationBuilder> createState() => _MotionAnimationBuilderState();
}

class _MotionAnimationBuilderState extends State<MotionAnimationBuilder> {
  late MotionSensorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MotionSensorController();

    if (widget.autoStart) {
      _startListening();
    }
  }

  void _startListening() {
    if (widget.sensorTypes.contains(SensorType.accelerometer)) {
      _controller.startAccelerometerListening();
    }
    if (widget.sensorTypes.contains(SensorType.gyroscope)) {
      _controller.startGyroscopeListening();
    }
    if (widget.sensorTypes.contains(SensorType.magnetometer)) {
      _controller.startMagnetometerListening();
    }
    if (widget.sensorTypes.contains(SensorType.motion)) {
      _controller.startMotionListening();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        // Use specific builders if provided
        if (widget.accelerometerBuilder != null &&
            widget.sensorTypes.contains(SensorType.accelerometer)) {
          return widget.accelerometerBuilder!(
            context,
            _controller.lastAccelerometerData,
          );
        }

        if (widget.gyroscopeBuilder != null &&
            widget.sensorTypes.contains(SensorType.gyroscope)) {
          return widget.gyroscopeBuilder!(
            context,
            _controller.lastGyroscopeData,
          );
        }

        if (widget.magnetometerBuilder != null &&
            widget.sensorTypes.contains(SensorType.magnetometer)) {
          return widget.magnetometerBuilder!(
            context,
            _controller.lastMagnetometerData,
          );
        }

        if (widget.motionBuilder != null &&
            widget.sensorTypes.contains(SensorType.motion)) {
          return widget.motionBuilder!(context, _controller.lastMotionData);
        }

        // Default to the main builder
        return widget.builder(context, _controller);
      },
    );
  }
}

/// Types of motion sensors
enum SensorType {
  /// Accelerometer sensor
  accelerometer,

  /// Gyroscope sensor
  gyroscope,

  /// Magnetometer sensor
  magnetometer,

  /// Combined motion sensors
  motion,
}

/// A widget that builds its child based on accelerometer data
class AccelerometerBuilder extends StatelessWidget {
  /// Creates an [AccelerometerBuilder]
  const AccelerometerBuilder({
    super.key,
    required this.builder,
    this.autoStart = true,
  });

  /// Builder function that receives accelerometer data
  final Widget Function(BuildContext context, AccelerometerData? data) builder;

  /// Whether to automatically start listening to accelerometer
  final bool autoStart;

  @override
  Widget build(BuildContext context) {
    return MotionAnimationBuilder(
      autoStart: autoStart,
      sensorTypes: const [SensorType.accelerometer],
      builder: (context, controller) {
        return builder(context, controller.lastAccelerometerData);
      },
    );
  }
}

/// A widget that builds its child based on gyroscope data
class GyroscopeBuilder extends StatelessWidget {
  /// Creates a [GyroscopeBuilder]
  const GyroscopeBuilder({
    super.key,
    required this.builder,
    this.autoStart = true,
  });

  /// Builder function that receives gyroscope data
  final Widget Function(BuildContext context, GyroscopeData? data) builder;

  /// Whether to automatically start listening to gyroscope
  final bool autoStart;

  @override
  Widget build(BuildContext context) {
    return MotionAnimationBuilder(
      autoStart: autoStart,
      sensorTypes: const [SensorType.gyroscope],
      builder: (context, controller) {
        return builder(context, controller.lastGyroscopeData);
      },
    );
  }
}

/// A widget that builds its child based on magnetometer data
class MagnetometerBuilder extends StatelessWidget {
  /// Creates a [MagnetometerBuilder]
  const MagnetometerBuilder({
    super.key,
    required this.builder,
    this.autoStart = true,
  });

  /// Builder function that receives magnetometer data
  final Widget Function(BuildContext context, MagnetometerData? data) builder;

  /// Whether to automatically start listening to magnetometer
  final bool autoStart;

  @override
  Widget build(BuildContext context) {
    return MotionAnimationBuilder(
      autoStart: autoStart,
      sensorTypes: const [SensorType.magnetometer],
      builder: (context, controller) {
        return builder(context, controller.lastMagnetometerData);
      },
    );
  }
}

/// A widget that builds its child based on combined motion sensor data
class MotionBuilder extends StatelessWidget {
  /// Creates a [MotionBuilder]
  const MotionBuilder({
    super.key,
    required this.builder,
    this.autoStart = true,
  });

  /// Builder function that receives combined motion sensor data
  final Widget Function(BuildContext context, MotionSensorData? data) builder;

  /// Whether to automatically start listening to motion sensors
  final bool autoStart;

  @override
  Widget build(BuildContext context) {
    return MotionAnimationBuilder(
      autoStart: autoStart,
      sensorTypes: const [SensorType.motion],
      builder: (context, controller) {
        return builder(context, controller.lastMotionData);
      },
    );
  }
}
