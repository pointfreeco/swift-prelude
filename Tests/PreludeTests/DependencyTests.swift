import Dependencies
import Prelude
import XCTest

final class DependencyTests: XCTestCase {
  func testIOPropagation() {
    let operation = DependencyValues.withTestValues {
      $0.date.now = Date(timeIntervalSince1970: 1234567890)
    } operation: {
      IO<TimeInterval> { DependencyValues._current.date.now.timeIntervalSince1970 }
    }

    XCTAssertEqual(operation.perform(), 1234567890)
  }

  func testParallelPropagation() {
    let parallel = DependencyValues.withTestValues {
      $0.date.now = Date(timeIntervalSince1970: 1234567890)
    } operation: {
      Parallel<TimeInterval> { $0(DependencyValues._current.date.now.timeIntervalSince1970) }
    }

    let expectation = self.expectation(description: "parallel")
    parallel.run {
      XCTAssertEqual($0, 1234567890)
      expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 1)
  }
}
