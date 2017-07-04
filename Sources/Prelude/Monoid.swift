public protocol Monoid: Semigroup {
  static var empty: Self { get }
}

extension String: Monoid {
  public static let empty = ""
}

extension Array: Monoid {
  public static var empty: Array { return [] }
}

public func joined<M: Monoid>(_ s: M) -> ([M]) -> M {
  return { xs in
    if let head = xs.first {
      return xs.dropFirst().reduce(head) { accum, x in accum <> s <> x }
    }
    return .empty
  }
}
