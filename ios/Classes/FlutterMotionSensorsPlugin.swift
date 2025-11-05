import Flutter
import UIKit
import CoreMotion

public class FlutterMotionSensorsPlugin: NSObject, FlutterPlugin {
    private let motionManager = CMMotionManager()
    var accelerometerEventSink: FlutterEventSink?
    var gyroscopeEventSink: FlutterEventSink?
    var magnetometerEventSink: FlutterEventSink?
    var motionEventSink: FlutterEventSink?
    private var isAccelerometerListening = false
    private var isGyroscopeListening = false
    private var isMagnetometerListening = false
    private var isMotionListening = false
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_motion_sensors", binaryMessenger: registrar.messenger())
        let instance = FlutterMotionSensorsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // Register event channels
        FlutterEventChannel(name: "flutter_motion_sensors/accelerometer", binaryMessenger: registrar.messenger())
            .setStreamHandler(instance.accelerometerStreamHandler)
        
        FlutterEventChannel(name: "flutter_motion_sensors/gyroscope", binaryMessenger: registrar.messenger())
            .setStreamHandler(instance.gyroscopeStreamHandler)
        
        FlutterEventChannel(name: "flutter_motion_sensors/magnetometer", binaryMessenger: registrar.messenger())
            .setStreamHandler(instance.magnetometerStreamHandler)
        
        FlutterEventChannel(name: "flutter_motion_sensors/motion", binaryMessenger: registrar.messenger())
            .setStreamHandler(instance.motionStreamHandler)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isMotionSensorAvailable":
            result(motionManager.isDeviceMotionAvailable || 
                   motionManager.isAccelerometerAvailable ||
                   motionManager.isGyroAvailable ||
                   motionManager.isMagnetometerAvailable)
            
        case "getAccelerometerData":
            if motionManager.isAccelerometerAvailable {
                motionManager.accelerometerUpdateInterval = 0.1
                var capturedResult: FlutterResult? = result
                motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
                    guard let self = self else { return }
                    self.motionManager.stopAccelerometerUpdates()
                    guard let accelData = data, let captured = capturedResult else {
                        capturedResult?(FlutterError(code: "ERROR", message: "Failed to get accelerometer data", details: nil))
                        capturedResult = nil
                        return
                    }
                    let data: [String: Any] = [
                        "x": accelData.acceleration.x * 9.81, // Convert to m/s²
                        "y": accelData.acceleration.y * 9.81,
                        "z": accelData.acceleration.z * 9.81,
                        "timestamp": Int(accelData.timestamp * 1000)
                    ]
                    captured(data)
                    capturedResult = nil
                }
            } else {
                result(FlutterError(code: "UNAVAILABLE", message: "Accelerometer not available", details: nil))
            }
            
        case "getGyroscopeData":
            if motionManager.isGyroAvailable {
                motionManager.gyroUpdateInterval = 0.1
                var capturedResult: FlutterResult? = result
                motionManager.startGyroUpdates(to: .main) { [weak self] (data, error) in
                    guard let self = self else { return }
                    self.motionManager.stopGyroUpdates()
                    guard let gyroData = data, let captured = capturedResult else {
                        capturedResult?(FlutterError(code: "ERROR", message: "Failed to get gyroscope data", details: nil))
                        capturedResult = nil
                        return
                    }
                    let data: [String: Any] = [
                        "x": gyroData.rotationRate.x,
                        "y": gyroData.rotationRate.y,
                        "z": gyroData.rotationRate.z,
                        "timestamp": Int(gyroData.timestamp * 1000)
                    ]
                    captured(data)
                    capturedResult = nil
                }
            } else {
                result(FlutterError(code: "UNAVAILABLE", message: "Gyroscope not available", details: nil))
            }
            
        case "getMagnetometerData":
            if motionManager.isMagnetometerAvailable {
                motionManager.magnetometerUpdateInterval = 0.1
                var capturedResult: FlutterResult? = result
                motionManager.startMagnetometerUpdates(to: .main) { [weak self] (data, error) in
                    guard let self = self else { return }
                    self.motionManager.stopMagnetometerUpdates()
                    guard let magData = data, let captured = capturedResult else {
                        capturedResult?(FlutterError(code: "ERROR", message: "Failed to get magnetometer data", details: nil))
                        capturedResult = nil
                        return
                    }
                    let data: [String: Any] = [
                        "x": magData.magneticField.x,
                        "y": magData.magneticField.y,
                        "z": magData.magneticField.z,
                        "timestamp": Int(magData.timestamp * 1000)
                    ]
                    captured(data)
                    capturedResult = nil
                }
            } else {
                result(FlutterError(code: "UNAVAILABLE", message: "Magnetometer not available", details: nil))
            }
            
        case "getAllMotionSensorData":
            if motionManager.isDeviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = 0.1
                var capturedResult: FlutterResult? = result
                motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
                    guard let self = self else { return }
                    self.motionManager.stopDeviceMotionUpdates()
                    guard let motion = motion, let captured = capturedResult else {
                        capturedResult?(FlutterError(code: "ERROR", message: "Failed to get motion data", details: nil))
                        capturedResult = nil
                        return
                    }
                    let timestamp = Int(motion.timestamp * 1000)
                    var accelerometerData: [String: Any]? = nil
                    var gyroscopeData: [String: Any]? = nil
                    
                    accelerometerData = [
                        "x": motion.userAcceleration.x * 9.81 + motion.gravity.x * 9.81,
                        "y": motion.userAcceleration.y * 9.81 + motion.gravity.y * 9.81,
                        "z": motion.userAcceleration.z * 9.81 + motion.gravity.z * 9.81,
                        "timestamp": timestamp
                    ]
                    
                    gyroscopeData = [
                        "x": motion.rotationRate.x,
                        "y": motion.rotationRate.y,
                        "z": motion.rotationRate.z,
                        "timestamp": timestamp
                    ]
                    
                    let data: [String: Any] = [
                        "accelerometer": accelerometerData as Any? ?? NSNull(),
                        "gyroscope": gyroscopeData as Any? ?? NSNull(),
                        "magnetometer": NSNull(),
                        "timestamp": timestamp
                    ]
                    captured(data)
                    capturedResult = nil
                }
            } else {
                // Fallback to individual sensors
                var accelerometerData: [String: Any]?
                var gyroscopeData: [String: Any]?
                var magnetometerData: [String: Any]?
                let timestamp = Int(Date().timeIntervalSince1970 * 1000)
                
                let group = DispatchGroup()
                var capturedResult: FlutterResult? = result
                
                if motionManager.isAccelerometerAvailable {
                    group.enter()
                    motionManager.accelerometerUpdateInterval = 0.1
                    motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
                        guard let self = self else {
                            group.leave()
                            return
                        }
                        self.motionManager.stopAccelerometerUpdates()
                        if let accelData = data {
                            accelerometerData = [
                                "x": accelData.acceleration.x * 9.81,
                                "y": accelData.acceleration.y * 9.81,
                                "z": accelData.acceleration.z * 9.81,
                                "timestamp": Int(accelData.timestamp * 1000)
                            ]
                        }
                        group.leave()
                    }
                }
                
                if motionManager.isGyroAvailable {
                    group.enter()
                    motionManager.gyroUpdateInterval = 0.1
                    motionManager.startGyroUpdates(to: .main) { [weak self] (data, error) in
                        guard let self = self else {
                            group.leave()
                            return
                        }
                        self.motionManager.stopGyroUpdates()
                        if let gyroData = data {
                            gyroscopeData = [
                                "x": gyroData.rotationRate.x,
                                "y": gyroData.rotationRate.y,
                                "z": gyroData.rotationRate.z,
                                "timestamp": Int(gyroData.timestamp * 1000)
                            ]
                        }
                        group.leave()
                    }
                }
                
                if motionManager.isMagnetometerAvailable {
                    group.enter()
                    motionManager.magnetometerUpdateInterval = 0.1
                    motionManager.startMagnetometerUpdates(to: .main) { [weak self] (data, error) in
                        guard let self = self else {
                            group.leave()
                            return
                        }
                        self.motionManager.stopMagnetometerUpdates()
                        if let magData = data {
                            magnetometerData = [
                                "x": magData.magneticField.x,
                                "y": magData.magneticField.y,
                                "z": magData.magneticField.z,
                                "timestamp": Int(magData.timestamp * 1000)
                            ]
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    guard let captured = capturedResult else { return }
                    let data: [String: Any] = [
                        "accelerometer": accelerometerData as Any? ?? NSNull(),
                        "gyroscope": gyroscopeData as Any? ?? NSNull(),
                        "magnetometer": magnetometerData as Any? ?? NSNull(),
                        "timestamp": timestamp
                    ]
                    captured(data)
                    capturedResult = nil
                }
            }
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // Accelerometer stream handler
    private lazy var accelerometerStreamHandler: AccelerometerStreamHandler = {
        AccelerometerStreamHandler(plugin: self)
    }()
    
    // Gyroscope stream handler
    private lazy var gyroscopeStreamHandler: GyroscopeStreamHandler = {
        GyroscopeStreamHandler(plugin: self)
    }()
    
    // Magnetometer stream handler
    private lazy var magnetometerStreamHandler: MagnetometerStreamHandler = {
        MagnetometerStreamHandler(plugin: self)
    }()
    
    // Motion stream handler
    private lazy var motionStreamHandler: MotionStreamHandler = {
        MotionStreamHandler(plugin: self)
    }()
    
    func startAccelerometerStream() {
        guard !isAccelerometerListening, motionManager.isAccelerometerAvailable else { return }
        isAccelerometerListening = true
        motionManager.accelerometerUpdateInterval = 1.0 / 60.0 // 60 Hz
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, let accelData = data else { return }
            let eventData: [String: Any] = [
                "x": accelData.acceleration.x * 9.81,
                "y": accelData.acceleration.y * 9.81,
                "z": accelData.acceleration.z * 9.81,
                "timestamp": Int(accelData.timestamp * 1000)
            ]
            self.accelerometerEventSink?(eventData)
        }
    }
    
    func stopAccelerometerStream() {
        guard isAccelerometerListening else { return }
        isAccelerometerListening = false
        motionManager.stopAccelerometerUpdates()
        accelerometerEventSink = nil
    }
    
    func startGyroscopeStream() {
        guard !isGyroscopeListening, motionManager.isGyroAvailable else { return }
        isGyroscopeListening = true
        motionManager.gyroUpdateInterval = 1.0 / 60.0 // 60 Hz
        motionManager.startGyroUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, let gyroData = data else { return }
            let eventData: [String: Any] = [
                "x": gyroData.rotationRate.x,
                "y": gyroData.rotationRate.y,
                "z": gyroData.rotationRate.z,
                "timestamp": Int(gyroData.timestamp * 1000)
            ]
            self.gyroscopeEventSink?(eventData)
        }
    }
    
    func stopGyroscopeStream() {
        guard isGyroscopeListening else { return }
        isGyroscopeListening = false
        motionManager.stopGyroUpdates()
        gyroscopeEventSink = nil
    }
    
    func startMagnetometerStream() {
        guard !isMagnetometerListening, motionManager.isMagnetometerAvailable else { return }
        isMagnetometerListening = true
        motionManager.magnetometerUpdateInterval = 1.0 / 60.0 // 60 Hz
        motionManager.startMagnetometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, let magData = data else { return }
            let eventData: [String: Any] = [
                "x": magData.magneticField.x,
                "y": magData.magneticField.y,
                "z": magData.magneticField.z,
                "timestamp": Int(magData.timestamp * 1000)
            ]
            self.magnetometerEventSink?(eventData)
        }
    }
    
    func stopMagnetometerStream() {
        guard isMagnetometerListening else { return }
        isMagnetometerListening = false
        motionManager.stopMagnetometerUpdates()
        magnetometerEventSink = nil
    }
    
    func startMotionStream() {
        guard !isMotionListening, motionManager.isDeviceMotionAvailable else { return }
        isMotionListening = true
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0 // 60 Hz
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
            guard let self = self, let motion = motion else { return }
            let eventData: [String: Any] = [
                "accelerometer": [
                    "x": motion.userAcceleration.x * 9.81 + motion.gravity.x * 9.81,
                    "y": motion.userAcceleration.y * 9.81 + motion.gravity.y * 9.81,
                    "z": motion.userAcceleration.z * 9.81 + motion.gravity.z * 9.81,
                    "timestamp": Int(motion.timestamp * 1000)
                ],
                "gyroscope": [
                    "x": motion.rotationRate.x,
                    "y": motion.rotationRate.y,
                    "z": motion.rotationRate.z,
                    "timestamp": Int(motion.timestamp * 1000)
                ],
                "magnetometer": NSNull(),
                "timestamp": Int(motion.timestamp * 1000)
            ]
            self.motionEventSink?(eventData)
        }
    }
    
    func stopMotionStream() {
        guard isMotionListening else { return }
        isMotionListening = false
        motionManager.stopDeviceMotionUpdates()
        motionEventSink = nil
    }
}

// Stream handlers
private class AccelerometerStreamHandler: NSObject, FlutterStreamHandler {
    weak var plugin: FlutterMotionSensorsPlugin?
    
    init(plugin: FlutterMotionSensorsPlugin) {
        self.plugin = plugin
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        plugin?.accelerometerEventSink = events
        plugin?.startAccelerometerStream()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        plugin?.stopAccelerometerStream()
        return nil
    }
}

private class GyroscopeStreamHandler: NSObject, FlutterStreamHandler {
    weak var plugin: FlutterMotionSensorsPlugin?
    
    init(plugin: FlutterMotionSensorsPlugin) {
        self.plugin = plugin
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        plugin?.gyroscopeEventSink = events
        plugin?.startGyroscopeStream()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        plugin?.stopGyroscopeStream()
        return nil
    }
}

private class MagnetometerStreamHandler: NSObject, FlutterStreamHandler {
    weak var plugin: FlutterMotionSensorsPlugin?
    
    init(plugin: FlutterMotionSensorsPlugin) {
        self.plugin = plugin
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        plugin?.magnetometerEventSink = events
        plugin?.startMagnetometerStream()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        plugin?.stopMagnetometerStream()
        return nil
    }
}

private class MotionStreamHandler: NSObject, FlutterStreamHandler {
    weak var plugin: FlutterMotionSensorsPlugin?
    
    init(plugin: FlutterMotionSensorsPlugin) {
        self.plugin = plugin
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        plugin?.motionEventSink = events
        plugin?.startMotionStream()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        plugin?.stopMotionStream()
        return nil
    }
}
