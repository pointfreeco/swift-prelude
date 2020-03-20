import Either
import Prelude
import ValidationNearSemiring
import XCTest

func validate(name: String) -> Validation<FreeNearSemiring<String>, String> {
  !name.isEmpty
    ? pure(name)
    : .invalid(.init([["name"]]))
}

func validate(bio: String) -> Validation<FreeNearSemiring<String>, String> {
  bio.count <= 10
    ? pure(bio)
    : .invalid(.init([["bio"]]))
}

func validate(email: String) -> Validation<FreeNearSemiring<String>, Email> {
  email.contains("@")
    ? pure(email)
    : .invalid(.init([["email"]]))
}

func validate(phone: String) -> Validation<FreeNearSemiring<String>, Phone> {
  phone.count == 7
    ? pure(phone)
    : .invalid(.init([["phone"]]))
}

typealias Email = String
typealias Phone = String

struct User: Equatable {
  let name: String
  let bio: String
  let contact: Either<Email, Phone>
}

let createUser = { name in { bio in { contact in User(name: name, bio: bio, contact: contact) } } }

class ValidationNearSemiringTests: XCTestCase {
  func testValidData() {
    let user = createUser
      <¢> validate(name: "Stephen")
      <*> validate(bio: "Stuff")
      <*> (validate(email: "stephen@pointfree.co").map(Either.left) <|> validate(phone: "").map(Either.right))
    XCTAssertEqual(
      .valid(
        User(
          name: "Stephen",
          bio: "Stuff",
          contact: .left("stephen@pointfree.co")
        )
      ),
      user
    )
  }

  func testInvalidData() {
    let user = createUser
      <¢> validate(name: "")
      <*> validate(bio: "Doin lots of stuff")
      <*> (validate(email: "stephen").map(Either.left) <|> validate(phone: "123456").map(Either.right))
    XCTAssertEqual(
      .invalid(
        .init([
          ["name", "bio", "email"],
          ["name", "bio", "phone"]
        ])
      ),
      user
    )
  }
}
