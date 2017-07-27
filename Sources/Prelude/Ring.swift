import CoreGraphics

public protocol Ring: Semiring {
  static func -(lhs: Self, rhs: Self) -> Self
}

extension CGFloat: Ring {}
extension Double: Ring {}
extension Float: Ring {}
extension Int: Ring {}
extension Int8: Ring {}
extension Int16: Ring {}
extension Int32: Ring {}
extension Int64: Ring {}
extension UInt: Ring {}
extension UInt8: Ring {}
extension UInt16: Ring {}
extension UInt32: Ring {}
extension UInt64: Ring {}

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
