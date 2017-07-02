public protocol Semiring: NearSemiring {
  static var one: Self { get }
}

extension Bool: Semiring {
  public static let one = true
}

extension Double: Semiring {
  public static let one = 1.0
}

extension Int: Semiring {
  public static let one = 1
}

extension Unit: Semiring {
  public static let one = unit
}

// MARK: - Sum & Product

public func sum<S: Semiring>(_ xs: [S]) -> S {
  return xs.reduce(.zero, +)
}

public func product<S: Semiring>(_ xs: [S]) -> S {
  return xs.reduce(.one, *)
}
