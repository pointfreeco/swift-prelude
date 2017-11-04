import NonEmpty
import Prelude
import XCTest

final class NonEmptyTests: XCTestCase {

  func testFirst() {
    let nonEmpty = 1 >| [2, 3]
    XCTAssertEqual(1, nonEmpty.first as Int)
    XCTAssertEqual(1, nonEmpty.first as Int?)
  }

  func testLast() {
    XCTAssertEqual(3, (1 >| [2, 3]).last as Int)
    XCTAssertEqual(3, (1 >| [2, 3]).last as Int?)

    XCTAssertEqual(1, (1 >| []).last as Int)
    XCTAssertEqual(1, (1 >| []).last as Int?)
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

    let nonEmptyString = Character("h") >| "i"
    XCTAssertEqual("h", nonEmptyString[nonEmptyString.startIndex])
    XCTAssertEqual("i", nonEmptyString[nonEmptyString.index(after: nonEmptyString.startIndex)])
  }

  func testMutableNonEmptyArray() {
    var nonEmpty = 1 >| [2, 3]
    nonEmpty[0] = 98
    nonEmpty[1] = 99
    XCTAssert((98 >| [99, 3]) == nonEmpty)
  }

  func testMutableAppend() {
    var nonEmpty = 1 >| [2, 3]
    nonEmpty.append(4)
    XCTAssert((1 >| [2, 3, 4]) == nonEmpty)
  }

  func testMutablePopLast() {
    var nonEmpty = 1 >| [2]
    XCTAssertEqual(.some(2), nonEmpty.popLast())
    XCTAssertNil(nonEmpty.popLast())
    XCTAssert((1 >| []) == nonEmpty)
  }

  func testSet() {
    let nonEmpty = 1 >| Set([1, 2, 3])
    XCTAssertEqual(3, nonEmpty.count)
    XCTAssertEqual(3, (nonEmpty <> nonEmpty <> 3 >| [2, 1]).count)
  }

  func testString() {
    let nonEmpty = Character("h") >| "ello"
    XCTAssertEqual(5, nonEmpty.count)
  }

  func testIterator() {
    let iterator = (1 >| [2, 3]).makeIterator()
    XCTAssertEqual(1, iterator.next())
    XCTAssertEqual(2, iterator.next())
    XCTAssertEqual(3, iterator.next())
    XCTAssertNil(iterator.next())
  }

  func testUncons() {
    let (x, xs) = (1 >| [2, 3]) |> uncons
    XCTAssertEqual(1, x)
    XCTAssertEqual([2, 3], xs)
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
    let f: (Int) -> Int = { $0 + 1 }

    XCTAssert(ys == xs.map(f))
    XCTAssert(ys == (f <¢> xs))
    XCTAssert(ys == (map(f) <| xs))
  }

  func testApply() {
    let xs = 1 >| [2, 3]
    let ys = 2 >| [3, 4]
    let f: NonEmptyArray<(Int) -> Int> = { $0 + 1 } >| []

    XCTAssert(ys == xs.apply(f))
    XCTAssert(ys == (f <*> xs))
    XCTAssert(ys == (apply(f) <| xs))
  }

  func testPure() {
    XCTAssert((1 >| []) == pure(1))
    XCTAssert((2 >| Set()) == pure(2))
    XCTAssert((Character("3") >| "") == pure("3"))
  }

  func testFlatMap() {
    let xs = 1 >| [2, 3]
    let ys = 2 >| [3, 4]
    let f: (Int) -> NonEmptyArray<Int> = { $0 + 1 >| [] }

    XCTAssert(ys == xs.flatMap(f))
    XCTAssert(ys == (xs >>- f))
    XCTAssert(ys == (flatMap(f) <| xs))
  }

  func testInequality() {
    XCTAssert((1 >| [2, 3]) != (99 >| [2, 3]))
    XCTAssert((1 >| [2, 3]) != (1 >| [99, 3]))
  }

  func testSemigroup() {
    XCTAssert(((1 >| [2, 3]) <> (4 >| [5, 6])) == (1 >| [2, 3, 4, 5, 6]))
    XCTAssert(((1 >| Set([2, 3])) <> (4 >| Set([5, 6]))) == (1 >| Set([2, 3, 4, 5, 6])))
    XCTAssert(((Character("a") >| "bc") <> (Character("d") >| "ef")) == (Character("a") >| "bcdef"))
  }
}
