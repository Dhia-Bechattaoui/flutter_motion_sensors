import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_motion_sensors/flutter_motion_sensors.dart';

void main() {
  group('SPM Support Tests', () {
    test('Package should have proper exports', () {
      // Test that main classes are exported
      expect(FlutterMotionSensors, isNotNull);
      expect(MotionSensorController, isNotNull);
      expect(MotionAnimationBuilder, isNotNull);
      expect(AccelerometerData, isNotNull);
      expect(GyroscopeData, isNotNull);
      expect(MagnetometerData, isNotNull);
      expect(MotionSensorData, isNotNull);
    });

    test('Platform interface should be available', () {
      // Test that platform interface is accessible
      expect(FlutterMotionSensorsPlatform.instance, isNotNull);
    });

    test('Sensor types should be defined', () {
      // Test that sensor types are properly defined
      expect(SensorType.values, contains(SensorType.accelerometer));
      expect(SensorType.values, contains(SensorType.gyroscope));
      expect(SensorType.values, contains(SensorType.magnetometer));
    });

    test('Controller should be instantiable', () {
      // Test that controller can be created
      final controller = MotionSensorController();
      expect(controller, isNotNull);
      expect(controller.isListening, isFalse);

      // Clean up
      controller.dispose();
    });
  });
}
