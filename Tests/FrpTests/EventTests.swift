import Frp
import Prelude
import SnapshotTesting
import ValidationSemigroup
import XCTest

public final class TestSubscription<A> {
  fileprivate var history: [A] = []
}

public func subscribe<A>(to event: Event<A>) -> TestSubscription<A> {
  let sub = TestSubscription<A>()
  event.subscribe { a in sub.history.append(a) }
  return sub
}

public func assertSnapshot<A>(
  matching sub: TestSubscription<A>,
  identifier: String? = nil,
  file: StaticString = #file,
  function: String = #function,
  line: UInt = #line)
{
  SnapshotTesting.assertSnapshot(
    matching: sub.history, identifier: identifier, file: file, function: function, line: line
  )
}

final class EventTests: XCTestCase {
  func testCombine() {
    let (xs, pushx) = Event<Int>.create()
    let (ys, pushy) = Event<Character>.create()

    let combined = subscribe(to: Event.combine(xs, ys))

    pushx(1)
    assertSnapshot(matching: combined, identifier: "empty")

    pushy("a")
    assertSnapshot(matching: combined, identifier: "1,a")

    pushx(2)
    assertSnapshot(matching: combined, identifier: "2,a")
  }

  func testMerge() {
    let (xs, pushx) = Event<Int>.create()
    let (ys, pushy) = Event<Int>.create()
    let (zs, pushz) = Event<Int>.create()

    let merged = subscribe(to: xs <|> ys <|> zs)

    pushx(6)
    assertSnapshot(matching: merged, identifier: "6")

    pushy(28)
    assertSnapshot(matching: merged, identifier: "28")

    pushz(496)
    assertSnapshot(matching: merged, identifier: "496")
  }

  func testFilter() {
    let (xs, push) = Event<Int>.create()

    let evens = subscribe(to: xs.filter { $0 % 2 == 0 })

    push(1)
    assertSnapshot(matching: evens, identifier: "empty")

    push(2)
    assertSnapshot(matching: evens, identifier: "2")

    push(3)
    assertSnapshot(matching: evens, identifier: "2")
  }

  func testReduce() {
    let (xs, multiplyBy) = Event<Int>.create()

    let values = subscribe(to: xs.reduce(1) { $0 * $1 })

    multiplyBy(2)
    assertSnapshot(matching: values, identifier: "2")

    multiplyBy(2)
    assertSnapshot(matching: values, identifier: "4")

    multiplyBy(2)
    assertSnapshot(matching: values, identifier: "8")
  }

  func testCount() {
    let (xs, push) = Event<()>.create()

    let count = subscribe(to: xs.count)

    push(())
    assertSnapshot(matching: count, identifier: "1")

    push(())
    assertSnapshot(matching: count, identifier: "2")

    push(())
    assertSnapshot(matching: count, identifier: "3")
  }

  func testWithLast() {
    let (xs, push) = Event<Int>.create()

    let count = subscribe(to: xs.withLast)

    push(1)
    assertSnapshot(matching: count, identifier: "1")

    push(2)
    assertSnapshot(matching: count, identifier: "2")

    push(3)
    assertSnapshot(matching: count, identifier: "3")
  }

  func testSampleOn() {
    let (xs, pushx) = Event<()>.create()
    let (ys, pushy) = Event<Int>.create()

    let samples = subscribe(to: ys.sample(on: xs))

    pushx(())
    assertSnapshot(matching: samples, identifier: "empty")

    pushy(1)
    assertSnapshot(matching: samples, identifier: "empty")

    pushx(())
    assertSnapshot(matching: samples, identifier: "1")

    pushy(2)
    assertSnapshot(matching: samples, identifier: "1")

    pushx(())
    assertSnapshot(matching: samples, identifier: "2")
  }

  func testMapOptional() {
    let (xs, push) = Event<Int>.create()

    let mapped = subscribe(to: xs.mapOptional { $0 % 2 == 0 ? String($0) : nil })

    push(1)
    assertSnapshot(matching: mapped, identifier: "empty")

    push(2)
    assertSnapshot(matching: mapped, identifier: "2")

    push(3)
    assertSnapshot(matching: mapped, identifier: "2")
  }

  func testCatOptionals() {
    let (xs, push) = Event<Int?>.create()

    let catted = subscribe(to: catOptionals(xs))

    push(nil)
    assertSnapshot(matching: catted, identifier: "empty")

    push(1)
    assertSnapshot(matching: catted, identifier: "1")

    push(nil)
    assertSnapshot(matching: catted, identifier: "1")
  }

  func testMap() {
    let (strings, push) = Event<String>.create()

    let uppercased = subscribe(to: strings.map { $0.uppercased() })

    push("blob")
    assertSnapshot(matching: uppercased)
  }

  func testApply() {
    let (xs, push) = Event<Int>.create()

    let incrs = subscribe(to: pure { $0 + 1 } <*> xs)

    push(0)
    assertSnapshot(matching: incrs, identifier: "1")

    push(99)
    assertSnapshot(matching: incrs, identifier: "100")
  }

  func testAppend() {
    let (greeting, pushGreeting) = Event<String>.create()
    let (name, pushName) = Event<String>.create()

    let appends = subscribe(to: greeting <> pure(", ") <> name <> pure("!"))

    pushGreeting("Hello")
    assertSnapshot(matching: appends, identifier: "empty")

    pushName("Blob")
    assertSnapshot(matching: appends, identifier: "hello")

    pushGreeting("Goodbye")
    assertSnapshot(matching: appends, identifier: "goodbye")
  }

  func testConcat() {
    let (lines, push) = Event<[String]>.create()

    let concatted = subscribe(to: lines.concat())

    push(["hello"])
    assertSnapshot(matching: concatted, identifier: "hello")

    push(["and", "goodbye"])
    assertSnapshot(matching: concatted, identifier: "goodbye")
  }
}
