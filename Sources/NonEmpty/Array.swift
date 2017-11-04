import Prelude

public struct NonEmptyArray<A>: MutableNonEmpty {
  public private(set) var head: A
  public private(set) var tail: [A]

  public var startIndex: Int {
    return 0
  }

  public var endIndex: Int {
    return self.tail.endIndex + 1
  }

  public func index(after i: Int) -> Int {
    return i + 1
  }

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

  public mutating func append(_ newElement: A) {
    self.tail.append(newElement)
  }

  /// - returns: The last element of the collection if it can be removed safely or `nil` if the collection is
  ///   a singleton.
  public mutating func popLast() -> A? {
    return self.tail.popLast()
  }
}

public func >| <A>(head: A, tail: [A]) -> NonEmptyArray<A> {
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
