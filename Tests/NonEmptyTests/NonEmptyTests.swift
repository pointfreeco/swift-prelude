import NonEmpty
import Prelude
import XCTest

final class NonEmptyTests: XCTestCase {

  func testFirst() {
    let nonEmpty = 1 >| [2, 3]
    XCTAssertEqual(1, nonEmpty.first as Int)
  }

  func testLast() {
    XCTAssertEqual(3, (1 >| [2, 3]).last as Int)

    XCTAssertEqual(1, (1 >| []).last as Int)
  }

  func testCount() {
    let nonEmpty = 1 >| [2, 3]
    XCTAssertEqual(3, nonEmpty.count)
  }

  func testSubscript() {
    let nonEmptyArray = 1 >| [2, 3]
    XCTAssertEqual(1, nonEmptyArray[0])
    XCTAssertEqual(2, nonEmptyArray[1])
    XCTAssertEqual(3, nonEmptyArray[2])

    let nonEmptyString = "h" >| "ello"
    XCTAssertEqual("h", nonEmptyString[nonEmptyString.startIndex])
    XCTAssertEqual("e", nonEmptyString[nonEmptyString.index(after: nonEmptyString.startIndex)])
  }

  func testMutableNonEmptyArray() {
    var nonEmpty = 1 >| [2, 3]
    nonEmpty[0] = 98
    nonEmpty[1] = 99
    XCTAssertEqual(98 >| [99, 3], nonEmpty)
  }

  func testRangeReplaceable() {
    var nonEmpty = 1 >| [2, 3]
    nonEmpty.append(4)
    nonEmpty.append(contentsOf: [5, 6])
    nonEmpty.insert(0, at: 0)
    nonEmpty.insert(7, at: 6)

    XCTAssertEqual(0 >| [1, 2, 3, 4, 5, 6, 7], nonEmpty)
  }

//  func testSet() {
//    let nonEmpty = 1 >| Set([1, 2, 3])
//    XCTAssertEqual(3, nonEmpty.count)
//  }

  func testString() {
    let nonEmpty = "h" >| "ello"
    XCTAssertEqual(5, nonEmpty.count)
  }

  func testIso() {
    let xs = Array(1 >| [2, 3])
    XCTAssertEqual([1, 2, 3], xs)

    let cs = Character("a") >| "bc"
    XCTAssertEqual("abc", String(cs))
  }

  func testMap() {
    let xs = 1 >| [2, 3]
    let ys = 2 >| [3, 4]
    let f = { $0 + 1 }

    XCTAssertEqual(ys, xs.map(f))
    XCTAssertEqual(ys, f <¢> xs)
    XCTAssertEqual(ys, map(f) <| xs)
  }

  func testApply() {
    let xs = 1 >| [2, 3]
    let ys = 2 >| [3, 4]
    let f = { $0 + 1 } >| []

    XCTAssertEqual(ys, xs.apply(f))
    XCTAssertEqual(ys, f <*> xs)
    XCTAssertEqual(ys, apply(f) <| xs)
  }

  func testPure() {
    XCTAssertEqual(1 >| [], pure(1))
    XCTAssertEqual(2 >| Set(), pure(2))
    XCTAssertEqual("3" >| "", pure("3"))
  }

  func testFlatMap() {
    let xs = 1 >| [2, 3]
    let ys = 2 >| [3, 4]
    let f = { $0 + 1 >| [] }

    XCTAssertEqual(ys, xs.flatMap(f))
    XCTAssertEqual(ys, flatMap(f) <| xs)
  }
}
