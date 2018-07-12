import XCTest
import Prelude

func random(min: Int, max: Int) -> Int {
  #if os(Linux)
  return Int(random() % max) + min
  #else
  return Int(arc4random_uniform(UInt32(max)) + UInt32(min))
  #endif
}

class ParallelTests: XCTestCase {
  override func setUp() {
    super.setUp()
    #if os(Linux)
    srandom(UInt32(time(nil)))
    #endif
  }

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

  func testThreadSafety() {
    let bigArray = Array(1...500)

    let parallels: [Parallel<Int>] = bigArray.map { idx in
      pure(idx)
        .delay(TimeInterval(random(min: 0, max: 1_000_000) / 10_000_000))
        .parallel
    }

    XCTAssertEqual(bigArray, sequence(parallels).sequential.perform())
  }
}
