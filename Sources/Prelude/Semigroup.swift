public protocol Semigroup {
  static func <>(lhs: Self, rhs: Self) -> Self
}

public prefix func <><S: Semigroup>(rhs: S) -> (S) -> S {
  return { lhs in lhs <> rhs }
}

public postfix func <><S: Semigroup>(lhs: S) -> (S) -> S {
  return { rhs in lhs <> rhs }
}

public func concat<S: Sequence>(_ xs: S, _ e: S.Element) -> S.Element where S.Element: Semigroup {
  return xs.reduce(e, <>)
}

extension String: Semigroup {
  public static func <>(lhs: String, rhs: String) -> String {
    return lhs + rhs
  }
}

extension Array: Semigroup {
  public static func <>(lhs: Array, rhs: Array) -> Array {
    return lhs + rhs
  }
}

public func <> <A>(lhs: @escaping (A) -> A, rhs: @escaping (A) -> A) -> (A) -> A {
  return lhs >>> rhs
}

public struct Sum<A: Numeric> {
  public let unSum: A

  public init(_ unSum: A) {
    self.unSum = unSum
  }
}

extension Sum {
  public static func <>(lhs: Sum, rhs: Sum) -> Sum {
    return Sum(lhs.unSum + rhs.unSum)
  }
}
