public struct Unit: Codable {}

public let unit = Unit()

extension Unit: Monoid {
  public static var empty: Unit = unit
  
  public static func <> (lhs: Unit, rhs: Unit) -> Unit {
    return unit
  }
}

extension Unit: Error {}
