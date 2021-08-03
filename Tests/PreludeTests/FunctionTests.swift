import XCTest
import Prelude

class FunctionTests: XCTestCase {
  public func testCallAsFunction() {
    let increment = Func<Int, Int> { $0 + 1 }
    let zero = Func<Void, Int> { 0 }
    
    XCTAssertEqual(increment(0), 1)
    XCTAssertEqual(zero(), 0)
  }
}
