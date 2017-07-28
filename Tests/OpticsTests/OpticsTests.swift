import Optics
import Prelude
import XCTest

struct User {
  private(set) var id: Int
  private(set) var name: String

  public init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}

class PreludeTests: XCTestCase {
  func testLens() {
    let user = User(id: 1, name: "Stephen")

    let overUser = user
      |> \.id .~ 2
      |> \.name <>~ " Celis"
      |> \.name %~ uppercased

    XCTAssertEqual(2, overUser.id)
    XCTAssertEqual("STEPHEN CELIS", overUser.name)

    XCTAssertEqual(1, user .^ \.id)
  }

  static var allTests = [
    ("testLens", testLens),
  ]
}
