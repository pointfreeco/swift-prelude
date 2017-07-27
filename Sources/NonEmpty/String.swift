import Prelude

public struct NonEmptyString: NonEmpty {
  public let head: Character
  public let tail: String
}

public func >|(head: Character, tail: String) -> NonEmptyString {
  return .init(head: head, tail: tail)
}

extension String {
  public init(_ nonEmpty: NonEmptyString) {
    self = String(nonEmpty.head) + nonEmpty.tail
  }
}

// MARK: - Applicative

public func pure(_ x: Character) -> NonEmptyString {
  return x >| ""
}

// MARK: - Semigroup

extension NonEmptyString {
  public static func <>(lhs: NonEmptyString, rhs: NonEmptyString) -> NonEmptyString {
    return lhs.head >| (lhs.tail <> String(rhs.head) <> rhs.tail)
  }
}
