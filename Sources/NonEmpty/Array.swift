import Prelude

public struct NonEmptyArray<A>: NonEmpty {
  public let head: A
  public let tail: [A]
}

public func >| <T>(head: T, tail: [T]) -> NonEmptyArray<T> {
  return .init(head: head, tail: tail)
}

// MARK: - Applicative

public func pure<A>(_ x: A) -> NonEmptyArray<A> {
  return x >| []
}

// MARK: - Semigroup

extension NonEmptyArray {
  public static func <>(lhs: NonEmptyArray, rhs: NonEmptyArray) -> NonEmptyArray {
    return lhs.head >| (lhs.tail <> [rhs.head] <> rhs.tail)
  }
}
