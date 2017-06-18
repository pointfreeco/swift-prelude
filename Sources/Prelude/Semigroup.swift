public protocol Semigroup {
  static func <>(_: Self, _: Self) -> Self
}

public prefix func <><S: Semigroup>(rhs: S) -> (S) -> S {
  return { lhs in lhs <> rhs }
}

public postfix func <><S: Semigroup>(lhs: S) -> (S) -> S {
  return { rhs in lhs <> rhs }
}

public func concat<S: Semigroup>(_ xs: [S], _ e: S) -> S {
  return xs.reduce(e, <>)
}
