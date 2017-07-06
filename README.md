# swift-prelude [![CircleCI](https://circleci.com/gh/pointfreeco/swift-prelude.svg?style=svg)](https://circleci.com/gh/pointfreeco/swift-prelude)

A collection of frameworks to enhance the Swift language.

## Stability

This library should be considered alpha, and not stable. Breaking changes will happen often.

## Installation

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-prelude.git", .branch("master")),
    ]
)
```

## Table of Contents

* [`Prelude`](#prelude)
* [`Either`](#either)
* [`Optics`](#optics)

## Prelude

A collection of types and functions to build powerful abstractions and enhance the Swift standard library.

## Either

A type to express a value that holds one of two other types.

```swift
let intOrString = Either<Int, String>.left(2)

bimap({ $0 + 1 })({ $0 + "!" })(intOrString) // => .left(3)
```

## Optics

A `Lens` type and a bridge between the lens world and the Swift keypath world.

```swift
struct User {
  var id: Int
  var name: String
}

let uppercase: (String) -> String = { $0.uppercased() }

let user = User(id: 1, name: "Blob")

user
  |> \.id .~ 2
  |> \.name %~ uppercased

// => User(2, "BLOB")
```

## License

All modules are released under the MIT license. See [LICENSE](LICENSE) for details.
