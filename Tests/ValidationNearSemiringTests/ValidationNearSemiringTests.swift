import Prelude
import SnapshotTesting
import ValidationNearSemiring
import XCTest

public func assertSnapshot(
  any snapshot: Any,
  identifier: String? = nil,
  file: StaticString = #file,
  function: String = #function,
  line: UInt = #line)
{
  var string = ""
  dump(snapshot, to: &string)

  assertSnapshot(
    matching: string,
    identifier: identifier,
    pathExtension: "txt",
    file: file,
    function: function,
    line: line
  )
}

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

let createUser = { first in { last in { contact in User(first: first, last: last, contact: contact) } } }

class ValidationNearSemiringTests: XCTestCase {
  func testValidData() {
    let user = createUser
      <¢> validate(name: "Stephen")
      <*> validate(name: "Celis")
      <*> (validate(email: "stephen@pointfree.co") <|> validate(phone: ""))
    assertSnapshot(any: user)
  }

  func testInvalidData() {
    let user = createUser
      <¢> validate(name: "")
      <*> validate(name: "")
      <*> (validate(email: "stephen") <|> validate(phone: "123456"))
    assertSnapshot(any: user)
  }
}
