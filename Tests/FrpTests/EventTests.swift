import Frp
import Prelude
import SnapshotTesting
import ValidationSemigroup
import XCTest

public final class TestSubscription<A> {
  fileprivate var history: [A] = []

  public func assertSnapshot(
    identifier: String? = nil,
    file: StaticString = #file,
    function: String = #function,
    line: UInt = #line)
  {
    SnapshotTesting.assertSnapshot(
      matching: self.history, identifier: identifier, file: file, function: function, line: line
    )
  }
}

public func subscribe<A>(to event: Event<A>) -> TestSubscription<A> {
  let sub = TestSubscription<A>()
  event.subscribe { a in sub.history.append(a) }
  return sub
}

final class EventTests: XCTestCase {
  func testCombine() {
    let (xs, pushx) = Event<Int>.create()
    let (ys, pushy) = Event<Character>.create()

    let combined = subscribe(to: Event.combine(xs, ys))

    pushx(1)
    combined.assertSnapshot(identifier: "empty")

    pushy("a")
    combined.assertSnapshot(identifier: "1,a")

    pushx(2)
    combined.assertSnapshot(identifier: "2,a")
  }
}
