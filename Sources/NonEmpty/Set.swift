import Prelude

public struct NonEmptySet<A: Hashable>: NonEmpty {
  public let head: A
  public let tail: Set<A>
}

public func >| <A>(head: A, tail: Set<A>) -> NonEmptySet<A> {
  return .init(head: head, tail: tail.subtracting([head]))
}

// MARK: - Applicative

public func pure<A>(_ x: A) -> NonEmptySet<A> {
  return x >| []
}

// MARK: - Semigroup

extension NonEmptySet {
  public static func <>(lhs: NonEmptySet, rhs: NonEmptySet) -> NonEmptySet {
    return lhs.head >| (lhs.tail <> [rhs.head] <> rhs.tail)
  }
}
