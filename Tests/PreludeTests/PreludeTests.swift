import XCTest
import Prelude

class PreludeTests: XCTestCase {
  func testExample() {
  }

  func testJoined() {
    XCTAssertEqual("", [] |> joined(" "))
    XCTAssertEqual("hello", ["hello"] |> joined(" "))
    XCTAssertEqual("hello world", ["hello", "world"] |> joined(" "))
  }

  static var allTests = [
    ("testExample", testExample),
    ]
}
