# flutter_motion_sensors

[![pub package](https://img.shields.io/pub/v/flutter_motion_sensors.svg)](https://pub.dev/packages/flutter_motion_sensors)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Device motion and orientation-based animations for Flutter. Supports iOS, Android, Web, Windows, macOS, and Linux with WASM compatibility. **Full Swift Package Manager (SPM) support for iOS and macOS.**

## Example

<img src="https://github.com/dhia_bechattaoui/flutter_motion_sensors/blob/main/assets/example.gif?raw=true" width="300" alt="Example GIF">

## Features

- 🌍 **Cross-platform support**: iOS, Android, Web, Windows, macOS, Linux
- 🚀 **WASM compatible**: Optimized for web performance
- 📱 **Motion sensors**: Accelerometer, Gyroscope, Magnetometer
- 🎨 **Easy integration**: Simple widgets and controllers
- ⚡ **Real-time data**: Stream-based sensor data
- 🛡️ **Fallback support**: Graceful degradation when sensors unavailable
- 🍎 **Native SPM support**: Full Swift Package Manager integration for iOS/macOS

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_motion_sensors: ^0.1.0
```

### Basic Usage

#### Simple Sensor Data Access

```dart
import 'package:flutter_motion_sensors/flutter_motion_sensors.dart';

// Check if sensors are available
bool available = await FlutterMotionSensors.isMotionSensorAvailable();

// Get current sensor data
AccelerometerData? accel = await FlutterMotionSensors.getAccelerometerData();
GyroscopeData? gyro = await FlutterMotionSensors.getGyroscopeData();
MagnetometerData? mag = await FlutterMotionSensors.getMagnetometerData();

// Get all sensor data at once
MotionSensorData allData = await FlutterMotionSensors.getAllMotionSensorData();
```

#### Stream-based Sensor Listening

```dart
// Listen to accelerometer events
FlutterMotionSensors.accelerometerEvents.listen((data) {
  print('Accelerometer: x=${data.x}, y=${data.y}, z=${data.z}');
});

// Listen to gyroscope events
FlutterMotionSensors.gyroscopeEvents.listen((data) {
  print('Gyroscope: x=${data.x}, y=${data.y}, z=${data.z}');
});

// Listen to all motion sensor events
FlutterMotionSensors.motionSensorEvents.listen((data) {
  print('Motion: ${data.timestamp}');
});
```

#### Using the Controller

```dart
class _MyWidgetState extends State<MyWidget> {
  late MotionSensorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MotionSensorController();
    _controller.startListening();
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
        final accel = _controller.lastAccelerometerData;
        return Text('Acceleration: ${accel?.x ?? 0.0}');
      },
    );
  }
}
```

#### Using Builder Widgets

```dart
// Accelerometer-based animation
AccelerometerBuilder(
  builder: (context, data) {
    if (data == null) return CircularProgressIndicator();
    
    return Transform.rotate(
      angle: data.x * 0.1,
      child: Container(
        width: 100,
        height: 100,
        color: Colors.blue,
      ),
    );
  },
)

// Gyroscope-based animation
GyroscopeBuilder(
  builder: (context, data) {
    if (data == null) return CircularProgressIndicator();
    
    return Transform.translate(
      offset: Offset(data.x * 10, data.y * 10),
      child: Container(
        width: 50,
        height: 50,
        color: Colors.red,
      ),
    );
  },
)

// Combined motion sensor animation
MotionBuilder(
  builder: (context, data) {
    if (data == null) return CircularProgressIndicator();
    
    return Transform(
      transform: Matrix4.identity()
        ..rotateX(data.gyroscope?.x ?? 0.0)
        ..rotateY(data.gyroscope?.y ?? 0.0)
        ..rotateZ(data.gyroscope?.z ?? 0.0),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.orange],
          ),
        ),
      ),
    );
  },
)
```

## Advanced Usage

### Custom Sensor Types

```dart
MotionAnimationBuilder(
  sensorTypes: [SensorType.accelerometer, SensorType.gyroscope],
  builder: (context, controller) {
    return Column(
      children: [
        Text('Accel: ${controller.lastAccelerometerData?.x ?? 0.0}'),
        Text('Gyro: ${controller.lastGyroscopeData?.x ?? 0.0}'),
      ],
    );
  },
)
```

### Manual Control

```dart
MotionAnimationBuilder(
  autoStart: false,
  builder: (context, controller) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => controller.startListening(),
          child: Text('Start Sensors'),
        ),
        ElevatedButton(
          onPressed: () => controller.stopListening(),
          child: Text('Stop Sensors'),
        ),
        Text('Listening: ${controller.isListening}'),
      ],
    );
  },
)
```

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| iOS | ✅ Supported | Uses CoreMotion framework, SPM compatible |
| Android | ✅ Supported | Uses Android sensors |
| Web | ✅ Supported | WASM compatible, uses DeviceMotion API |
| Windows | ✅ Supported | Uses Windows sensors |
| macOS | ✅ Supported | Uses CoreMotion framework, SPM compatible |
| Linux | ✅ Supported | Uses Linux sensors |

## Data Models

### AccelerometerData
- `x`, `y`, `z`: Acceleration forces in m/s²
- `timestamp`: When the data was captured

### GyroscopeData
- `x`, `y`, `z`: Angular velocities in rad/s
- `timestamp`: When the data was captured

### MagnetometerData
- `x`, `y`, `z`: Magnetic field strength in μT
- `timestamp`: When the data was captured

### MotionSensorData
- `accelerometer`: Optional accelerometer data
- `gyroscope`: Optional gyroscope data
- `magnetometer`: Optional magnetometer data
- `timestamp`: When the data was captured

## Permissions

### Android
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.HIGH_SAMPLING_RATE_SENSORS" />
```

### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>NSMotionUsageDescription</key>
<string>This app uses motion sensors for interactive animations.</string>
```

### macOS
Add to `macos/Runner/Info.plist`:
```xml
<key>NSMotionUsageDescription</key>
<string>This app uses motion sensors for interactive animations.</string>
```

## Swift Package Manager (SPM) Support

This package provides full Swift Package Manager support for iOS and macOS platforms. The native implementations use CoreMotion framework for optimal performance and battery efficiency.

### Features
- **Native CoreMotion integration** for iOS and macOS
- **Real-time motion data** at 60Hz update rate
- **Automatic permission handling** for motion sensors
- **Swift 5.0+ compatibility** with modern iOS/macOS versions

### Usage in Swift Projects
You can use this package directly in Swift projects by adding it as a dependency:

```swift
dependencies: [
    .package(url: "https://github.com/Dhia-Bechattaoui/flutter_motion_sensors.git", from: "0.0.2")
]
```

For more details about SPM support, see [SPM_README.md](SPM_README.md).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with Flutter
- Uses [sensors_plus](https://pub.dev/packages/sensors_plus) for sensor data
- Follows Flutter plugin best practices
