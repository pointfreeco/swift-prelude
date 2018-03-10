import Prelude
import Tuple
import XCTest

final class TupleTests: XCTestCase {

  func testTuples() {
    let tuple = 1 .*. "hello" .*. true .*. 2.0 .*. unit

    XCTAssertEqual(1, tuple |> get1)
    XCTAssertEqual("hello", tuple |> get2)
    XCTAssertEqual(true, tuple |> get3)
    XCTAssertEqual(2.0, tuple |> get4)
    XCTAssertTrue(
      2 .*. "hello" .*. true .*. 2.0 .*. unit == (tuple |> over1({ $0 + 1 }))
    )

    let loweredTuple = lower(tuple)

    XCTAssertEqual(1, loweredTuple.0)
    XCTAssertEqual("hello", loweredTuple.1)
    XCTAssertEqual(true, loweredTuple.2)
    XCTAssertEqual(2.0, loweredTuple.3)
  }
}
