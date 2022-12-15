import XCTest
import Prelude

@MainActor
class ParallelTests: XCTestCase {
  func testParallel() async {
    let add: (Int) -> (Int) -> Int = { x in { y in x + y } }
    let x = pure(1).delay(0.1)
    let y = pure(2).delay(0.1)

    let result = await (sequential <| add <¢> parallel(x) <*> parallel(y)).performAsync()
    XCTAssertEqual(3, result)
  }

  func testRace() async {
    let x = pure("tortoise").delay(0.1)
    let y = pure("hare").delay(1)

    var result = await (sequential <| parallel(x) <|> parallel(y)).performAsync()
    XCTAssertEqual("tortoise", result)
    result = await (sequential <| parallel(y) <|> parallel(x)).performAsync()
    XCTAssertEqual("tortoise", result)
  }

  func testSequenceThreadSafety() async {
    let bigArray = Array(1...20)

    let parallels: [Parallel<Int>] = bigArray.map { idx in
      pure(idx)
        .delay(1)
        .parallel
    }

    let result = await sequence(parallels).sequential.performAsync()
    XCTAssertEqual(bigArray, result)
  }

  func testApplyThreadSafety() async {
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

    let array = await result.sequential.performAsync()
    XCTAssertEqual(Array(1...10), array)
  }

  func testAltThreadSafety() async {
    let sentinel: Parallel<Int> = pure(-1)
      .delay(TimeInterval(0.5))
      .parallel

    let result = Array(1...20).map { idx in
      pure(idx)
        .delay(TimeInterval(idx))
        .parallel
      }
      .reduce(sentinel) { $0 <|> $1 }

    let n = await result.sequential.performAsync()
    XCTAssertEqual(-1, n)
  }
}
