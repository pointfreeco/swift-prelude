import Prelude
import XCTest
import ValidationNearSemiring

class ValidationNearSemiringTests: XCTestCase {
  func testValidation() {
    func validate(name: String) -> Validation<FreeNearSemiring<String>, String> {
      return !name.isEmpty
        ? pure(name)
        : .invalid(.init([["name"]]))
    }

    func validate(email: String) -> Validation<FreeNearSemiring<String>, String> {
      return email.contains("@")
        ? pure(email)
        : .invalid(.init([["email"]]))
    }

    func validate(phone: String) -> Validation<FreeNearSemiring<String>, String> {
      return phone.count == 7
        ? pure(phone)
        : .invalid(.init([["phone"]]))
    }

    struct User {
      let first: String
      let last: String
      let contact: String
    }

    let createUser = { first in
      { last in
        { contact in
          User(first: first, last: last, contact: contact)
        }
      }
    }

    let (first, last, contact) = ("Stephen", "Celis", "stephen@pointfree.co")

    dump(
      createUser
        <¢> validate(name: first)
        <*> validate(name: last)
        <*> (validate(email: contact) <|> validate(phone: contact))
    )

    dump(
      createUser
        <¢> validate(name: "")
        <*> validate(name: "")
        <*> (validate(email: "") <|> validate(phone: ""))
    )
  }
}
