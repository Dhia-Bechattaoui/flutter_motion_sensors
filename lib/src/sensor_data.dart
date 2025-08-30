/// Represents accelerometer data from device sensors
class AccelerometerData {
  /// Creates an [AccelerometerData] instance
  const AccelerometerData({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  /// Acceleration force along the x axis (including gravity) in m/s²
  final double x;

  /// Acceleration force along the y axis (including gravity) in m/s²
  final double y;

  /// Acceleration force along the z axis (including gravity) in m/s²
  final double z;

  /// Timestamp when the data was captured
  final DateTime timestamp;

  /// Creates a copy of this [AccelerometerData] with the given fields replaced
  AccelerometerData copyWith({
    double? x,
    double? y,
    double? z,
    DateTime? timestamp,
  }) {
    return AccelerometerData(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'AccelerometerData(x: $x, y: $y, z: $z, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccelerometerData &&
        other.x == x &&
        other.y == y &&
        other.z == z &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(x, y, z, timestamp);
  }
}

/// Represents gyroscope data from device sensors
class GyroscopeData {
  /// Creates a [GyroscopeData] instance
  const GyroscopeData({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  /// Angular velocity around the x axis in rad/s
  final double x;

  /// Angular velocity around the y axis in rad/s
  final double y;

  /// Angular velocity around the z axis in rad/s
  final double z;

  /// Timestamp when the data was captured
  final DateTime timestamp;

  /// Creates a copy of this [GyroscopeData] with the given fields replaced
  GyroscopeData copyWith({
    double? x,
    double? y,
    double? z,
    DateTime? timestamp,
  }) {
    return GyroscopeData(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'GyroscopeData(x: $x, y: $y, z: $z, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GyroscopeData &&
        other.x == x &&
        other.y == y &&
        other.z == z &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(x, y, z, timestamp);
  }
}

/// Represents magnetometer data from device sensors
class MagnetometerData {
  /// Creates a [MagnetometerData] instance
  const MagnetometerData({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  /// Magnetic field strength along the x axis in μT
  final double x;

  /// Magnetic field strength along the y axis in μT
  final double y;

  /// Magnetic field strength along the z axis in μT
  final double z;

  /// Timestamp when the data was captured
  final DateTime timestamp;

  /// Creates a copy of this [MagnetometerData] with the given fields replaced
  MagnetometerData copyWith({
    double? x,
    double? y,
    double? z,
    DateTime? timestamp,
  }) {
    return MagnetometerData(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'MagnetometerData(x: $x, y: $y, z: $z, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MagnetometerData &&
        other.x == x &&
        other.y == y &&
        other.z == z &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(x, y, z, timestamp);
  }
}

/// Combined motion sensor data
class MotionSensorData {
  /// Creates a [MotionSensorData] instance
  const MotionSensorData({
    this.accelerometer,
    this.gyroscope,
    this.magnetometer,
    required this.timestamp,
  });

  /// Accelerometer data
  final AccelerometerData? accelerometer;

  /// Gyroscope data
  final GyroscopeData? gyroscope;

  /// Magnetometer data
  final MagnetometerData? magnetometer;

  /// Timestamp when the data was captured
  final DateTime timestamp;

  /// Creates a copy of this [MotionSensorData] with the given fields replaced
  MotionSensorData copyWith({
    AccelerometerData? accelerometer,
    GyroscopeData? gyroscope,
    MagnetometerData? magnetometer,
    DateTime? timestamp,
  }) {
    return MotionSensorData(
      accelerometer: accelerometer ?? this.accelerometer,
      gyroscope: gyroscope ?? this.gyroscope,
      magnetometer: magnetometer ?? this.magnetometer,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'MotionSensorData(accelerometer: $accelerometer, gyroscope: $gyroscope, magnetometer: $magnetometer, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MotionSensorData &&
        other.accelerometer == accelerometer &&
        other.gyroscope == gyroscope &&
        other.magnetometer == magnetometer &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(accelerometer, gyroscope, magnetometer, timestamp);
  }
}
