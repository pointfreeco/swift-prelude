// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "Prelude",
  products: [
    .library(name: "Either", targets: ["Either"]),
    .library(name: "Optics", targets: ["Optics"]),
    .library(name: "Prelude", targets: ["Prelude"]),
  ],
  dependencies: [
  ],
  targets: [
  .target(name: "Either", dependencies: ["Prelude"]),
  .testTarget(name: "EitherTests", dependencies: ["Either"]),
  .target(name: "Optics", dependencies: ["Prelude"]),
  .testTarget(name: "OpticsTests", dependencies: ["Optics"]),
  .target(name: "Prelude", dependencies: []),
  .testTarget(name: "PreludeTests", dependencies: ["Prelude"]),
  ]
)
