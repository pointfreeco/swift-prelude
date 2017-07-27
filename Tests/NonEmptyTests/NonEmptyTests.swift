import NonEmpty
import Prelude
import XCTest

final class NonEmptyTests: XCTestCase {

  func testFirst() {
    let nonEmpty = 1 >| [2]
    XCTAssertEqual(1, nonEmpty.first as Int)
    XCTAssertEqual(1, nonEmpty.first as Int?)
  }

  func testMutableNonEmptyArray() {
    var nonEmpty = 1 >| [2, 3]
    nonEmpty[1] = 99
    XCTAssert((1 >| [99, 3]) == nonEmpty)
  }
}
