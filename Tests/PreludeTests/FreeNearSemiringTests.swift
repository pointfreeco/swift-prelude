import XCTest
import Prelude

class FreeNearSemiringTests: XCTestCase {
  func testOp() {
    let xss = FreeNearSemiring([[1, 2], [3]])
    let yss = FreeNearSemiring([[1], [2]])
    let zss = FreeNearSemiring([[1, 2, 3]])

    // Basic operators
    XCTAssert(FreeNearSemiring([[1, 2], [3], [1], [2]]) == xss + yss)
    XCTAssert(FreeNearSemiring([[1, 2, 1], [1, 2, 2], [3, 1], [3, 2]]) == xss * yss)

    // Associativity
    var lhs: FreeNearSemiring<Int>
    var rhs: FreeNearSemiring<Int>

    lhs = xss + (yss + zss)
    rhs = (xss + yss) + zss
    XCTAssert(lhs == rhs)

    lhs = xss * (yss * zss)
    rhs = (xss * yss) * zss
    XCTAssert(lhs == rhs)

    // Distributivity
    lhs = (yss + zss) * xss
    rhs = (yss * xss) + (zss * xss)
    XCTAssert(lhs == rhs)

    // Identity
    zip(["xss", "yss", "zss"], [xss, yss, zss]).forEach {
      let (name, s) = $0
      XCTAssert((s * .one) == s, "Right multiplicative identity: \(name)")
      XCTAssert((.one * s) == s, "Left multiplicative identity: \(name)")
      XCTAssert((s + .zero) == s, "Right additive identity: \(name)")
      XCTAssert((.zero + s) == s, "Left additive identity: \(name)")
      XCTAssert((s * .zero) == .zero, "Right annihilation by zero: \(name)")
      XCTAssert((.zero * s) == .zero, "Left annihilation by zero: \(name)")
    }
  }
}


