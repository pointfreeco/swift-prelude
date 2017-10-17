import Prelude
import Tuple
import XCTest

final class TupleTests: XCTestCase {

  func testTuples() {
    let tuple = 1 .*. "hello" .*. true .*. 2.0

    XCTAssertEqual(1, tuple |> get1)
    XCTAssertEqual("hello", tuple |> get2)
    XCTAssertEqual(true, tuple |> get3)
    XCTAssertEqual(2.0, tuple |> get4)
    XCTAssertEqual(2, tuple |> over1({ $0 + 1 }) |> get1)
  }
}
