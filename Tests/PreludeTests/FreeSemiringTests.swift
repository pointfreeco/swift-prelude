import XCTest
import Prelude

class FreeSemiringTests: XCTestCase {
  func testOp() {
    let xss = FreeSemiring([[1, 2], [3]])
    let yss = FreeSemiring([[1], [2]])
    let zss = FreeSemiring([[1, 2, 3]])

    // Basic operators
    XCTAssert(FreeSemiring([[1, 2], [3], [1], [2]]) == xss + yss)
    XCTAssert(FreeSemiring([[1, 2, 1], [1, 2, 2], [3, 1], [3, 2]]) == xss * yss)

    // Associativity
    var lhs: FreeSemiring<Int>
    var rhs: FreeSemiring<Int>

    lhs = xss + (yss + zss)
    rhs = (xss + yss) + zss
    XCTAssert(lhs == rhs)

    lhs = xss * (yss * zss)
    rhs = (xss * yss) * zss
    XCTAssert(lhs == rhs)

    // Distributivity
    lhs = xss * (yss + zss)
    rhs = (xss * yss) + (xss * zss)
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


