import Prelude

public struct NonEmptyArray<A>: MutableNonEmpty {
  public private(set) var head: A
  public private(set) var tail: [A]

  public subscript(position: Int) -> A {
    get {
      return position == 0 ? self.head : self.tail[position - 1]
    }
    set(newValue) {
      if position == 0 {
        self.head = newValue
      } else {
        self.tail[position - 1] = newValue
      }
    }
  }
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
