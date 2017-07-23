public protocol EuclideanRing: CommutativeRing {
  static func /(lhs: Self, rhs: Self) -> Self
  func mod(_ other: Self) -> Self
}

extension Double: EuclideanRing {
  public func mod(_ other: Double) -> Double {
    return self.truncatingRemainder(dividingBy: other)
  }
}

extension Int: EuclideanRing {
  public func mod(_ other: Int) -> Int {
    return self % other
  }
}

public func greatestCommonDivisor<A: Equatable & EuclideanRing>(_ x: A, _ y: A) -> A {
  return y == A.zero
    ? x
    : greatestCommonDivisor(y, x.mod(y))
}

public func leastCommonMultiple<A: Equatable & EuclideanRing>(_ x: A, _ y: A) -> A {
  return x == A.zero || y == A.zero
    ? A.zero
    : x * y / greatestCommonDivisor(x, y)
}
