import FlutterMacOS
import AppKit

public class FlutterMotionSensorsPlugin: NSObject, FlutterPlugin {

    private lazy var accelerometerStreamHandler = NoOpStreamHandler()
    private lazy var gyroscopeStreamHandler     = NoOpStreamHandler()
    private lazy var magnetometerStreamHandler  = NoOpStreamHandler()
    private lazy var motionStreamHandler        = NoOpStreamHandler()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger

        let channel = FlutterMethodChannel(
            name: "flutter_motion_sensors",
            binaryMessenger: messenger
        )
        let instance = FlutterMotionSensorsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        FlutterEventChannel(name: "flutter_motion_sensors/accelerometer",
                            binaryMessenger: messenger)
            .setStreamHandler(instance.accelerometerStreamHandler)
        FlutterEventChannel(name: "flutter_motion_sensors/gyroscope",
                            binaryMessenger: messenger)
            .setStreamHandler(instance.gyroscopeStreamHandler)
        FlutterEventChannel(name: "flutter_motion_sensors/magnetometer",
                            binaryMessenger: messenger)
            .setStreamHandler(instance.magnetometerStreamHandler)
        FlutterEventChannel(name: "flutter_motion_sensors/motion",
                            binaryMessenger: messenger)
            .setStreamHandler(instance.motionStreamHandler)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isMotionSensorAvailable":
            result(false)
        case "getAccelerometerData",
             "getGyroscopeData",
             "getMagnetometerData",
             "getAllMotionSensorData":
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Motion sensors are not available on macOS",
                                details: nil))
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

private class NoOpStreamHandler: NSObject, FlutterStreamHandler {
    func onListen(withArguments arguments: Any?,
                  eventSink events: @escaping FlutterEventSink) -> FlutterError? { nil }
    func onCancel(withArguments arguments: Any?) -> FlutterError? { nil }
}
