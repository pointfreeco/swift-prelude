public protocol Monoid: Semigroup {
  static var e: Self { get }
}

public func concat<S: Sequence>(_ xs: S) -> S.Element where S.Element: Monoid {
  return xs.reduce(S.Element.e, <>)
}

extension String: Monoid {
  public static let e = ""
}

extension Array: Monoid {
  public static var e: Array { return [] }
}

public func joined<M: Monoid>(_ s: M) -> ([M]) -> M {
  return { xs in
    if let head = xs.first {
      return xs.dropFirst().reduce(head) { accum, x in accum <> s <> x }
    }
    return .e
  }
}
