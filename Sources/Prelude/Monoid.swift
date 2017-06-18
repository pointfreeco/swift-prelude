public protocol Monoid: Semigroup {
  static var e: Self { get }
}

public func concat<M: Monoid>(_ xs: [M]) -> M {
  return xs.reduce(M.e, <>)
}

extension String: Monoid {
  public static let e = ""

  public static func <>(lhs: String, rhs: String) -> String {
    return lhs + rhs
  }
}

extension Array: Monoid {
  public static var e: Array { return [] }

  public static func <>(lhs: Array, rhs: Array) -> Array {
    return lhs + rhs
  }
}

public func joined<M: Monoid>(_ s: M) -> ([M]) -> M {
  return { xs in
    if let head = xs.first {
      return xs.dropFirst().reduce(head) { accum, x in accum <> s <> x }
    }
    return .e
  }
}
