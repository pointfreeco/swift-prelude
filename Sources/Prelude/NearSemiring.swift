public protocol NearSemiring {
  static func +(lhs: Self, rhs: Self) -> Self
  static func *(lhs: Self, rhs: Self) -> Self
  static var zero: Self { get }
}

extension Bool: NearSemiring {
  public static let zero = false

  public static func +(lhs: Bool, rhs: Bool) -> Bool {
    return lhs || rhs
  }

  public static func *(lhs: Bool, rhs: Bool) -> Bool {
    return lhs && rhs
  }
}

extension Double: NearSemiring {
  public static let zero = 0.0
}

extension Float: NearSemiring {
  public static let zero: Float = 0.0
}

extension Int: NearSemiring {
  public static let zero = 0
}

extension Int8: NearSemiring {
  public static let zero: Int8 = 0
}

extension Int16: NearSemiring {
  public static let zero: Int16 = 0
}

extension Int32: NearSemiring {
  public static let zero: Int32 = 0
}

extension Int64: NearSemiring {
  public static let zero: Int64 = 0
}

extension UInt: NearSemiring {
  public static let zero: UInt = 0
}

extension UInt8: NearSemiring {
  public static let zero: UInt8 = 0
}

extension UInt16: NearSemiring {
  public static let zero: UInt16 = 0
}

extension UInt32: NearSemiring {
  public static let zero: UInt32 = 0
}

extension UInt64: NearSemiring {
  public static let zero: UInt64 = 0
}

extension Unit: NearSemiring {
  public static func +(lhs: Unit, rhs: Unit) -> Unit {
    return unit
  }

  public static func *(lhs: Unit, rhs: Unit) -> Unit {
    return unit
  }

  public static let zero: Unit = unit
}

public func + <A, B: NearSemiring>(lhs: @escaping (A) -> B, rhs: @escaping (A) -> B) -> (A) -> B {
  return { a in
    lhs(a) + rhs(a)
  }
}

public func * <A, B: NearSemiring>(lhs: @escaping (A) -> B, rhs: @escaping (A) -> B) -> (A) -> B {
  return { a in
    lhs(a) * rhs(a)
  }
}

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
  import CoreGraphics

  extension CGFloat: NearSemiring {
    public static var zero: CGFloat = 0.0
  }
#endif
