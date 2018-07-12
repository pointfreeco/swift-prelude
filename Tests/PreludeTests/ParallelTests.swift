import XCTest
import Prelude

class ParallelTests: XCTestCase {
  func testParallel() {
    let add: (Int) -> (Int) -> Int = { x in { y in x + y } }
    let x = pure(1).delay(0.1)
    let y = pure(2).delay(0.1)

    XCTAssertEqual(3, (sequential <| add <¢> parallel(x) <*> parallel(y)).perform())
  }

  func testRace() {
    let x = pure("tortoise").delay(0.1)
    let y = pure("hare").delay(0.2)

    XCTAssertEqual("tortoise", (sequential <| parallel(x) <|> parallel(y)).perform())
    XCTAssertEqual("tortoise", (sequential <| parallel(y) <|> parallel(x)).perform())
  }

  func testSequenceThreadSafety() {
    let bigArray = Array(1...500)

    let parallels: [Parallel<Int>] = bigArray.map { idx in
      pure(idx)
        .delay(1)
        .parallel
    }

    XCTAssertEqual(bigArray, sequence(parallels).sequential.perform())
  }

  func testApplyThreadSafety() {
    let create = curry <| { (a, b, c, d, e, f, g, h, i, j) -> [Int] in
      [a, b, c, d, e, f, g, h, i, j]
    }

    let parallels: [Parallel<Int>] = (1...10).map {
      pure($0)
        .delay(1)
        .parallel
    }

    let result: Parallel<[Int]> = pure(create)
      <*> parallels[0]
      <*> parallels[1]
      <*> parallels[2]
      <*> parallels[3]
      <*> parallels[4]
      <*> parallels[5]
      <*> parallels[6]
      <*> parallels[7]
      <*> parallels[8]
      <*> parallels[9]

    XCTAssertEqual(Array(1...10), result.sequential.perform())
  }

  func testAltThreadSafety() {
    let sentinel: Parallel<Int> = pure(-1)
      .delay(TimeInterval(0.5))
      .parallel

    let result = Array(1...500).map { idx in
      pure(idx)
        .delay(TimeInterval(idx))
        .parallel
      }
      .reduce(sentinel) { $0 <|> $1 }


    XCTAssertEqual(-1, result.sequential.perform())
  }
}
