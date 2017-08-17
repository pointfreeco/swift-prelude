import XCTest
import Prelude

private func after<A>(_ interval: TimeInterval, _ x: A) -> Parallel<A> {
  return .init { f in
    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
      f(x)
    }
  }
}

class ParallelTests: XCTestCase {
  func testParallel() {
    let add: (Int) -> (Int) -> Int = { x in { y in x + y } }
    let x = after(0.01, 1)
    let y = after(0.01, 2)

    let expectation = self.expectation(description: "Parallel")
    (add <¢> x <*> y).run {
      XCTAssertEqual(3, $0)
      expectation.fulfill()
    }
    self.waitForExpectations(timeout: 0.01, handler: nil)
  }

  func testRace() {
    let x = after(0.01, "tortoise")
    let y = after(0.02, "hare")

    let expectationXY = self.expectation(description: "Parallel")
    (x <|> y).run {
      XCTAssertEqual("tortoise", $0)
      expectationXY.fulfill()
    }

    let expectationYX = self.expectation(description: "Parallel")
    (y <|> x).run {
      XCTAssertEqual("tortoise", $0)
      expectationYX.fulfill()
    }
    self.waitForExpectations(timeout: 0.02, handler: nil)
  }

  func testPerformIO() {
    let x: IO<Int> = pure(1)
    let y: IO<Int> = pure(2)

    let add: (Int) -> (Int) -> Int = { x in { y in x + y } }

    let z = Prelude.run <| add <¢> parallel(x) <*> parallel(y)

    XCTAssertEqual(3, z.perform())
  }
}
