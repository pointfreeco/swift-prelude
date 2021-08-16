# swift-prelude

[![Swift 5.1](https://img.shields.io/badge/swift-5.1-ED523F.svg?style=flat)](https://swift.org/download/)
[![CI](https://github.com/pointfreeco/swift-prelude/workflows/CI/badge.svg)](https://actions-badge.atrox.dev/pointfreeco/swift-prelude/goto)
[![@pointfreeco](https://img.shields.io/badge/contact-@pointfreeco-5AA9E7.svg?style=flat)](https://twitter.com/pointfreeco)

A collection of frameworks to enhance the Swift language.

## Stability

This library should be considered experimental. If you find its contents useful, please consider maintaining a fork.

## Installation

```swift
import PackageDescription

let package = Package(
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-prelude.git", .branch("main")),
  ]
)
```

## Table of Contents

* [`Prelude`](#prelude)
* [`Either`](#either)
* [`Optics`](#optics)
* [`ValidationSemigroup`](#validationsemigroup)
* [`ValidationNearSemiring`](#validationnearsemiring)

## `Prelude`

A collection of types and functions to build powerful abstractions and enhance the Swift standard library.

## `Either`

A type to express a value that holds one of two other types.

```swift
import Either

let intOrString = Either<Int, String>.left(2)

intOrString
  .bimap({ $0 + 1 }, { $0 + "!" }) // => .left(3)
```

## `Optics`

A `Lens` type and a bridge between the lens world and the Swift key path world.

```swift
import Optics
import Prelude

struct User {
  var id: Int
  var name: String
}

let uppercased: (String) -> String = { $0.uppercased() }

let user = User(id: 1, name: "Blob")

user
  |> \.id .~ 2
  |> \.name %~ uppercased

// => User(2, "BLOB")
```

## `ValidationSemigroup`

The `Validation<E, A>` type is a type similar to `Result<E, A>`, except it is given a different applicative instance in the case that `E` is a semigroup. This allows you to accumulate multiple errors into `E` instead of just taking the first error:

```swift
import Prelude
import ValidationSemigroup

struct User { let name: String; let bio: String; let email: String }
let createUser = { name in { bio in { email in User(name: name, bio: bio, email: email) } } }

func validate(name: String) -> Validation<[String], String> {
  return !name.isEmpty
    ? pure(name)
    : .invalid(["Name must be at least 1 character."])
}

func validate(bio: String) -> Validation<[String], String> {
  return bio.count <= 10
    ? pure(bio)
    : .invalid(["Bio must 10 characters or less."])
}

func validate(email: String) -> Validation<[String], String> {
  return email.contains("@")
    ? pure(email)
    : .invalid(["Email must be valid."])
}

let validUser = pure(createUser)
  <*> validate(name: "Blob")
  <*> validate(bio: "I'm a blob")
  <*> validate(email: "blob@pointfree.co")
// => .valid(User(name: "Blob", bio: "I'm a blob", email: "blob@pointfree.co"))

let invalidUser = pure(createUser)
  <*> validate(name: "Blob")
  <*> validate(bio: "Blobbin around the world")
  <*> validate(email: "blob")
// => .invalid(["Bio must 10 characters or less.", "Email must be valid."])
```

For more information, watch [Stephen Celis’](http://www.twitter.com/stephencelis) [talk](https://www.youtube.com/watch?v=Awva79gjoHY).

## `ValidationNearSemiring`

This `Validation<E, A>` type is a type similar to `Result<E, A>` and the above `Validation`, except it is given a different applicative instance in the case that `E` is a `NearSemiring`. This allows you to accumulate errors that describe conditions that hold with both “and” and “or”, e.g. name is required _and_ either email _or_ phone is required.

## License

All modules are released under the MIT license. See [LICENSE](LICENSE) for details.
