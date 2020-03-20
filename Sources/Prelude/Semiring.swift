public protocol Semiring: NearSemiring {
  static var one: Self { get }
}

extension Bool: Semiring {
  public static let one = true
}

extension Double: Semiring {
  public static let one = 1.0
}

extension Float: Semiring {
  public static let one: Float = 1.0
}

extension Int: Semiring {
  public static let one = 1
}

extension Int8: Semiring {
  public static let one: Int8 = 1
}

extension Int16: Semiring {
  public static let one: Int16 = 1
}

extension Int32: Semiring {
  public static let one: Int32 = 1
}

extension Int64: Semiring {
  public static let one: Int64 = 1
}

extension UInt: Semiring {
  public static let one: UInt = 1
}

extension UInt8: Semiring {
  public static let one: UInt8 = 1
}

extension UInt16: Semiring {
  public static let one: UInt16 = 1
}

extension UInt32: Semiring {
  public static let one: UInt32 = 1
}

extension UInt64: Semiring {
  public static let one: UInt64 = 1
}

extension Unit: Semiring {
  public static let one = unit
}

// MARK: - Sum & Product

public func sum<S: Semiring>(_ xs: [S]) -> S {
  xs.reduce(.zero, +)
}

public func product<S: Semiring>(_ xs: [S]) -> S {
  xs.reduce(.one, *)
}

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
  import CoreGraphics

  extension CGFloat: Semiring {
    public static let one: CGFloat = 1.0
  }
#endif
