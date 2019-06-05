import Either
import Optics
import Prelude
import XCTest

#if !os(Linux)
typealias SnapshotTestCase = XCTestCase
#endif

struct User {
  var id: Int
  var name: String

  public init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}

struct Episode {
  var id: Int
  var host: User
  var cohost: User?
  var guests: [User]
  var isSubscriberOnly: Bool
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
//  func testViewOn() {
//    XCTAssertEqual("Blob", user .^ \.name)
//    XCTAssertEqual("Blob", episode .^ \.host.name)
//    XCTAssertEqual(5, episode .^ \.id)
//  }

  func testIx() {
//    XCTAssertEqual(999, [1, 999, 2] .^ ix(1))

//    assertSnapshot(
//      matching: episode |> \.guests <<< ix(1) <<< \.name .~ "Pleb",
//      as: .dump
//    )
  }

  func testKey() {
//    XCTAssertEqual(.some(999), ["a": 999] .^ key("a"))
//    XCTAssertNil(["a": 999] .^ key("b"))

    XCTAssertEqual(["a": 1000], ["a": 999] |> key("a") <<< traversed +~ 1)
    XCTAssertEqual(["a": 999, "b": 1], ["a": 999] |> key("b") %~ { ($0 ?? 0) + 1 })
  }

  func testElem() {
    let set: Set<Int> = [1, 2, 3]

//    XCTAssertEqual(true, set .^ elem(3))
//    XCTAssertEqual(false, set .^ elem(4))

    XCTAssertEqual([1, 2], set |> elem(3) .~ false)
    XCTAssertEqual([1, 2, 3, 4], set |> elem(4) .~ true)
    XCTAssertEqual([1, 2, 3, 5], set |> elem(5) %~ { !$0 })
  }

  func testOver() {
//    assertSnapshot(matching: episode |> \.host.name %~ uppercased, as: .dump)
  }

  func testSet() {
//    assertSnapshot(matching: episode |> \.host.name .~ "Reblob", as: .dump)
  }

  func testAddOver() {
//    assertSnapshot(matching: episode |> \.id +~ 1, as: .dump)
  }

  func testSubOver() {
//    assertSnapshot(matching: episode |> \.id -~ 1, as: .dump)
  }

  func testMulOver() {
//    assertSnapshot(matching: episode |> \.id *~ 2, as: .dump)
  }

  func testDivOver() {
//    assertSnapshot(matching: episode |> \.id /~ 2, as: .dump)
  }

  func testDisjOver() {
//    assertSnapshot(
//      matching: episode
//        |> \.isSubscriberOnly .~ true
//        |> \.isSubscriberOnly &&~ false,
//      as: .dump
//    )
  }

  func testConjOver() {
//    assertSnapshot(
//      matching: episode
//        |> \.isSubscriberOnly .~ false
//        |> \.isSubscriberOnly ||~ true,
//      as: .dump
//    )
  }

  func testAppendOver() {
//    assertSnapshot(matching: episode |> \.host.name <>~ " Blobby", as: .dump)
  }

  func testTraversed() {
//    XCTAssertEqual("hello", ["hell", "o"] .^ traversed)
//
//    XCTAssertEqual([2, 3, 4], [1, 2, 3] |> traversed +~ 1)
//
//    assertSnapshot(
//      matching: episode |> \.guests <<< traversed <<< \.name %~ uppercased,
//      as: .dump,
//      named: "Array traversal"
//    )
//
//    assertSnapshot(
//      matching: episode |> \.cohost <<< traversed <<< \.name %~ uppercased,
//      as: .dump,
//      named: "None traversal"
//    )
//
//    assertSnapshot(
//      matching: episode
//        |> \.cohost .~ user
//        |> \.cohost <<< traversed <<< \.name %~ uppercased,
//      as: .dump,
//      named: "Some traversal"
//    )
  }

  func testStrongPrisms() {
//    assertSnapshot(matching: ((1, 2), 3) |> first <<< second .~ "Haha!", as: .dump)
  }

  func testChoicePrisms() {
//    assertSnapshot(
//      matching: Either<String, Either<String, Int>>.right(.right(1)) |> right <<< right .~ 999,
//      as: .dump,
//      named: "Successful nested right-hand traversal"
//    )
//
//    assertSnapshot(
//      matching: Either<String, Either<String, Int>>.right(.left("Oops")) |> right <<< left %~ uppercased,
//      as: .dump,
//      named: "Successful nested left-hand traversal"
//    )
//
//    assertSnapshot(
//      matching: Either<String, Either<String, Int>>.left("Oops") |> left %~ uppercased,
//      as: .dump,
//      named: "Successful left-hand traversal"
//    )
//
//    assertSnapshot(
//      matching: Either<String, Either<String, Int>>.left("Oops") |> right <<< right +~ 1,
//      as: .dump,
//      named: "Unsuccessful right-hand traversal"
//    )
//
//    assertSnapshot(
//      matching: .some(1) |> some .~ "Hehe.",
//      as: .dump,
//      named: "Successful some traversal"
//    )
//
//    assertSnapshot(
//      matching: Int?.none |> some .~ "Hehe.",
//      as: .dump,
//      named: "Unsuccessful some traversal"
//    )
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
//      matching: data |> first <<< traversed <<< left <<< traversed <<< some +~ 1,
//      as: .dump,
//      named: "Nested choice prismatic traversals"
//    )
//
//    assertSnapshot(
//      matching: data |> first <<< ix(0) <<< left <<< ix(0) .~ 99,
//      as: .dump,
//      named: "Nested indexed choice"
//    )
  }

  func testGetters() {
//    XCTAssertEqual("Blob", episode .^ \.host <<< \.name)
//    XCTAssertEqual("Blob", episode .^ \.host .^ \.name)
//    XCTAssertEqual("Blob", episode .^ getting(\Episode.host) .^ getting(\User.name))
//    XCTAssertEqual("Blob", episode .^ getting(\Episode.host) <<< getting(\User.name))
  }
}
