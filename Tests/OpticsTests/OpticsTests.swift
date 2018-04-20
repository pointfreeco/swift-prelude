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

class OpticsTests: XCTestCase {
  func testViewOn() {
    XCTAssertEqual("Blob", user .^ getting(\.name))
    XCTAssertEqual("Blob", episode .^ getting(\.host.name))
    XCTAssertEqual(5, episode .^ getting(\.id))
  }

  func testIx() {
    XCTAssertEqual(999, [1, 999, 2] .^ getting(\.[1]))

    assertSnapshot(matching: episode |> set(^\.guests[1].name, "Pleb"))
  }

  func testKey() {
    XCTAssertEqual(.some(999), ["a": 999] .^ getting(\.["a"]))
    XCTAssertNil(["a": 999] .^ getting(\.["b"]))

    XCTAssertEqual(["a": 1000], ["a": 999] |> over(^\.["a"] <<< map) { $0 + 1 })
    XCTAssertEqual(["a": 999, "b": 1], ["a": 999] |> over(^\.["b"]) { ($0 ?? 0) + 1 })
  }

  func testElem() {
    let mySet: Set<Int> = [1, 2, 3]

    XCTAssertEqual(true, mySet .^ elem(3))
    XCTAssertEqual(false, mySet .^ elem(4))

    XCTAssertEqual([1, 2], mySet |> set(elem(3), false))
    XCTAssertEqual([1, 2, 3, 4], mySet |> set(elem(4), true))
    XCTAssertEqual([1, 2, 3, 5], mySet |> over(elem(5), !))
  }

  func testOver() {
    assertSnapshot(matching: episode |> over(^\.host.name, uppercased))
  }

  func testSet() {
    assertSnapshot(matching: episode |> set(^\.host.name, "Reblob"))
  }

  func testStrongPrisms() {
    assertSnapshot(matching: ((1, 2), 3) |> set(first <<< second,"Haha!"))
  }

  func testChoicePrisms() {
    assertSnapshot(
      matching: Either<String, Either<String, Int>>.right(.right(1)) |> set(right <<< right, 999),
      named: "Successful nested right-hand traversal"
    )

    assertSnapshot(
      matching: Either<String, Either<String, Int>>.right(.left("Oops")) |> over(right <<< left, uppercased),
      named: "Successful nested left-hand traversal"
    )

    assertSnapshot(
      matching: Either<String, Either<String, Int>>.left("Oops") |> over(left, uppercased),
      named: "SUccessful left-hand traversal"
    )

    assertSnapshot(
      matching: .some(1) |> set(some, "Hehe."),
      named: "Successful some traversal"
    )

    assertSnapshot(
      matching: Int?.none |> set(some, "Hehe."),
      named: "Unsuccessful some traversal"
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

//    assertSnapshot(
//      matching: data |> over(first <<< map <<< left <<< map <<< some) { $0 + 1 },
//      named: "Nested choice prismatic traversals"
//    )

    assertSnapshot(
      matching: data |> set(first <<< ^\.[0] <<< left <<< ^\.[0], 99),
      named: "Nested indexed choice"
    )
  }

  func testGetters() {
    XCTAssertEqual("Blob", episode .^ getting(\Episode.host) .^ getting(\User.name))
    XCTAssertEqual("Blob", episode .^ getting(\Episode.host) <<< getting(\User.name))
  }
}
