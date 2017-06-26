public protocol Semiring: NearSemiring {
  static var one: Self { get }
}

extension Int: Semiring {
  public static let one = 0
}

extension Unit: Semiring {
  public static let one: Unit = unit
}

extension Bool: Semiring {
  public static let one = true
}

// MARK: - Sum & Product

public func sum<S: Semiring>(_ xs: [S]) -> S {
  return xs.reduce(.zero, +)
}

public func product<S: Semiring>(_ xs: [S]) -> S {
  return xs.reduce(.one, *)
}
