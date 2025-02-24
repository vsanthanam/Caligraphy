// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Caligraphy",
    platforms: [
        .macOS(.v14),
        .macCatalyst(.v17),
        .iOS(.v17),
        .watchOS(.v10),
        .tvOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Caligraphy",
            targets: [
                "Caligraphy"
            ]
        )
    ],
    targets: [
        .target(
            name: "Caligraphy",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
        .testTarget(
            name: "CaligraphyTests",
            dependencies: [
                "Caligraphy"
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        )
    ]
)
