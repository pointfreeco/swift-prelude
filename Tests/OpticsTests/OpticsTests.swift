import Either
import Optics
import Prelude
import SnapshotTesting
import XCTest

struct User {
  private(set) var id: Int
  private(set) var name: String

  public init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}

struct Episode {
  private(set) var id: Int
  private(set) var host: User
  private(set) var cohost: User?
  private(set) var guests: [User]
  private(set) var isSubscriberOnly: Bool
}

let user = User(id: 1, name: "Blob")

let episode = Episode(
  id: 5,
  host: user,
  cohost: nil,
  guests: [User(id: 2, name: "Glob"), User(id: 3, name: "Prob")],
  isSubscriberOnly: false
)

class PreludeTests: XCTestCase {
  func testViewOn() {
    XCTAssertEqual("Blob", user .^ \.name)
    XCTAssertEqual("Blob", episode .^ \.host.name)
    XCTAssertEqual(5, episode .^ \.id)
  }

  func testIx() {
    XCTAssertEqual(999, [1, 999, 2] .^ ix(1))

    assertSnapshot(matching: episode |> \.guests <<< ix(1) <<< \.name .~ "Pleb")
  }

  func testKey() {
    XCTAssertEqual(.some(999), ["a": 999] .^ key("a"))
    XCTAssertNil(["a": 999] .^ key("b"))

    XCTAssertEqual(["a": 1000], ["a": 999] |> key("a") <<< traversed +~ 1)
    XCTAssertEqual(["a": 999, "b": 1], ["a": 999] |> key("b") %~ { ($0 ?? 0) + 1 })
  }

  func testElem() {
    XCTAssertEqual(true, Set<Int>(arrayLiteral: 1, 2, 3) .^ elem(3))
    XCTAssertEqual(false, Set<Int>(arrayLiteral: 1, 2, 3) .^ elem(4))

    XCTAssertEqual([1, 2], Set<Int>(arrayLiteral: 1, 2, 3) |> elem(3) .~ false)
    XCTAssertEqual([1, 2, 3, 4], Set<Int>(arrayLiteral: 1, 2, 3) |> elem(4) .~ true)
    XCTAssertEqual([1, 2, 3, 5], Set<Int>(arrayLiteral: 1, 2, 3) |> elem(5) %~ { !$0 })
  }

  func testOver() {
    assertSnapshot(matching: episode |> \.host.name %~ uppercased)
  }

  func testSet() {
    assertSnapshot(matching: episode |> \.host.name .~ "Reblob")
  }

  func testAddOver() {
    assertSnapshot(matching: episode |> \.id +~ 1)
  }

  func testSubOver() {
    assertSnapshot(matching: episode |> \.id -~ 1)
  }

  func testMulOver() {
    assertSnapshot(matching: episode |> \.id *~ 2)
  }

  func testDivOver() {
    assertSnapshot(matching: episode |> \.id /~ 2)
  }

  func testDisjOver() {
    assertSnapshot(matching: episode
      |> \.isSubscriberOnly .~ true
      |> \.isSubscriberOnly &&~ false)
  }

  func testConjOver() {
    assertSnapshot(matching: episode
      |> \.isSubscriberOnly .~ false
      |> \.isSubscriberOnly ||~ true)
  }

  func testAppendOver() {
    assertSnapshot(matching: episode |> \.host.name <>~ " Blobby")
  }

  func testTraversed() {
    XCTAssertEqual("hello", ["hell", "o"] .^ traversed)

    XCTAssertEqual([2, 3, 4], [1, 2, 3] |> traversed +~ 1)

    assertSnapshot(matching: episode |> \.guests <<< traversed <<< \.name %~ uppercased,
                   identifier: "Array traversal")

    assertSnapshot(matching: episode |> \.cohost <<< traversed <<< \.name %~ uppercased,
                   identifier: "None traversal")

    assertSnapshot(matching: episode |> \.cohost .~ user |> \.cohost <<< traversed <<< \.name %~ uppercased,
                   identifier: "Some traversal")
  }

  func testStrongPrisms() {
    assertSnapshot(matching: ((1, 2), 3) |> first <<< second .~ "Haha!")
  }

  func testChoicePrisms() {
    assertSnapshot(
      matching: Either<String, Either<String, Int>>.right(.right(1)) |> right <<< right .~ 999,
      identifier: "Successful nested right-hand traversal"
    )

    assertSnapshot(
      matching: Either<String, Either<String, Int>>.right(.left("Oops")) |> right <<< left %~ uppercased,
      identifier: "Successful nested left-hand traversal"
    )

    assertSnapshot(
      matching: Either<String, Either<String, Int>>.left("Oops") |> left %~ uppercased,
      identifier: "SUccessful left-hand traversal"
    )

    assertSnapshot(
      matching: Either<String, Either<String, Int>>.left("Oops") |> right <<< right +~ 1,
      identifier: "Unsuccessful right-hand traversal"
    )

    assertSnapshot(
      matching: .some(1) |> some .~ "Hehe.",
      identifier: "Successful some traversal"
    )

    assertSnapshot(
      matching: Int?.none |> some .~ "Hehe.",
      identifier: "Unsuccessful some traversal"
    )
  }

  func testLots() {
    let data: ([Either<[Int?], String>], Int) = (
      [
        .left([1, 2, nil, 3]),
        .right("hello!")
      ],
      999
    )

    assertSnapshot(
      matching: data |> first <<< traversed <<< left <<< traversed <<< some +~ 1,
      identifier: "Nested choice prismatic traversals"
    )

    assertSnapshot(
      matching: data |> first <<< ix(0) <<< left <<< ix(0) .~ 99,
      identifier: "Nested indexed choice"
    )
  }
}
