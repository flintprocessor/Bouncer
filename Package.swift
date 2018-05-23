// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Bouncer",
    products: [
        .library(
            name: "Bouncer",
            targets: ["Bouncer"]),
    ],
    targets: [
        .target(
            name: "Bouncer"),
        .testTarget(
            name: "BouncerTests",
            dependencies: ["Bouncer"]),
        .target(
            name: "git-mock",
            dependencies: ["Bouncer"]),
    ]
)
