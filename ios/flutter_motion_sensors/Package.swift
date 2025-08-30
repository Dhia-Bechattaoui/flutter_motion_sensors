// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_motion_sensors",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "flutter_motion_sensors",
            targets: ["flutter_motion_sensors"]),
    ],
    dependencies: [
        // Dependencies go here
    ],
    targets: [
        .target(
            name: "flutter_motion_sensors",
            dependencies: [],
            path: "../../lib",
            sources: ["src"],
            resources: [
                .process("src")
            ]
        ),
        .testTarget(
            name: "flutter_motion_sensorsTests",
            dependencies: ["flutter_motion_sensors"],
            path: "../../test"
        ),
    ]
)
