import Either
import Prelude
import SnapshotTesting
import ValidationNearSemiring
import XCTest

#if !os(Linux)
typealias SnapshotTestCase = XCTestCase
#endif

func validate(name: String) -> Validation<FreeNearSemiring<String>, String> {
  return !name.isEmpty
    ? pure(name)
    : .invalid(.init([["name"]]))
}

func validate(bio: String) -> Validation<FreeNearSemiring<String>, String> {
  return bio.count <= 10
    ? pure(bio)
    : .invalid(.init([["bio"]]))
}

func validate(email: String) -> Validation<FreeNearSemiring<String>, Email> {
  return email.contains("@")
    ? pure(email)
    : .invalid(.init([["email"]]))
}

func validate(phone: String) -> Validation<FreeNearSemiring<String>, Phone> {
  return phone.count == 7
    ? pure(phone)
    : .invalid(.init([["phone"]]))
}

typealias Email = String
typealias Phone = String

struct User {
  let name: String
  let bio: String
  let contact: Either<Email, Phone>
}

let createUser = { name in { bio in { contact in User(name: name, bio: bio, contact: contact) } } }

class ValidationNearSemiringTests: SnapshotTestCase {
  override func setUp() {
    super.setUp()
//    record = true
  }

  func testValidData() {
    let user = createUser
      <¢> validate(name: "Stephen")
      <*> validate(bio: "Stuff")
      <*> (validate(email: "stephen@pointfree.co").map(Either.left) <|> validate(phone: "").map(Either.right))
    assertSnapshot(matching: user, as: .dump)
  }

  func testInvalidData() {
    let user = createUser
      <¢> validate(name: "")
      <*> validate(bio: "Doin lots of stuff")
      <*> (validate(email: "stephen").map(Either.left) <|> validate(phone: "123456").map(Either.right))
    assertSnapshot(matching: user, as: .dump)
  }
}
