import XCTest
import Prelude

class EitherTests: XCTestCase {
  func testMap() {
    XCTAssertEqual(2, (Either<Int, Int>.right(1) |> map { $0 + 1 }).right)
    XCTAssertEqual(1, (Either<Int, Int>.left(1) |> map { $0 + 1 }).left)
    XCTAssertEqual(2, Either<Int, Int>.right(1).map { $0 + 1 }.right)
    XCTAssertEqual(1, Either<Int, Int>.left(1).map { $0 + 1 }.left)
    XCTAssertEqual(2, ({ $0 + 1 } <¢> Either<Int, Int>.right(1)).right)
    XCTAssertEqual(1, ({ $0 + 1 } <¢> Either<Int, Int>.left(1)).left)
  }
}
