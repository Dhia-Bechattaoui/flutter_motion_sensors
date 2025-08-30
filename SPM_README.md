# Swift Package Manager Support

This Flutter package now supports Swift Package Manager (SPM) for iOS and macOS platforms.

## What was added

### iOS Support
- `ios/flutter_motion_sensors.podspec` - CocoaPods specification file
- `ios/Info.plist` - iOS bundle information
- `ios/Classes/FlutterMotionSensorsPlugin.swift` - iOS plugin implementation
- `ios/flutter_motion_sensors.xcodeproj/project.pbxproj` - Xcode project file

### macOS Support
- `macos/flutter_motion_sensors.podspec` - CocoaPods specification file
- `macos/Info.plist` - macOS bundle information
- `macos/Classes/FlutterMotionSensorsPlugin.swift` - macOS plugin implementation
- `macos/flutter_motion_sensors.xcodeproj/project.pbxproj` - Xcode project file

### Root Level
- `Package.swift` - Swift Package Manager manifest file

## Features

The native iOS and macOS implementations provide:
- Device motion detection using CoreMotion framework
- Real-time motion data streaming (attitude, rotation rate, gravity, user acceleration)
- 60Hz update rate for smooth motion tracking
- Proper permission handling for motion sensor access

## Usage

### As a Flutter Plugin
The package works as a standard Flutter plugin and will automatically use the native implementations on iOS and macOS.

### As a Swift Package
You can also use this package directly in Swift projects by adding it as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Dhia-Bechattaoui/flutter_motion_sensors.git", from: "0.0.2")
]
```

## Requirements

- iOS 12.0+
- macOS 10.15+
- Swift 5.0+
- Xcode 14.0+

## Permissions

The package requires motion sensor permissions. Add the following to your app's Info.plist:

```xml
<key>NSMotionUsageDescription</key>
<string>This app needs access to motion sensors to provide motion-based animations.</string>
```

## Building

To build the native frameworks:

```bash
# iOS
cd ios
xcodebuild -project flutter_motion_sensors.xcodeproj -scheme flutter_motion_sensors -configuration Release -sdk iphoneos

# macOS
cd macos
xcodebuild -project flutter_motion_sensors.xcodeproj -scheme flutter_motion_sensors -configuration Release -sdk macosx
```

## Testing

The package includes comprehensive tests for both the Dart and native implementations. Run tests with:

```bash
flutter test
```

## Contributing

When contributing to the native implementations:
1. Ensure compatibility with both iOS and macOS
2. Test on physical devices (motion sensors don't work in simulators)
3. Follow Swift best practices and Flutter plugin conventions
4. Update both platform implementations when adding new features
