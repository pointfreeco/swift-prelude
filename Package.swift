// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "Prelude",
  products: [
    .library(name: "Either", targets: ["Either"]),
    .library(name: "Frp", targets: ["Frp"]),
    .library(name: "Optics", targets: ["Optics"]),
    .library(name: "Prelude", targets: ["Prelude"]),
    .library(name: "ValidationSemigroup", targets: ["ValidationSemigroup"]),
    .library(name: "ValidationNearSemiring", targets: ["ValidationNearSemiring"]),
    ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", .revision("2c2b390")),
  ],
  targets: [
    .target(name: "Either", dependencies: ["Prelude"]),
    .testTarget(name: "EitherTests", dependencies: ["Either"]),
    .target(name: "Frp", dependencies: ["Prelude", "ValidationSemigroup"]),
    .testTarget(name: "FrpTests", dependencies: ["Frp"]),
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
