import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_motion_sensors/flutter_motion_sensors.dart';

void main() {
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
    const AccelerometerDemo(),
    const GyroscopeDemo(),
    const MagnetometerDemo(),
    const CombinedDemo(),
    const ControllerDemo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Motion Sensors'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Accelerometer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rotate_right),
            label: 'Gyroscope',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Magnetometer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive),
            label: 'Combined',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Controller',
          ),
        ],
      ),
    );
  }
}

class AccelerometerDemo extends StatelessWidget {
  const AccelerometerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Accelerometer Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Tilt your device to see the animation'),
            const SizedBox(height: 40),
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
                    child: const Icon(
                      Icons.speed,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
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
                    Text('Timestamp: ${data.timestamp.toString()}'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GyroscopeDemo extends StatelessWidget {
  const GyroscopeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Gyroscope Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Rotate your device to see the animation'),
            const SizedBox(height: 40),
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
                    child: const Icon(
                      Icons.rotate_right,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
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
                    Text('Timestamp: ${data.timestamp.toString()}'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MagnetometerDemo extends StatelessWidget {
  const MagnetometerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Magnetometer Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Move your device near metal objects'),
            const SizedBox(height: 40),
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
                  child: const Icon(
                    Icons.explore,
                    color: Colors.white,
                    size: 100,
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
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
                    Text('Timestamp: ${data.timestamp.toString()}'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CombinedDemo extends StatelessWidget {
  const CombinedDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Combined Motion Sensors Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Move your device in all directions'),
            const SizedBox(height: 40),
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
                        colors: [
                          Colors.purple,
                          Colors.orange,
                          Colors.pink,
                        ],
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
                    child: const Icon(
                      Icons.all_inclusive,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
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
                    Text('Timestamp: ${data.timestamp.toString()}'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ControllerDemo extends StatefulWidget {
  const ControllerDemo({super.key});

  @override
  State<ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<ControllerDemo> {
  late MotionSensorController _controller;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _controller = MotionSensorController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleListening() {
    if (_isListening) {
      _controller.stopListening();
    } else {
      _controller.startListening();
    }
    setState(() {
      _isListening = !_isListening;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Controller Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Manual control of motion sensors'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _toggleListening,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isListening ? Colors.red : Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                _isListening ? 'Stop Listening' : 'Start Listening',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 40),
            ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                return Column(
                  children: [
                    Text(
                      'Status: ${_controller.isListening ? "Listening" : "Stopped"}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    if (_controller.lastAccelerometerData != null) ...[
                      const Text('Latest Accelerometer Data:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          'X: ${_controller.lastAccelerometerData!.x.toStringAsFixed(2)}'),
                      Text(
                          'Y: ${_controller.lastAccelerometerData!.y.toStringAsFixed(2)}'),
                      Text(
                          'Z: ${_controller.lastAccelerometerData!.z.toStringAsFixed(2)}'),
                      const SizedBox(height: 10),
                    ],
                    if (_controller.lastGyroscopeData != null) ...[
                      const Text('Latest Gyroscope Data:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          'X: ${_controller.lastGyroscopeData!.x.toStringAsFixed(3)}'),
                      Text(
                          'Y: ${_controller.lastGyroscopeData!.y.toStringAsFixed(3)}'),
                      Text(
                          'Z: ${_controller.lastGyroscopeData!.z.toStringAsFixed(3)}'),
                      const SizedBox(height: 10),
                    ],
                    if (_controller.lastMagnetometerData != null) ...[
                      const Text('Latest Magnetometer Data:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          'X: ${_controller.lastMagnetometerData!.x.toStringAsFixed(1)}'),
                      Text(
                          'Y: ${_controller.lastMagnetometerData!.y.toStringAsFixed(1)}'),
                      Text(
                          'Z: ${_controller.lastMagnetometerData!.z.toStringAsFixed(1)}'),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
