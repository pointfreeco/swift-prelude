import Prelude
import XCTest
import Either

class NestedTests: XCTestCase {
  func testNested() {
    let either: Either3<Int, String, Bool> = inj2("hello world")

    XCTAssertEqual(nil, get1(either))
    XCTAssertEqual("hello world", get2(either))
    XCTAssertEqual(nil, get3(either))
    XCTAssertTrue(inj2("hello world") == either)
  }
}
