import Prelude
import XCTest
import ValidationSemigroup
import SnapshotTesting

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

let createUser = { first in
{ last in
  { contact in
    User(first: first, last: last, email: contact)
  }
  }
}

class ValidationNearSemiringTests: XCTestCase {
  func testValidData() {
    let user = createUser
      <¢> validate(name: "Stephen")
      <*> validate(name: "Celis")
      <*> validate(email: "stephen@pointfree.co")

    assertSnapshot(any: user)
  }

  func testInvalidData() {
    let user = createUser
      <¢> validate(name: "")
      <*> validate(name: "")
      <*> validate(email: "stephen")

    assertSnapshot(any: user)
  }
}
