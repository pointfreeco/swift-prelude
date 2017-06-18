import XCTest
import Prelude

class ArrayTests: XCTestCase {
  func testCatOptionals() {
    XCTAssertEqual([1, 2, 3], [1, nil, 2, nil, 3] |> catOptionals)
  }

  func testMapOptional() {
    XCTAssertEqual([2], [1, 2, 3] |> mapOptional { $0 % 2 == 0 ? $0 : nil })
  }
}
