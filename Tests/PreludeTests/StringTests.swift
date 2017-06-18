import XCTest
import Prelude

class StringTests: XCTestCase {
  func testJoined() {
    XCTAssertEqual("", [] |> joined(" "))
    XCTAssertEqual("hello", ["hello"] |> joined(" "))
    XCTAssertEqual("hello world", ["hello", "world"] |> joined(" "))
  }
}
