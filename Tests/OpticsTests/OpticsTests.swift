import XCTest
import Prelude
import Optics

struct User {
  private(set) var id: Int
  private(set) var name: String

  public init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}

let incr: (Int) -> Int = { $0 + 1 }
let uppercased: (String) -> String = { $0.uppercased() }

let user = User(id: 1, name: "Stephen")

class PreludeTests: XCTestCase {
  func testLens() {
    let user = User(id: 1, name: "Stephen")
    let overUser = user
      |> (\.id) .~ 2
      |> \.name %~ uppercased

    XCTAssertEqual(2, overUser.id)
    XCTAssertEqual("STEPHEN", overUser.name)

    XCTAssertEqual(1, user .^ (\User.id))
  }

  static var allTests = [
    ("testLens", testLens),
  ]
}
