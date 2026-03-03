// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_motion_sensors",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "flutter-motion-sensors",
            targets: ["flutter_motion_sensors"]),
    ],
    dependencies: [
        // Dependencies go here
    ],
    targets: [
        .target(
            name: "flutter_motion_sensors",
            dependencies: [],
            path: "Sources/flutter_motion_sensors"
        ),
    ]
)
