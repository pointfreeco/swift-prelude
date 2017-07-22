// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "Prelude",
  products: [
    .library(name: "Either", targets: ["Either"]),
    .library(name: "Optics", targets: ["Optics"]),
    .library(name: "Prelude", targets: ["Prelude"]),
    .library(name: "ValidationSemigroup", targets: ["ValidationSemigroup"]),
    .library(name: "ValidationNearSemiring", targets: ["ValidationNearSemiring"]),
    ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", .revision("b06511e")),
  ],
  targets: [
    .target(name: "Either", dependencies: ["Prelude"]),
    .testTarget(name: "EitherTests", dependencies: ["Either"]),
    .target(name: "Optics", dependencies: ["Prelude"]),
    .testTarget(name: "OpticsTests", dependencies: ["Optics"]),
    .target(name: "Prelude", dependencies: []),
    .testTarget(name: "PreludeTests", dependencies: ["Prelude"]),
    .target(name: "ValidationSemigroup", dependencies: ["Prelude"]),
    .testTarget(name: "ValidationSemigroupTests", dependencies: ["ValidationSemigroup", "SnapshotTesting"]),
    .target(name: "ValidationNearSemiring", dependencies: ["Prelude"]),
    .testTarget(name: "ValidationNearSemiringTests", dependencies: ["ValidationNearSemiring", "SnapshotTesting"]),
    ]
)
