public protocol NearSemiring {
  static func +(lhs: Self, rhs: Self) -> Self
  static func *(lhs: Self, rhs: Self) -> Self
  static var zero: Self { get }
}

extension Int: NearSemiring {
  public static let zero = 0
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

extension Bool: NearSemiring {
  public static let zero = false

  public static func +(lhs: Bool, rhs: Bool) -> Bool {
    return lhs || rhs
  }

  public static func *(lhs: Bool, rhs: Bool) -> Bool {
    return lhs && rhs
  }
}
