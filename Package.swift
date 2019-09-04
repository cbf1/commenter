// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "commenter",
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.4.0"),
    ],
    targets: [
        .target(
            name: "commenter",
            dependencies: ["SPMUtility"]),
        .testTarget(
            name: "commenterTests",
            dependencies: ["commenter"]),
    ]
)
