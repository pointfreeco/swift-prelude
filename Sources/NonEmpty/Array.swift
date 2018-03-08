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
      if position == 0 {
        return self.head
      } else {
        return self.tail[position - 1]
      }
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
  public static func <> (lhs: NonEmptyArray, rhs: NonEmptyArray) -> NonEmptyArray {
    return lhs.head >| (lhs.tail <> [rhs.head] <> rhs.tail)
  }
}

// MARK: - Equatable

extension NonEmptyArray: Equatable where A: Equatable {
  public static func == (lhs: NonEmptyArray, rhs: NonEmptyArray) -> Bool {
    return lhs.head == rhs.head && lhs.tail == rhs.tail
  }
}
