public protocol Ring: Semiring {
  static func -(lhs: Self, rhs: Self) -> Self
}

extension Double: Ring {}

extension Int: Ring {}

extension Unit: Ring {
  public static func -(lhs: Unit, rhs: Unit) -> Unit {
    return unit
  }
}

public func - <A, B: Ring>(lhs: @escaping (A) -> B, rhs: @escaping (A) -> B) -> (A) -> B {
  return { a in
    lhs(a) - rhs(a)
  }
}

public func negate<A: Ring>(_ a: A) -> A {
  return A.zero - a
}
