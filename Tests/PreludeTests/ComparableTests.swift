import XCTest
import Prelude

class ComparableTests: XCTestCase {
  func testClamp() {
    XCTAssertEqual(1, -1 |> clamp(1..<10))
    XCTAssertEqual(9, 11 |> clamp(1..<10))

    XCTAssertEqual(10, 11 |> clamp(1...10))
  }
}
