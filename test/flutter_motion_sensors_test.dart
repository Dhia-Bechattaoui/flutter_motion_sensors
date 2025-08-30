import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_motion_sensors/flutter_motion_sensors.dart';

void main() {
  group('flutter_motion_sensors', () {
    testWidgets('AccelerometerBuilder builds correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AccelerometerBuilder(
            builder: (context, data) {
              if (data == null) return const CircularProgressIndicator();
              return Text('Accel: ${data.x}');
            },
          ),
        ),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('GyroscopeBuilder builds correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GyroscopeBuilder(
            builder: (context, data) {
              if (data == null) return const CircularProgressIndicator();
              return Text('Gyro: ${data.x}');
            },
          ),
        ),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('MagnetometerBuilder builds correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MagnetometerBuilder(
            builder: (context, data) {
              if (data == null) return const CircularProgressIndicator();
              return Text('Mag: ${data.x}');
            },
          ),
        ),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('MotionBuilder builds correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MotionBuilder(
            builder: (context, data) {
              if (data == null) return const CircularProgressIndicator();
              return Text('Motion: ${data.timestamp}');
            },
          ),
        ),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('MotionAnimationBuilder with custom sensor types',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MotionAnimationBuilder(
            sensorTypes: const [SensorType.accelerometer, SensorType.gyroscope],
            builder: (context, controller) {
              return Column(
                children: [
                  Text('Accel: ${controller.lastAccelerometerData?.x ?? 0.0}'),
                  Text('Gyro: ${controller.lastGyroscopeData?.x ?? 0.0}'),
                ],
              );
            },
          ),
        ),
      );

      // Should show the text widgets
      expect(find.text('Accel: 0.0'), findsOneWidget);
      expect(find.text('Gyro: 0.0'), findsOneWidget);
    });

    testWidgets('MotionAnimationBuilder with manual control',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MotionAnimationBuilder(
            autoStart: false,
            builder: (context, controller) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () => controller.startListening(),
                    child: const Text('Start Sensors'),
                  ),
                  ElevatedButton(
                    onPressed: () => controller.stopListening(),
                    child: const Text('Stop Sensors'),
                  ),
                  Text('Listening: ${controller.isListening}'),
                ],
              );
            },
          ),
        ),
      );

      // Should show the control buttons and status
      expect(find.text('Start Sensors'), findsOneWidget);
      expect(find.text('Stop Sensors'), findsOneWidget);
      expect(find.text('Listening: false'), findsOneWidget);
    });
  });

  group('Sensor Data Models', () {
    test('AccelerometerData creation and properties', () {
      final now = DateTime.now();
      final data = AccelerometerData(
        x: 1.0,
        y: 2.0,
        z: 3.0,
        timestamp: now,
      );

      expect(data.x, 1.0);
      expect(data.y, 2.0);
      expect(data.z, 3.0);
      expect(data.timestamp, now);
    });

    test('AccelerometerData copyWith', () {
      final now = DateTime.now();
      final data = AccelerometerData(
        x: 1.0,
        y: 2.0,
        z: 3.0,
        timestamp: now,
      );

      final newData = data.copyWith(x: 5.0);
      expect(newData.x, 5.0);
      expect(newData.y, 2.0);
      expect(newData.z, 3.0);
      expect(newData.timestamp, now);
    });

    test('GyroscopeData creation and properties', () {
      final now = DateTime.now();
      final data = GyroscopeData(
        x: 0.1,
        y: 0.2,
        z: 0.3,
        timestamp: now,
      );

      expect(data.x, 0.1);
      expect(data.y, 0.2);
      expect(data.z, 0.3);
      expect(data.timestamp, now);
    });

    test('MagnetometerData creation and properties', () {
      final now = DateTime.now();
      final data = MagnetometerData(
        x: 10.0,
        y: 20.0,
        z: 30.0,
        timestamp: now,
      );

      expect(data.x, 10.0);
      expect(data.y, 20.0);
      expect(data.z, 30.0);
      expect(data.timestamp, now);
    });

    test('MotionSensorData creation and properties', () {
      final now = DateTime.now();
      final accel = AccelerometerData(x: 1.0, y: 2.0, z: 3.0, timestamp: now);
      final gyro = GyroscopeData(x: 0.1, y: 0.2, z: 0.3, timestamp: now);
      final mag = MagnetometerData(x: 10.0, y: 20.0, z: 30.0, timestamp: now);

      final data = MotionSensorData(
        accelerometer: accel,
        gyroscope: gyro,
        magnetometer: mag,
        timestamp: now,
      );

      expect(data.accelerometer, accel);
      expect(data.gyroscope, gyro);
      expect(data.magnetometer, mag);
      expect(data.timestamp, now);
    });
  });

  group('MotionSensorController', () {
    test('Controller creation and initial state', () {
      final controller = MotionSensorController();

      expect(controller.isListening, false);
      expect(controller.lastAccelerometerData, null);
      expect(controller.lastGyroscopeData, null);
      expect(controller.lastMagnetometerData, null);
      expect(controller.lastMotionData, null);
    });

    test('Controller disposal', () {
      final controller = MotionSensorController();
      controller.dispose();
      // Should not throw any errors
    });
  });
}
