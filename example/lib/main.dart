import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_motion_sensors/flutter_motion_sensors.dart';

void main() {
  // Suppress EventChannel cancellation errors
  FlutterError.onError = (FlutterErrorDetails details) {
    // Suppress "No active stream to cancel" errors from EventChannel
    if (details.exception is PlatformException) {
      final error = details.exception as PlatformException;
      if (error.code == 'error' &&
          error.message?.contains('No active stream to cancel') == true) {
        // Silently ignore this error
        return;
      }
    }
    // Pass other errors to the default handler
    FlutterError.presentError(details);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Motion Sensors Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MotionSensorsDemo(),
    );
  }
}

class MotionSensorsDemo extends StatefulWidget {
  const MotionSensorsDemo({super.key});

  @override
  State<MotionSensorsDemo> createState() => _MotionSensorsDemoState();
}

class _MotionSensorsDemoState extends State<MotionSensorsDemo> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const OverviewDemo(),
    const SimpleAccessDemo(),
    const BuilderWidgetsDemo(),
    const CustomSensorTypesDemo(),
    const ManualControlDemo(),
    const StreamDemo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Motion Sensors'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.touch_app_outlined),
            selectedIcon: Icon(Icons.touch_app),
            label: 'Simple Access',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined),
            selectedIcon: Icon(Icons.widgets),
            label: 'Builders',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Custom',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Manual',
          ),
          NavigationDestination(
            icon: Icon(Icons.stream_outlined),
            selectedIcon: Icon(Icons.stream),
            label: 'Streams',
          ),
        ],
      ),
    );
  }
}

// Overview Page - Shows sensor availability and basic info
class OverviewDemo extends StatefulWidget {
  const OverviewDemo({super.key});

  @override
  State<OverviewDemo> createState() => _OverviewDemoState();
}

class _OverviewDemoState extends State<OverviewDemo> {
  bool? _sensorsAvailable;
  MotionSensorData? _latestData;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
    _loadLatestData();
  }

  Future<void> _checkAvailability() async {
    final available = await FlutterMotionSensors.isMotionSensorAvailable();
    setState(() {
      _sensorsAvailable = available;
    });
  }

  Future<void> _loadLatestData() async {
    final data = await FlutterMotionSensors.getAllMotionSensorData();
    setState(() {
      _latestData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.sensors, size: 64, color: Colors.blue),
                  SizedBox(height: 16),
                  Text(
                    'Flutter Motion Sensors',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Comprehensive motion sensor package for Flutter',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sensor Availability',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (_sensorsAvailable == null)
                    const CircularProgressIndicator()
                  else
                    Row(
                      children: [
                        Icon(
                          _sensorsAvailable!
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: _sensorsAvailable! ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _sensorsAvailable!
                              ? 'Motion sensors are available'
                              : 'Motion sensors are not available',
                          style: TextStyle(
                            color:
                                _sensorsAvailable! ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _checkAvailability,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Check Again'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Latest Sensor Data',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (_latestData == null)
                    const CircularProgressIndicator()
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_latestData!.accelerometer != null) ...[
                          const Text('Accelerometer:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              '  X: ${_latestData!.accelerometer!.x.toStringAsFixed(2)} m/s²'),
                          Text(
                              '  Y: ${_latestData!.accelerometer!.y.toStringAsFixed(2)} m/s²'),
                          Text(
                              '  Z: ${_latestData!.accelerometer!.z.toStringAsFixed(2)} m/s²'),
                          const SizedBox(height: 8),
                        ],
                        if (_latestData!.gyroscope != null) ...[
                          const Text('Gyroscope:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              '  X: ${_latestData!.gyroscope!.x.toStringAsFixed(3)} rad/s'),
                          Text(
                              '  Y: ${_latestData!.gyroscope!.y.toStringAsFixed(3)} rad/s'),
                          Text(
                              '  Z: ${_latestData!.gyroscope!.z.toStringAsFixed(3)} rad/s'),
                          const SizedBox(height: 8),
                        ],
                        if (_latestData!.magnetometer != null) ...[
                          const Text('Magnetometer:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              '  X: ${_latestData!.magnetometer!.x.toStringAsFixed(1)} μT'),
                          Text(
                              '  Y: ${_latestData!.magnetometer!.y.toStringAsFixed(1)} μT'),
                          Text(
                              '  Z: ${_latestData!.magnetometer!.z.toStringAsFixed(1)} μT'),
                        ],
                      ],
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _loadLatestData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Data'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Features',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem('✅ Simple sensor data access'),
                  _buildFeatureItem('✅ Stream-based sensor listening'),
                  _buildFeatureItem('✅ Builder widgets for easy integration'),
                  _buildFeatureItem('✅ Controller for manual control'),
                  _buildFeatureItem('✅ Custom sensor type combinations'),
                  _buildFeatureItem('✅ Cross-platform support'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// Simple Access Demo - Shows direct API calls
class SimpleAccessDemo extends StatefulWidget {
  const SimpleAccessDemo({super.key});

  @override
  State<SimpleAccessDemo> createState() => _SimpleAccessDemoState();
}

class _SimpleAccessDemoState extends State<SimpleAccessDemo> {
  AccelerometerData? _accelData;
  GyroscopeData? _gyroData;
  MagnetometerData? _magData;
  bool _loading = false;

  Future<void> _loadAccelerometer() async {
    setState(() => _loading = true);
    final data = await FlutterMotionSensors.getAccelerometerData();
    setState(() {
      _accelData = data;
      _loading = false;
    });
  }

  Future<void> _loadGyroscope() async {
    setState(() => _loading = true);
    final data = await FlutterMotionSensors.getGyroscopeData();
    setState(() {
      _gyroData = data;
      _loading = false;
    });
  }

  Future<void> _loadMagnetometer() async {
    setState(() => _loading = true);
    final data = await FlutterMotionSensors.getMagnetometerData();
    setState(() {
      _magData = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Simple Sensor Data Access',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use direct API calls to get sensor data',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Accelerometer',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _loading ? null : _loadAccelerometer,
                    child: _loading && _accelData == null
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Get Accelerometer Data'),
                  ),
                  if (_accelData != null) ...[
                    const SizedBox(height: 12),
                    Text('X: ${_accelData!.x.toStringAsFixed(2)} m/s²'),
                    Text('Y: ${_accelData!.y.toStringAsFixed(2)} m/s²'),
                    Text('Z: ${_accelData!.z.toStringAsFixed(2)} m/s²'),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Gyroscope',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _loading ? null : _loadGyroscope,
                    child: _loading && _gyroData == null
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Get Gyroscope Data'),
                  ),
                  if (_gyroData != null) ...[
                    const SizedBox(height: 12),
                    Text('X: ${_gyroData!.x.toStringAsFixed(3)} rad/s'),
                    Text('Y: ${_gyroData!.y.toStringAsFixed(3)} rad/s'),
                    Text('Z: ${_gyroData!.z.toStringAsFixed(3)} rad/s'),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Magnetometer',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _loading ? null : _loadMagnetometer,
                    child: _loading && _magData == null
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Get Magnetometer Data'),
                  ),
                  if (_magData != null) ...[
                    const SizedBox(height: 12),
                    Text('X: ${_magData!.x.toStringAsFixed(1)} μT'),
                    Text('Y: ${_magData!.y.toStringAsFixed(1)} μT'),
                    Text('Z: ${_magData!.z.toStringAsFixed(1)} μT'),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Builder Widgets Demo - Shows all builder widgets
class BuilderWidgetsDemo extends StatelessWidget {
  const BuilderWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(icon: Icon(Icons.speed), text: 'Accelerometer'),
              Tab(icon: Icon(Icons.rotate_right), text: 'Gyroscope'),
              Tab(icon: Icon(Icons.explore), text: 'Magnetometer'),
              Tab(icon: Icon(Icons.all_inclusive), text: 'Combined'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                AccelerometerBuilderDemo(),
                GyroscopeBuilderDemo(),
                MagnetometerBuilderDemo(),
                MotionBuilderDemo(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccelerometerBuilderDemo extends StatelessWidget {
  const AccelerometerBuilderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('AccelerometerBuilder',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Tilt your device to see the animation'),
          const SizedBox(height: 32),
          AccelerometerBuilder(
            builder: (context, data) {
              if (data == null) {
                return const CircularProgressIndicator();
              }

              return Transform.rotate(
                angle: data.x * 0.1,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.speed, color: Colors.white, size: 80),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          AccelerometerBuilder(
            builder: (context, data) {
              if (data == null) {
                return const Text('No data available');
              }
              return Column(
                children: [
                  Text('X: ${data.x.toStringAsFixed(2)} m/s²'),
                  Text('Y: ${data.y.toStringAsFixed(2)} m/s²'),
                  Text('Z: ${data.z.toStringAsFixed(2)} m/s²'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class GyroscopeBuilderDemo extends StatelessWidget {
  const GyroscopeBuilderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('GyroscopeBuilder',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Rotate your device to see the animation'),
          const SizedBox(height: 32),
          GyroscopeBuilder(
            builder: (context, data) {
              if (data == null) {
                return const CircularProgressIndicator();
              }

              return Transform.translate(
                offset: Offset(data.x * 50, data.y * 50),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.rotate_right,
                      color: Colors.white, size: 50),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          GyroscopeBuilder(
            builder: (context, data) {
              if (data == null) {
                return const Text('No data available');
              }
              return Column(
                children: [
                  Text('X: ${data.x.toStringAsFixed(3)} rad/s'),
                  Text('Y: ${data.y.toStringAsFixed(3)} rad/s'),
                  Text('Z: ${data.z.toStringAsFixed(3)} rad/s'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class MagnetometerBuilderDemo extends StatelessWidget {
  const MagnetometerBuilderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('MagnetometerBuilder',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Move your device near metal objects'),
          const SizedBox(height: 32),
          MagnetometerBuilder(
            builder: (context, data) {
              if (data == null) {
                return const CircularProgressIndicator();
              }

              final magnitude =
                  sqrt(data.x * data.x + data.y * data.y + data.z * data.z);
              final normalizedMagnitude = (magnitude / 100).clamp(0.0, 1.0);

              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.green.withValues(alpha: normalizedMagnitude),
                      Colors.green.withValues(alpha: 0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.explore, color: Colors.white, size: 100),
              );
            },
          ),
          const SizedBox(height: 32),
          MagnetometerBuilder(
            builder: (context, data) {
              if (data == null) {
                return const Text('No data available');
              }
              return Column(
                children: [
                  Text('X: ${data.x.toStringAsFixed(1)} μT'),
                  Text('Y: ${data.y.toStringAsFixed(1)} μT'),
                  Text('Z: ${data.z.toStringAsFixed(1)} μT'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class MotionBuilderDemo extends StatelessWidget {
  const MotionBuilderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('MotionBuilder',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Move your device in all directions'),
          const SizedBox(height: 32),
          MotionBuilder(
            builder: (context, data) {
              if (data == null) {
                return const CircularProgressIndicator();
              }

              final accelX = data.accelerometer?.x ?? 0.0;
              final gyroY = data.gyroscope?.y ?? 0.0;
              final magZ = data.magnetometer?.z ?? 0.0;

              return Transform(
                transform: Matrix4.identity()
                  ..rotateX(accelX * 0.1)
                  ..rotateY(gyroY * 0.5)
                  ..rotateZ(magZ * 0.01),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.orange, Colors.pink],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.purple,
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.all_inclusive,
                      color: Colors.white, size: 100),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          MotionBuilder(
            builder: (context, data) {
              if (data == null) {
                return const Text('No data available');
              }
              return Column(
                children: [
                  if (data.accelerometer != null) ...[
                    Text(
                        'Accel X: ${data.accelerometer!.x.toStringAsFixed(2)}'),
                    Text(
                        'Accel Y: ${data.accelerometer!.y.toStringAsFixed(2)}'),
                    Text(
                        'Accel Z: ${data.accelerometer!.z.toStringAsFixed(2)}'),
                  ],
                  if (data.gyroscope != null) ...[
                    Text('Gyro X: ${data.gyroscope!.x.toStringAsFixed(3)}'),
                    Text('Gyro Y: ${data.gyroscope!.y.toStringAsFixed(3)}'),
                    Text('Gyro Z: ${data.gyroscope!.z.toStringAsFixed(3)}'),
                  ],
                  if (data.magnetometer != null) ...[
                    Text('Mag X: ${data.magnetometer!.x.toStringAsFixed(1)}'),
                    Text('Mag Y: ${data.magnetometer!.y.toStringAsFixed(1)}'),
                    Text('Mag Z: ${data.magnetometer!.z.toStringAsFixed(1)}'),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Custom Sensor Types Demo
class CustomSensorTypesDemo extends StatelessWidget {
  const CustomSensorTypesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Custom Sensor Types',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Use MotionAnimationBuilder with custom sensor combinations',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Accelerometer + Gyroscope',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  MotionAnimationBuilder(
                    sensorTypes: const [
                      SensorType.accelerometer,
                      SensorType.gyroscope
                    ],
                    builder: (context, controller) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Status: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: controller.isListening
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                              Text(
                                controller.isListening
                                    ? 'Listening'
                                    : 'Stopped',
                                style: TextStyle(
                                  color: controller.isListening
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Accel data: ${controller.lastAccelerometerData != null ? "Available" : controller.isListening ? "Waiting..." : "Not started"}',
                            style: TextStyle(
                                fontSize: 12,
                                color: controller.lastAccelerometerData != null
                                    ? Colors.green
                                    : controller.isListening
                                        ? Colors.orange
                                        : Colors.grey),
                          ),
                          Text(
                            'Gyro data: ${controller.lastGyroscopeData != null ? "Available" : controller.isListening ? "Waiting..." : "Not started"}',
                            style: TextStyle(
                                fontSize: 12,
                                color: controller.lastGyroscopeData != null
                                    ? Colors.green
                                    : controller.isListening
                                        ? Colors.orange
                                        : Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          if (controller.lastAccelerometerData == null)
                            const Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 8),
                                Text('Waiting for accelerometer data...',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            )
                          else ...[
                            Row(
                              children: [
                                const Text('Accel X: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                Text(
                                  '${controller.lastAccelerometerData!.x.toStringAsFixed(2)} m/s²',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('Accel Y: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                Text(
                                  '${controller.lastAccelerometerData!.y.toStringAsFixed(2)} m/s²',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('Accel Z: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                Text(
                                  '${controller.lastAccelerometerData!.z.toStringAsFixed(2)} m/s²',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          if (controller.lastGyroscopeData == null)
                            const Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 8),
                                Text('Waiting for gyroscope data...',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            )
                          else ...[
                            Row(
                              children: [
                                const Text('Gyro X: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                Text(
                                  '${controller.lastGyroscopeData!.x.toStringAsFixed(3)} rad/s',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('Gyro Y: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                Text(
                                  '${controller.lastGyroscopeData!.y.toStringAsFixed(3)} rad/s',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('Gyro Z: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                Text(
                                  '${controller.lastGyroscopeData!.z.toStringAsFixed(3)} rad/s',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('All Sensors',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  MotionAnimationBuilder(
                    sensorTypes: const [
                      SensorType.accelerometer,
                      SensorType.gyroscope,
                      SensorType.magnetometer,
                    ],
                    builder: (context, controller) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Status: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: controller.isListening
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                              Text(
                                controller.isListening
                                    ? 'Listening'
                                    : 'Stopped',
                                style: TextStyle(
                                  color: controller.isListening
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (controller.lastAccelerometerData != null) ...[
                            const Text('Accelerometer:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                                '  X: ${controller.lastAccelerometerData!.x.toStringAsFixed(2)} m/s²'),
                            Text(
                                '  Y: ${controller.lastAccelerometerData!.y.toStringAsFixed(2)} m/s²'),
                            Text(
                                '  Z: ${controller.lastAccelerometerData!.z.toStringAsFixed(2)} m/s²'),
                            const SizedBox(height: 8),
                          ] else ...[
                            const Text('Accelerometer: Waiting...',
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 8),
                          ],
                          if (controller.lastGyroscopeData != null) ...[
                            const Text('Gyroscope:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                                '  X: ${controller.lastGyroscopeData!.x.toStringAsFixed(3)} rad/s'),
                            Text(
                                '  Y: ${controller.lastGyroscopeData!.y.toStringAsFixed(3)} rad/s'),
                            Text(
                                '  Z: ${controller.lastGyroscopeData!.z.toStringAsFixed(3)} rad/s'),
                            const SizedBox(height: 8),
                          ] else ...[
                            const Text('Gyroscope: Waiting...',
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 8),
                          ],
                          if (controller.lastMagnetometerData != null) ...[
                            const Text('Magnetometer:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                                '  X: ${controller.lastMagnetometerData!.x.toStringAsFixed(1)} μT'),
                            Text(
                                '  Y: ${controller.lastMagnetometerData!.y.toStringAsFixed(1)} μT'),
                            Text(
                                '  Z: ${controller.lastMagnetometerData!.z.toStringAsFixed(1)} μT'),
                          ] else ...[
                            const Text('Magnetometer: Waiting...',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Manual Control Demo
class ManualControlDemo extends StatefulWidget {
  const ManualControlDemo({super.key});

  @override
  State<ManualControlDemo> createState() => _ManualControlDemoState();
}

class _ManualControlDemoState extends State<ManualControlDemo> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Manual Control',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Use MotionAnimationBuilder with autoStart: false',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          MotionAnimationBuilder(
            autoStart: false,
            builder: (context, controller) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: controller.isListening
                        ? controller.stopListening
                        : controller.startListening,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.isListening ? Colors.red : Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      controller.isListening ? 'Stop Sensors' : 'Start Sensors',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Status: ${controller.isListening ? "Listening" : "Stopped"}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  if (controller.lastAccelerometerData != null) ...[
                    const Text('Latest Accelerometer:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        'X: ${controller.lastAccelerometerData!.x.toStringAsFixed(2)}'),
                    Text(
                        'Y: ${controller.lastAccelerometerData!.y.toStringAsFixed(2)}'),
                    Text(
                        'Z: ${controller.lastAccelerometerData!.z.toStringAsFixed(2)}'),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Stream Demo
class StreamDemo extends StatefulWidget {
  const StreamDemo({super.key});

  @override
  State<StreamDemo> createState() => _StreamDemoState();
}

class _StreamDemoState extends State<StreamDemo> {
  StreamSubscription<AccelerometerData>? _accelSubscription;
  StreamSubscription<GyroscopeData>? _gyroSubscription;
  StreamSubscription<MotionSensorData>? _motionSubscription;
  AccelerometerData? _lastAccel;
  GyroscopeData? _lastGyro;
  MotionSensorData? _lastMotion;
  int _eventCount = 0;

  @override
  void initState() {
    super.initState();
    // Don't auto-start - let user control manually
  }

  void _startListening() {
    // Only start if not already listening
    if (_accelSubscription != null) return;

    setState(() {
      _eventCount = 0; // Reset event count
      _lastAccel = null;
      _lastGyro = null;
      _lastMotion = null;

      _accelSubscription = FlutterMotionSensors.accelerometerEvents.listen(
        (data) {
          if (mounted) {
            setState(() {
              _lastAccel = data;
              _eventCount++;
            });
          }
        },
        onError: (error) {
          // Ignore cancellation-related errors
          if (error is PlatformException &&
              (error.code == 'error' &&
                  error.message?.contains('No active stream') == true)) {
            return;
          }
        },
        cancelOnError: false,
      );

      _gyroSubscription = FlutterMotionSensors.gyroscopeEvents.listen(
        (data) {
          if (mounted) {
            setState(() {
              _lastGyro = data;
            });
          }
        },
        onError: (error) {
          // Ignore cancellation-related errors
          if (error is PlatformException &&
              (error.code == 'error' &&
                  error.message?.contains('No active stream') == true)) {
            return;
          }
        },
        cancelOnError: false,
      );

      _motionSubscription = FlutterMotionSensors.motionSensorEvents.listen(
        (data) {
          if (mounted) {
            setState(() {
              _lastMotion = data;
            });
          }
        },
        onError: (error) {
          // Ignore cancellation-related errors
          if (error is PlatformException &&
              (error.code == 'error' &&
                  error.message?.contains('No active stream') == true)) {
            return;
          }
        },
        cancelOnError: false,
      );
    });
  }

  void _stopListening() {
    // Only stop if actually listening
    if (_accelSubscription == null &&
        _gyroSubscription == null &&
        _motionSubscription == null) {
      return;
    }

    // Cancel subscriptions safely, ignoring cancellation errors
    final accelSub = _accelSubscription;
    final gyroSub = _gyroSubscription;
    final motionSub = _motionSubscription;

    // Clear references first to prevent double-cancellation
    _accelSubscription = null;
    _gyroSubscription = null;
    _motionSubscription = null;

    if (mounted) {
      setState(() {
        // References already cleared above
      });
    }

    // Now cancel the subscriptions
    try {
      accelSub?.cancel();
    } catch (e) {
      // Ignore errors during cancellation (e.g., "No active stream to cancel")
    }
    try {
      gyroSub?.cancel();
    } catch (e) {
      // Ignore errors during cancellation
    }
    try {
      motionSub?.cancel();
    } catch (e) {
      // Ignore errors during cancellation
    }
  }

  @override
  void dispose() {
    // Cancel subscriptions safely, ignoring cancellation errors
    try {
      _accelSubscription?.cancel();
    } catch (e) {
      // Ignore errors during cancellation
    }
    try {
      _gyroSubscription?.cancel();
    } catch (e) {
      // Ignore errors during cancellation
    }
    try {
      _motionSubscription?.cancel();
    } catch (e) {
      // Ignore errors during cancellation
    }
    _accelSubscription = null;
    _gyroSubscription = null;
    _motionSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isListening = _accelSubscription != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Stream-based Sensor Listening',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Direct stream access using FlutterMotionSensors.accelerometerEvents',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isListening ? _stopListening : _startListening,
            style: ElevatedButton.styleFrom(
              backgroundColor: isListening ? Colors.red : Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(
              isListening ? 'Stop Streams' : 'Start Streams',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Status: ${isListening ? "Listening" : "Stopped"}',
            style: const TextStyle(fontSize: 18),
          ),
          Text('Events received: $_eventCount'),
          const SizedBox(height: 24),
          if (_lastAccel != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Accelerometer Stream',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('X: ${_lastAccel!.x.toStringAsFixed(2)} m/s²'),
                    Text('Y: ${_lastAccel!.y.toStringAsFixed(2)} m/s²'),
                    Text('Z: ${_lastAccel!.z.toStringAsFixed(2)} m/s²'),
                  ],
                ),
              ),
            ),
          ],
          if (_lastGyro != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Gyroscope Stream',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('X: ${_lastGyro!.x.toStringAsFixed(3)} rad/s'),
                    Text('Y: ${_lastGyro!.y.toStringAsFixed(3)} rad/s'),
                    Text('Z: ${_lastGyro!.z.toStringAsFixed(3)} rad/s'),
                  ],
                ),
              ),
            ),
          ],
          if (_lastMotion != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Motion Sensor Stream',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    if (_lastMotion!.accelerometer != null)
                      Text(
                          'Accel: ${_lastMotion!.accelerometer!.x.toStringAsFixed(2)}'),
                    if (_lastMotion!.gyroscope != null)
                      Text(
                          'Gyro: ${_lastMotion!.gyroscope!.x.toStringAsFixed(3)}'),
                    if (_lastMotion!.magnetometer != null)
                      Text(
                          'Mag: ${_lastMotion!.magnetometer!.x.toStringAsFixed(1)}'),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
