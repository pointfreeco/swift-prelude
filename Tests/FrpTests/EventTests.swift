import Frp
import Prelude
import SnapshotTesting
import ValidationSemigroup
import XCTest

#if !os(Linux)
typealias SnapshotTestCase = XCTestCase
#endif

public final class TestSubscription<A> {
  fileprivate var history: [A] = []
}

public func subscribe<A>(to event: Event<A>) -> TestSubscription<A> {
  let sub = TestSubscription<A>()
  event.subscribe { sub.history.append($0) }
  return sub
}

final class EventTests: SnapshotTestCase {
  func testCombine() {
    let (xs, pushx) = Event<Int>.create()
    let (ys, pushy) = Event<String>.create()

    let combined = subscribe(to: Event.combine(xs, ys))

    pushx(1)
    assertSnapshot(matching: combined.history, as: .dump)

    pushy("a")
    assertSnapshot(matching: combined.history, as: .dump)

    pushx(2)
    assertSnapshot(matching: combined.history, as: .dump)
  }

  func testMerge() {
    let (xs, pushx) = Event<Int>.create()
    let (ys, pushy) = Event<Int>.create()
    let (zs, pushz) = Event<Int>.create()

    let merged = subscribe(to: xs <|> ys <|> zs)

    pushx(6)
    assertSnapshot(matching: merged.history, as: .dump)

    pushy(28)
    assertSnapshot(matching: merged.history, as: .dump)

    pushz(496)
    assertSnapshot(matching: merged.history, as: .dump)
  }

  func testFilter() {
    let (xs, push) = Event<Int>.create()

    let evens = subscribe(to: xs.filter { $0 % 2 == 0 })

    push(1)
    assertSnapshot(matching: evens.history, as: .dump)

    push(2)
    assertSnapshot(matching: evens.history, as: .dump)

    push(3)
    assertSnapshot(matching: evens.history, as: .dump)
  }

  func testReduce() {
    let (xs, multiplyBy) = Event<Int>.create()

    let values = subscribe(to: xs.reduce(1) { $0 * $1 })

    multiplyBy(2)
    assertSnapshot(matching: values.history, as: .dump)

    multiplyBy(2)
    assertSnapshot(matching: values.history, as: .dump)

    multiplyBy(2)
    assertSnapshot(matching: values.history, as: .dump)
  }

  func testCount() {
    let (xs, push) = Event<()>.create()

    let count = subscribe(to: xs.count)

    push(())
    assertSnapshot(matching: count.history, as: .dump)

    push(())
    assertSnapshot(matching: count.history, as: .dump)

    push(())
    assertSnapshot(matching: count.history, as: .dump)
  }

  func testWithLast() {
    let (xs, push) = Event<Int>.create()

    let count = subscribe(to: xs.withLast)

    push(1)
    assertSnapshot(matching: count.history, as: .dump)

    push(2)
    assertSnapshot(matching: count.history, as: .dump)

    push(3)
    assertSnapshot(matching: count.history, as: .dump)
  }

  func testSampleOn() {
    let (xs, pushx) = Event<()>.create()
    let (ys, pushy) = Event<Int>.create()

    let samples = subscribe(to: ys.sample(on: xs))

    pushx(())
    assertSnapshot(matching: samples.history, as: .dump)

    pushy(1)
    assertSnapshot(matching: samples.history, as: .dump)

    pushx(())
    assertSnapshot(matching: samples.history, as: .dump)

    pushy(2)
    assertSnapshot(matching: samples.history, as: .dump)

    pushx(())
    assertSnapshot(matching: samples.history, as: .dump)
  }

  func testMapOptional() {
    let (xs, push) = Event<Int>.create()

    let mapped = subscribe(to: xs.mapOptional { $0 % 2 == 0 ? String($0) : nil })

    push(1)
    assertSnapshot(matching: mapped.history, as: .dump)

    push(2)
    assertSnapshot(matching: mapped.history, as: .dump)

    push(3)
    assertSnapshot(matching: mapped.history, as: .dump)
  }

  func testCatOptionals() {
    let (xs, push) = Event<Int?>.create()

    let catted = subscribe(to: catOptionals(xs))

    push(nil)
    assertSnapshot(matching: catted.history, as: .dump)

    push(1)
    assertSnapshot(matching: catted.history, as: .dump)

    push(nil)
    assertSnapshot(matching: catted.history, as: .dump)
  }

  func testMap() {
    let (strings, push) = Event<String>.create()

    let uppercased = subscribe(to: strings.map { $0.uppercased() })

    push("blob")
    assertSnapshot(matching: uppercased.history, as: .dump)
  }

  func testApply() {
    let (xs, push) = Event<Int>.create()

    let incrs = subscribe(to: pure { $0 + 1 } <*> xs)

    push(0)
    assertSnapshot(matching: incrs.history, as: .dump)

    push(99)
    assertSnapshot(matching: incrs.history, as: .dump)
  }

  func testAppend() {
    let (greeting, pushGreeting) = Event<String>.create()
    let (name, pushName) = Event<String>.create()

    let appends = subscribe(to: greeting <> pure(", ") <> name <> pure("!"))

    pushGreeting("Hello")
    assertSnapshot(matching: appends.history, as: .dump)

    pushName("Blob")
    assertSnapshot(matching: appends.history, as: .dump)

    pushGreeting("Goodbye")
    assertSnapshot(matching: appends.history, as: .dump)
  }

  func testConcat() {
    let (lines, push) = Event<[String]>.create()

    let concatted = subscribe(to: lines.concat())

    push(["hello"])
    assertSnapshot(matching: concatted.history, as: .dump)

    push(["and", "goodbye"])
    assertSnapshot(matching: concatted.history, as: .dump)
  }
}
