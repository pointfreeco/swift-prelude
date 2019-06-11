import Prelude
import XCTest
import ValidationSemigroup

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

struct User: Equatable {
  let first: String
  let last: String
  let email: String
}

let createUser = { first in { last in { contact in User(first: first, last: last, email: contact) } } }

class ValidationSemigroupTests: XCTestCase {
  func testValidData() {
    let user = createUser
      <¢> validate(name: "Stephen")
      <*> validate(name: "Celis")
      <*> validate(email: "stephen@pointfree.co")

    XCTAssertEqual(
      .valid(
        User(
          first: "Stephen",
          last: "Celis",
          email: "stephen@pointfree.co"
        )
      ),
      user
    )
  }

  func testInvalidData() {
    let user = createUser
      <¢> validate(name: "")
      <*> validate(name: "")
      <*> validate(email: "stephen")

    XCTAssertEqual(
      .invalid(
        ["name", "name", "email"]
      ),
      user
    )
  }
}
