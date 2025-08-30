import Flutter
import AppKit
import CoreMotion

public class FlutterMotionSensorsPlugin: NSObject, FlutterPlugin {
    private let motionManager = CMMotionManager()
    private var eventChannel: FlutterEventChannel?
    private var methodChannel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_motion_sensors", binaryMessenger: registrar.messenger())
        let instance = FlutterMotionSensorsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannel = FlutterEventChannel(name: "flutter_motion_sensors_events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isAvailable":
            result(motionManager.isDeviceMotionAvailable)
        case "startMotionUpdates":
            startMotionUpdates(result: result)
        case "stopMotionUpdates":
            stopMotionUpdates(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startMotionUpdates(result: @escaping FlutterResult) {
        guard motionManager.isDeviceMotionAvailable else {
            result(FlutterError(code: "UNAVAILABLE", message: "Device motion is not available", details: nil))
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0 // 60 Hz
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
            guard let self = self, let motion = motion else { return }
            
            let data: [String: Any] = [
                "attitude": [
                    "roll": motion.attitude.roll,
                    "pitch": motion.attitude.pitch,
                    "yaw": motion.attitude.yaw
                ],
                "rotationRate": [
                    "x": motion.rotationRate.x,
                    "y": motion.rotationRate.y,
                    "z": motion.rotationRate.z
                ],
                "gravity": [
                    "x": motion.gravity.x,
                    "y": motion.gravity.y,
                    "z": motion.gravity.z
                ],
                "userAcceleration": [
                    "x": motion.userAcceleration.x,
                    "y": motion.userAcceleration.y,
                    "z": motion.userAcceleration.z
                ]
            ]
            
            // Send data through event channel if available
            if let eventChannel = self.eventChannel {
                eventChannel.send(data)
            }
        }
        
        result(true)
    }
    
    private func stopMotionUpdates(result: @escaping FlutterResult) {
        motionManager.stopDeviceMotionUpdates()
        result(true)
    }
}

extension FlutterMotionSensorsPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        // Store event sink for sending motion data
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
