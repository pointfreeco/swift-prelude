import XCTest
import Prelude

class KeyPathTests: XCTestCase {
  func testGet() {
    XCTAssertEqual(3, [1, 2, 3] |> get(\.count))
  }

  func testOver() {
    let user = User(id: 1)
    let newUser = (over(\User.id) <| { $0 + 1 }) <| user

    XCTAssertEqual(2, newUser.id)
  }

  func testSet() {
    let user = User(id: 1)
    let newUser = (set(\User.id) <| 2) <| user

    XCTAssertEqual(2, newUser.id)
  }
}

fileprivate struct User {
  var id: Int
}
