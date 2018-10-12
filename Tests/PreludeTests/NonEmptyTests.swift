import Prelude
import XCTest

final class NonEmptyTests: XCTestCase {
  func testMap() {
    let xs = NonEmptyArray(1, 2, 3)
    let ys = NonEmptyArray(2, 3, 4)
    let f = { $0 + 1 }

    XCTAssertEqual(ys, xs.map(f))
    XCTAssertEqual(ys, f <¢> xs)
    XCTAssertEqual(ys, map(f) <| xs)
  }

  func testApply() {
    let xs = NonEmptyArray(1, 2, 3)
    let ys = NonEmptyArray(2, 3, 4)
    let f = NonEmptyArray({ $0 + 1 })

    XCTAssertEqual(ys, xs.apply(f))
    XCTAssertEqual(ys, f <*> xs)
    XCTAssertEqual(ys, apply(f) <| xs)
  }

  func testPure() {
    XCTAssertEqual(NonEmptyArray(1), pure(1))
    XCTAssertEqual(NonEmptySet(2), pure(2))
    XCTAssertEqual(NonEmptyString("3"), pure("3"))
  }

  func testFlatMap() {
    let xs = NonEmptyArray(1, 2, 3)
    let ys = NonEmptyArray(2, 3, 4)
    let f = { NonEmptyArray($0 + 1) }

    XCTAssertEqual(ys, xs.flatMap(f))
    XCTAssertEqual(ys, flatMap(f) <| xs)
  }
}
