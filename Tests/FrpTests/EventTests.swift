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
  named name: String? = nil,
  file: StaticString = #file,
  function: String = #function,
  line: UInt = #line)
{
  SnapshotTesting.assertSnapshot(
    matching: sub.history, named: name, file: file, function: function, line: line
  )
}

final class EventTests: XCTestCase {
  func testCombine() {
    let (xs, pushx) = Event<Int>.create()
    let (ys, pushy) = Event<Character>.create()

    let combined = subscribe(to: Event.combine(xs, ys))

    pushx(1)
    assertSnapshot(matching: combined)

    pushy("a")
    assertSnapshot(matching: combined)

    pushx(2)
    assertSnapshot(matching: combined)
  }

  func testMerge() {
    let (xs, pushx) = Event<Int>.create()
    let (ys, pushy) = Event<Int>.create()
    let (zs, pushz) = Event<Int>.create()

    let merged = subscribe(to: xs <|> ys <|> zs)

    pushx(6)
    assertSnapshot(matching: merged)

    pushy(28)
    assertSnapshot(matching: merged)

    pushz(496)
    assertSnapshot(matching: merged)
  }

  func testFilter() {
    let (xs, push) = Event<Int>.create()

    let evens = subscribe(to: xs.filter { $0 % 2 == 0 })

    push(1)
    assertSnapshot(matching: evens)

    push(2)
    assertSnapshot(matching: evens)

    push(3)
    assertSnapshot(matching: evens)
  }

  func testReduce() {
    let (xs, multiplyBy) = Event<Int>.create()

    let values = subscribe(to: xs.reduce(1) { $0 * $1 })

    multiplyBy(2)
    assertSnapshot(matching: values)

    multiplyBy(2)
    assertSnapshot(matching: values)

    multiplyBy(2)
    assertSnapshot(matching: values)
  }

  func testCount() {
    let (xs, push) = Event<()>.create()

    let count = subscribe(to: xs.count)

    push(())
    assertSnapshot(matching: count)

    push(())
    assertSnapshot(matching: count)

    push(())
    assertSnapshot(matching: count)
  }

  func testWithLast() {
    let (xs, push) = Event<Int>.create()

    let count = subscribe(to: xs.withLast)

    push(1)
    assertSnapshot(matching: count)

    push(2)
    assertSnapshot(matching: count)

    push(3)
    assertSnapshot(matching: count)
  }

  func testSampleOn() {
    let (xs, pushx) = Event<()>.create()
    let (ys, pushy) = Event<Int>.create()

    let samples = subscribe(to: ys.sample(on: xs))

    pushx(())
    assertSnapshot(matching: samples)

    pushy(1)
    assertSnapshot(matching: samples)

    pushx(())
    assertSnapshot(matching: samples)

    pushy(2)
    assertSnapshot(matching: samples)

    pushx(())
    assertSnapshot(matching: samples)
  }

  func testMapOptional() {
    let (xs, push) = Event<Int>.create()

    let mapped = subscribe(to: xs.mapOptional { $0 % 2 == 0 ? String($0) : nil })

    push(1)
    assertSnapshot(matching: mapped)

    push(2)
    assertSnapshot(matching: mapped)

    push(3)
    assertSnapshot(matching: mapped)
  }

  func testCatOptionals() {
    let (xs, push) = Event<Int?>.create()

    let catted = subscribe(to: catOptionals(xs))

    push(nil)
    assertSnapshot(matching: catted)

    push(1)
    assertSnapshot(matching: catted)

    push(nil)
    assertSnapshot(matching: catted)
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
    assertSnapshot(matching: incrs)

    push(99)
    assertSnapshot(matching: incrs)
  }

  func testAppend() {
    let (greeting, pushGreeting) = Event<String>.create()
    let (name, pushName) = Event<String>.create()

    let appends = subscribe(to: greeting <> pure(", ") <> name <> pure("!"))

    pushGreeting("Hello")
    assertSnapshot(matching: appends)

    pushName("Blob")
    assertSnapshot(matching: appends)

    pushGreeting("Goodbye")
    assertSnapshot(matching: appends)
  }

  func testConcat() {
    let (lines, push) = Event<[String]>.create()

    let concatted = subscribe(to: lines.concat())

    push(["hello"])
    assertSnapshot(matching: concatted)

    push(["and", "goodbye"])
    assertSnapshot(matching: concatted)
  }
}
