import Prelude
import XCTest
import ValidationSemigroup
import SnapshotTesting

#if !os(Linux)
typealias SnapshotTestCase = XCTestCase
#endif

func validate(name: String) -> Validation<[String], String> {
  return !name.isEmpty
    ? pure(name)
    : .invalid(["name"])
}

func validate(email: String) -> Validation<[String], String> {
  return email.contains("@")
    ? pure(email)
    : .invalid(["email"])
}

struct User {
  let first: String
  let last: String
  let email: String
}

let createUser = { first in { last in { contact in User(first: first, last: last, email: contact) } } }

class ValidationSemigroupTests: SnapshotTestCase {
  override func setUp() {
    super.setUp()
//    record = true
  }
  func testValidData() {
    let user = createUser
      <¢> validate(name: "Stephen")
      <*> validate(name: "Celis")
      <*> validate(email: "stephen@pointfree.co")

    assertSnapshot(matching: user, as: .dump)
  }

  func testInvalidData() {
    let user = createUser
      <¢> validate(name: "")
      <*> validate(name: "")
      <*> validate(email: "stephen")

    assertSnapshot(matching: user, as: .dump)
  }
}
