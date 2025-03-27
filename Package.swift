// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BetterBinding",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .watchOS(.v6), .tvOS(.v13), .visionOS(.v1)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BetterBinding",
            targets: ["BetterBinding"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BetterBinding"),
        .testTarget(
            name: "BetterBindingTests",
            dependencies: ["BetterBinding"]
        ),
    ]
)
