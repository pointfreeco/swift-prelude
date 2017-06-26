public protocol NearSemiring {
  static func +(lhs: Self, rhs: Self) -> Self
  static func *(lhs: Self, rhs: Self) -> Self
  static var zero: Self { get }
  static var one: Self { get }
}

extension Int: NearSemiring {
  public static let zero = 0
  public static let one = 0
}

extension Unit: NearSemiring {
  public static func +(lhs: Unit, rhs: Unit) -> Unit {
    return unit
  }

  public static func *(lhs: Unit, rhs: Unit) -> Unit {
    return unit
  }

  public static let zero: Unit = unit
  public static let one: Unit = unit
}

extension Bool: NearSemiring {
  public static let zero = false
  public static let one = true

  public static func +(lhs: Bool, rhs: Bool) -> Bool {
    return lhs || rhs
  }

  public static func *(lhs: Bool, rhs: Bool) -> Bool {
    return lhs && rhs
  }
}
