public protocol EuclideanRing: CommutativeRing {
  static func /(lhs: Self, rhs: Self) -> Self
  static func %(lhs: Self, rhs: Self) -> Self
}

extension Double: EuclideanRing {}
extension Int: EuclideanRing {}

public func greatestCommonDivisor<A: Equatable & EuclideanRing>(_ x: A, _ y: A) -> A {
  return y == A.zero
    ? x
    : greatestCommonDivisor(y, x % y)
}

public func leastCommonMultiple<A: Equatable & EuclideanRing>(_ x: A, _ y: A) -> A {
  return x == A.zero || y == A.zero
    ? A.zero
    : x * y / greatestCommonDivisor(x, y)
}
