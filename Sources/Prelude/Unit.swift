public struct Unit {}

public let unit = Unit()

extension Unit: Monoid {
  public static var empty: Prelude.Unit = unit
  
  public static func <> (lhs: Prelude.Unit, rhs: Prelude.Unit) -> Prelude.Unit {
    return unit
  }
}
