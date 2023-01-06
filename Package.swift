// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "swift-prelude",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "Either", targets: ["Either"]),
    .library(name: "Frp", targets: ["Frp"]),
    .library(name: "Optics", targets: ["Optics"]),
    .library(name: "Prelude", targets: ["Prelude"]),
    .library(name: "Reader", targets: ["Reader"]),
    .library(name: "State", targets: ["State"]),
    .library(name: "Tuple", targets: ["Tuple"]),
    .library(name: "ValidationSemigroup", targets: ["ValidationSemigroup"]),
    .library(name: "ValidationNearSemiring", targets: ["ValidationNearSemiring"]),
    .library(name: "Writer", targets: ["Writer"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.0"),
  ],
  targets: [
    .target(
      name: "Either",
      dependencies: [
        "Prelude",
        .product(name: "Dependencies", package: "swift-dependencies"),
      ]
    ),
    .testTarget(name: "EitherTests", dependencies: ["Either"]),

    .target(name: "Frp", dependencies: ["Prelude", "ValidationSemigroup"]),
    .testTarget(name: "FrpTests", dependencies: ["Frp"]),

    .target(name: "Optics", dependencies: ["Prelude", "Either"]),
    .testTarget(name: "OpticsTests", dependencies: ["Optics"]),

    .target(
      name: "Prelude",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
      ]
    ),
    .testTarget(name: "PreludeTests", dependencies: ["Prelude"]),

    .target(name: "Reader", dependencies: ["Prelude"]),
    .testTarget(name: "ReaderTests", dependencies: ["Reader"]),

    .target(name: "State", dependencies: ["Prelude"]),
    .testTarget(name: "StateTests", dependencies: ["State"]),

    .target(name: "Tuple", dependencies: ["Prelude"]),
    .testTarget(name: "TupleTests", dependencies: ["Tuple"]),

    .target(name: "ValidationSemigroup", dependencies: ["Prelude"]),
    .testTarget(name: "ValidationSemigroupTests", dependencies: ["ValidationSemigroup"]),

    .target(name: "ValidationNearSemiring", dependencies: ["Prelude", "Either"]),
    .testTarget(name: "ValidationNearSemiringTests", dependencies: ["ValidationNearSemiring"]),

    .target(name: "Writer", dependencies: ["Prelude"]),
    .testTarget(name: "WriterTests", dependencies: ["Writer"]),
  ]
)
