// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Prelude",
    products: [
        .library(name: "Prelude", targets: ["Prelude"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Prelude", dependencies: []),
        .testTarget(name: "PreludeTests", dependencies: ["Prelude"]),
    ]
)
