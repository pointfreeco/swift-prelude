import Either
import Optics
import Prelude
import XCTest

class ProfunctorTests: XCTestCase {
  func testLens() {

    let data: [Either<[Int?], String>] = [
      .left([1, 2, nil, 3]),
      .right("hello!")
    ]

    dump(data |> traversed <<< left <<< traversed <<< some +~ 1)
    dump(data .^ ix(0))
    dump(data |> ix(0) <<< left <<< ix(0) .~ 99)

    XCTAssertEqual([1, 99, 3], [1, 2, 3] |> ix(1) .~ 99)

    dump(["hell", "o"] .^ traversed)
  }
}
