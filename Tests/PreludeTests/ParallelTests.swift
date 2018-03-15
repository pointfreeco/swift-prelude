import XCTest
import Prelude
import Tuple

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

  func testZip() {

    let a = pure("a").delay(0.1).parallel
    let b = pure("b").delay(0.2).parallel
    let c = pure("c").delay(0.3).parallel
    let d = pure("d").delay(0.4).parallel
    let e = pure("e").delay(0.5).parallel

    XCTAssert(
      "a" .*. "b" .*. "c" .*. "d" .*. "e" .*. 1 .*. 2
        ==
        zip5(a, b, c, d, e).map { $0 .*. $1 .*. $2 .*. $3 .*. $4 .*. 1 .*. 2 }.sequential.perform()
    )

    XCTAssertEqual(1, 2)
  }
}
