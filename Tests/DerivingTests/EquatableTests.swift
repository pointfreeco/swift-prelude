import XCTest
import Deriving

struct Project: DerivingEquatable {
  let id: Int
  let creator: User
}

struct User: DerivingEquatable {
  let id: Int
}

struct Container: DerivingEquatable {
  let xs: [Int?]
  let pairs: [String: Int]
}

final class EquatableTests: XCTestCase {
  func testEquatable() {
    XCTAssertEqual(User(id: 1), User(id: 1))
    XCTAssertNotEqual(User(id: 1), User(id: 2))

    XCTAssertEqual(Project(id: 1, creator: User(id: 1)), Project(id: 1, creator: User(id: 1)))
    XCTAssertNotEqual(Project(id: 1, creator: User(id: 1)), Project(id: 1, creator: User(id: 2)))

    XCTAssertEqual(Container(xs: [1, nil, 2], pairs: [:]), Container(xs: [1, nil, 2], pairs: [:]))
    XCTAssertNotEqual(Container(xs: [1, 2], pairs: [:]), Container(xs: [1, 2, 3], pairs: [:]))

    XCTAssertEqual(Container(xs: [], pairs: ["a": 1]), Container(xs: [], pairs: ["a": 1]))
    XCTAssertNotEqual(Container(xs: [], pairs: ["a": 1]), Container(xs: [], pairs: ["b": 1]))
}

  func testPerformance() {
    let x = Project(id: 1, creator: User(id: 1))
    let y = Project(id: 1, creator: User(id: 2))
    self.measure {
      _ = x == y
    }
  }
}
