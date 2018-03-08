import Prelude

public struct NonEmptySet<A: Hashable>: NonEmpty {
  public let head: A
  public let tail: Set<A>

  public var startIndex: NonEmptyIndex<Set<A>> {
    return .init(index: nil)
  }

  public var endIndex: NonEmptyIndex<Set<A>> {
    return .init(index: self.tail.endIndex)
  }

  public func index(after position: NonEmptyIndex<Set<A>>) -> NonEmptyIndex<Set<A>> {
    return .init(index: position.index.map { self.tail.index(after: $0) } ?? self.tail.startIndex)
  }

  public subscript(position: NonEmptyIndex<Set<A>>) -> A {
    return position.index.map { self.tail[$0] } ?? self.head
  }
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

// MARK: - Equatable

extension NonEmptySet: Equatable where A: Equatable {
  public static func == (lhs: NonEmptySet, rhs: NonEmptySet) -> Bool {
    return lhs.head == rhs.head && lhs.tail == rhs.tail
  }
}
