// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-utilities",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .macCatalyst(.v17),
        .visionOS(.v1),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        .library(name: "SwiftUtilities", targets: ["SwiftUtilities"]),
    ],
    targets: [
        .target(name: "SwiftUtilities"),
        .testTarget(
            name: "SwiftUtilitiesTests",
            dependencies: ["SwiftUtilities"]
        ),
    ]
)
