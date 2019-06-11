import Frp
import Prelude
import ValidationSemigroup
import XCTest

public final class TestSubscription<A> {
  fileprivate var history: [A] = []
}

public func subscribe<A>(to event: Event<A>) -> TestSubscription<A> {
  let sub = TestSubscription<A>()
  event.subscribe { sub.history.append($0) }
  return sub
}

final class EventTests: XCTestCase {
  func testCombine() {
    let (xs, pushx) = Event<Int>.create()
    let (ys, pushy) = Event<String>.create()

    let combined = subscribe(to: Event.combine(xs, ys))

    pushx(1)
    XCTAssertEqual([], combined.history.map { $0.0 })
    XCTAssertEqual([], combined.history.map { $0.1 })

    pushy("a")
    XCTAssertEqual([1], combined.history.map { $0.0 })
    XCTAssertEqual(["a"], combined.history.map { $0.1 })

    pushx(2)
    XCTAssertEqual([1, 2], combined.history.map { $0.0 })
    XCTAssertEqual(["a", "a"], combined.history.map { $0.1 })
  }

  func testMerge() {
    let (xs, pushx) = Event<Int>.create()
    let (ys, pushy) = Event<Int>.create()
    let (zs, pushz) = Event<Int>.create()

    let merged = subscribe(to: xs <|> ys <|> zs)

    pushx(6)
    XCTAssertEqual([6], merged.history)

    pushy(28)
    XCTAssertEqual([6, 28], merged.history)

    pushz(496)
    XCTAssertEqual([6, 28, 496], merged.history)
  }

  func testFilter() {
    let (xs, push) = Event<Int>.create()

    let evens = subscribe(to: xs.filter { $0 % 2 == 0 })

    push(1)
    XCTAssertEqual([], evens.history)

    push(2)
    XCTAssertEqual([2], evens.history)

    push(3)
    XCTAssertEqual([2], evens.history)
  }

  func testReduce() {
    let (xs, multiplyBy) = Event<Int>.create()

    let values = subscribe(to: xs.reduce(1) { $0 * $1 })

    multiplyBy(2)
    XCTAssertEqual([2], values.history)

    multiplyBy(2)
    XCTAssertEqual([2, 4], values.history)

    multiplyBy(2)
    XCTAssertEqual([2, 4, 8], values.history)
  }

  func testCount() {
    let (xs, push) = Event<()>.create()

    let count = subscribe(to: xs.count)

    push(())
    XCTAssertEqual([1], count.history)

    push(())
    XCTAssertEqual([1, 2], count.history)

    push(())
    XCTAssertEqual([1, 2, 3], count.history)
  }

  func testWithLast() {
    let (xs, push) = Event<Int>.create()

    let count = subscribe(to: xs.withLast)

    push(1)
    XCTAssertEqual([1], count.history.map { $0.0 })
    XCTAssertEqual([nil], count.history.map { $0.1 })

    push(2)
    XCTAssertEqual([1, 2], count.history.map { $0.0 })
    XCTAssertEqual([nil, .some(1)], count.history.map { $0.1 })

    push(3)
    XCTAssertEqual([1, 2, 3], count.history.map { $0.0 })
    XCTAssertEqual([nil, .some(1), .some(2)], count.history.map { $0.1 })
  }

  func testSampleOn() {
    let (xs, pushx) = Event<()>.create()
    let (ys, pushy) = Event<Int>.create()

    let samples = subscribe(to: ys.sample(on: xs))

    pushx(())
    XCTAssertEqual([], samples.history)

    pushy(1)
    XCTAssertEqual([], samples.history)

    pushx(())
    XCTAssertEqual([1], samples.history)

    pushy(2)
    XCTAssertEqual([1], samples.history)

    pushx(())
    XCTAssertEqual([1, 2], samples.history)
  }

  func testMapOptional() {
    let (xs, push) = Event<Int>.create()

    let mapped = subscribe(to: xs.mapOptional { $0 % 2 == 0 ? String($0) : nil })

    push(1)
    XCTAssertEqual([], mapped.history)

    push(2)
    XCTAssertEqual(["2"], mapped.history)

    push(3)
    XCTAssertEqual(["2"], mapped.history)
  }

  func testCatOptionals() {
    let (xs, push) = Event<Int?>.create()

    let catted = subscribe(to: catOptionals(xs))

    push(nil)
    XCTAssertEqual([], catted.history)

    push(1)
    XCTAssertEqual([1], catted.history)

    push(nil)
    XCTAssertEqual([1], catted.history)
  }

  func testMap() {
    let (strings, push) = Event<String>.create()

    let uppercased = subscribe(to: strings.map { $0.uppercased() })

    push("blob")
    XCTAssertEqual(["BLOB"], uppercased.history)
  }

  func testApply() {
    let (xs, push) = Event<Int>.create()

    let incrs = subscribe(to: pure { $0 + 1 } <*> xs)

    push(0)
    XCTAssertEqual([1], incrs.history)

    push(99)
    XCTAssertEqual([1, 100], incrs.history)
  }

  func testAppend() {
    let (greeting, pushGreeting) = Event<String>.create()
    let (name, pushName) = Event<String>.create()

    let appends = subscribe(to: greeting <> pure(", ") <> name <> pure("!"))

    pushGreeting("Hello")
    XCTAssertEqual([], appends.history)

    pushName("Blob")
    XCTAssertEqual(["Hello, Blob!"], appends.history)

    pushGreeting("Goodbye")
    XCTAssertEqual(["Hello, Blob!", "Goodbye, Blob!"], appends.history)
  }

  func testConcat() {
    let (lines, push) = Event<[String]>.create()

    let concatted = subscribe(to: lines.concat())

    push(["hello"])
    XCTAssertEqual([["hello"]], concatted.history)

    push(["and", "goodbye"])
    XCTAssertEqual([["hello"], ["hello", "and", "goodbye"]], concatted.history)
  }
}
