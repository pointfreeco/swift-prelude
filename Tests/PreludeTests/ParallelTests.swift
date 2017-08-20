import XCTest
import Prelude

class ParallelTests: XCTestCase {
  func testParallel() {
    let add: (Int) -> (Int) -> Int = { x in { y in x + y } }
    let x = pure(1).delay(0.01)
    let y = pure(2).delay(0.01)

    let expectation = self.expectation(description: "Parallel")
    (add <¢> parallel(x) <*> parallel(y)).run {
      XCTAssertEqual(3, $0)
      expectation.fulfill()
    }
    self.waitForExpectations(timeout: 0.01, handler: nil)
  }

  func testRace() {
    let x = pure("tortoise").delay(0.01)
    let y = pure("hare").delay(0.02)

    let expectation = self.expectation(description: "Parallel")
    (parallel(x) <|> parallel(y)).run {
      XCTAssertEqual("tortoise", $0)
      expectation.fulfill()
    }
    self.waitForExpectations(timeout: 0.01, handler: nil)

    XCTAssertEqual("tortoise", (sequential <| parallel(y) <|> parallel(x)).perform())
  }

  func testPerformIO() {
    let x: IO<Int> = pure(1)
    let y: IO<Int> = pure(2)

    let add: (Int) -> (Int) -> Int = { x in { y in x + y } }

    let z = sequential <| add <¢> parallel(x) <*> parallel(y)

    XCTAssertEqual(3, z.perform())
  }
}
