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

  func testMerge() {
    let (xs, pushx) = Event<Int>.create()
    let (ys, pushy) = Event<Int>.create()
    let (zs, pushz) = Event<Int>.create()

    let merged = subscribe(to: xs <|> ys <|> zs)

    pushx(6)
    merged.assertSnapshot(identifier: "6")

    pushy(28)
    merged.assertSnapshot(identifier: "28")

    pushz(496)
    merged.assertSnapshot(identifier: "496")
  }

  func testFilter() {
    let (xs, push) = Event<Int>.create()

    let evens = subscribe(to: xs.filter { $0 % 2 == 0 })

    push(1)
    evens.assertSnapshot(identifier: "empty")

    push(2)
    evens.assertSnapshot(identifier: "2")

    push(3)
    evens.assertSnapshot(identifier: "2")
  }

  func testReduce() {
    let (xs, multiplyBy) = Event<Int>.create()

    let values = subscribe(to: xs.reduce(1) { $0 * $1 })

    multiplyBy(2)
    values.assertSnapshot(identifier: "2")

    multiplyBy(2)
    values.assertSnapshot(identifier: "4")

    multiplyBy(2)
    values.assertSnapshot(identifier: "8")
  }

  func testCount() {
    let (xs, push) = Event<()>.create()

    let count = subscribe(to: xs.count)

    push(())
    count.assertSnapshot(identifier: "1")

    push(())
    count.assertSnapshot(identifier: "2")

    push(())
    count.assertSnapshot(identifier: "3")
  }

  func testSampleOn() {
    let (xs, pushx) = Event<()>.create()
    let (ys, pushy) = Event<Int>.create()

    let samples = subscribe(to: ys.sample(on: xs))

    pushx(())
    samples.assertSnapshot(identifier: "empty")

    pushy(1)
    samples.assertSnapshot(identifier: "empty")

    pushx(())
    samples.assertSnapshot(identifier: "1")

    pushy(2)
    samples.assertSnapshot(identifier: "1")

    pushx(())
    samples.assertSnapshot(identifier: "2")
  }

  func testMapOptional() {
    let (xs, push) = Event<Int>.create()

    let mapped = subscribe(to: xs.mapOptional { $0 % 2 == 0 ? String($0) : nil })

    push(1)
    mapped.assertSnapshot(identifier: "empty")

    push(2)
    mapped.assertSnapshot(identifier: "2")

    push(3)
    mapped.assertSnapshot(identifier: "2")
  }

  func testCatOptionals() {
    let (xs, push) = Event<Int?>.create()

    let catted = subscribe(to: catOptionals(xs))

    push(nil)
    catted.assertSnapshot(identifier: "empty")

    push(1)
    catted.assertSnapshot(identifier: "1")

    push(nil)
    catted.assertSnapshot(identifier: "1")
  }

  func testMap() {
    let (strings, push) = Event<String>.create()

    let uppercased = subscribe(to: strings.map { $0.uppercased() })

    push("blob")
    uppercased.assertSnapshot()
  }

  func testApply() {
    let (xs, push) = Event<Int>.create()

    let incrs = subscribe(to: pure { $0 + 1 } <*> xs)

    push(0)
    incrs.assertSnapshot(identifier: "1")

    push(99)
    incrs.assertSnapshot(identifier: "100")
  }

  func testAppend() {
    let (greeting, pushGreeting) = Event<String>.create()
    let (name, pushName) = Event<String>.create()

    let appends = subscribe(to: greeting <> pure(", ") <> name <> pure("!"))

    pushGreeting("Hello")
    appends.assertSnapshot(identifier: "empty")

    pushName("Blob")
    appends.assertSnapshot(identifier: "hello")

    pushGreeting("Goodbye")
    appends.assertSnapshot(identifier: "goodbye")
  }

  func testConcat() {
    let (lines, push) = Event<[String]>.create()

    let concatted = subscribe(to: lines.concat())

    push(["hello"])
    concatted.assertSnapshot(identifier: "hello")

    push(["and", "goodbye"])
    concatted.assertSnapshot(identifier: "goodbye")
  }
}
