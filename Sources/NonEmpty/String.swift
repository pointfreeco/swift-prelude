import Prelude

public struct NonEmptyString: NonEmpty {
  public let head: Character
  public let tail: String

  public var startIndex: NonEmptyIndex<String> {
    return .init(index: nil)
  }

  public var endIndex: NonEmptyIndex<String> {
    return .init(index: self.tail.endIndex)
  }

  public func index(after position: NonEmptyIndex<String>) -> NonEmptyIndex<String> {
    return .init(index: position.index.map { self.tail.index(after: $0) } ?? self.tail.startIndex)
  }

  public subscript(position: NonEmptyIndex<String>) -> Character {
    return position.index.map { self.tail[$0] } ?? self.head
  }
}

public func >| (head: Character, tail: String) -> NonEmptyString {
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
  public static func <> (lhs: NonEmptyString, rhs: NonEmptyString) -> NonEmptyString {
    return lhs.head >| (lhs.tail <> String(rhs.head) <> rhs.tail)
  }
}

// MARK: - Equatable

extension NonEmptyString: Equatable {
  public static func == (lhs: NonEmptyString, rhs: NonEmptyString) -> Bool {
    return lhs.head == rhs.head && lhs.tail == rhs.tail
  }
}
