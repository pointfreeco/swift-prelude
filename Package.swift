// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "Prelude",
  products: [
    .library(name: "Either", targets: ["Either"]),
    .library(name: "Frp", targets: ["Frp"]),
    .library(name: "NonEmpty", targets: ["NonEmpty"]),
    .library(name: "Optics", targets: ["Optics"]),
    .library(name: "Prelude", targets: ["Prelude"]),
    .library(name: "Reader", targets: ["Reader"]),
    .library(name: "State", targets: ["State"]),
    .library(name: "ValidationSemigroup", targets: ["ValidationSemigroup"]),
    .library(name: "ValidationNearSemiring", targets: ["ValidationNearSemiring"]),
    .library(name: "Writer", targets: ["Writer"]),
    ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", .revision("1507864")),
  ],
  targets: [
    .target(name: "Either", dependencies: ["Prelude"]),
    .testTarget(name: "EitherTests", dependencies: ["Either"]),

    .target(name: "Frp", dependencies: ["Prelude", "ValidationSemigroup"]),
    .testTarget(name: "FrpTests", dependencies: ["Frp", "SnapshotTesting"]),

    .target(name: "NonEmpty", dependencies: ["Prelude"]),
    .testTarget(name: "NonEmptyTests", dependencies: ["NonEmpty"]),

    .target(name: "Optics", dependencies: ["Prelude", "Either"]),
    .testTarget(name: "OpticsTests", dependencies: ["Optics", "SnapshotTesting"]),

    .target(name: "Prelude", dependencies: []),
    .testTarget(name: "PreludeTests", dependencies: ["Prelude"]),

    .target(name: "Reader", dependencies: ["Prelude"]),
    .testTarget(name: "ReaderTests", dependencies: ["Reader"]),

    .target(name: "State", dependencies: ["Prelude"]),
    .testTarget(name: "StateTests", dependencies: ["State"]),

    .target(name: "ValidationSemigroup", dependencies: ["Prelude"]),
    .testTarget(name: "ValidationSemigroupTests", dependencies: ["ValidationSemigroup", "SnapshotTesting"]),

    .target(name: "ValidationNearSemiring", dependencies: ["Prelude"]),
    .testTarget(name: "ValidationNearSemiringTests", dependencies: ["ValidationNearSemiring", "SnapshotTesting"]),

    .target(name: "Writer", dependencies: ["Prelude"]),
    .testTarget(name: "WriterTests", dependencies: ["Writer"]),
    ]
)
