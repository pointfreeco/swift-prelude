import XCTest
import Prelude

class SequenceTests: XCTestCase {
  func testCatOptionals() {
    XCTAssertEqual([1, 2, 3], [1, nil, 2, nil, 3] |> catOptionals)
  }

  func testMapOptional() {
    XCTAssertEqual([2], [1, 2, 3] |> mapOptional { $0 % 2 == 0 ? $0 : nil })
  }

  func testConcat() {
    XCTAssertEqual("foobar", ["foo", "bar"].concat())
  }

  func testIntersperse() {
    XCTAssertEqual([1, 0, 2, 0, 3], intersperse(0)([1, 2, 3]))
    XCTAssertEqual([1], intersperse(0)([1]))
    XCTAssertEqual([], intersperse(0)([]))
  }
}
