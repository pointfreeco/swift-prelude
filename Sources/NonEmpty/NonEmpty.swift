import Prelude

infix operator >|: infixr5 // NonEmpty

public protocol NonEmpty: Collection {
  associatedtype Collection: Swift.Collection
  var head: Collection.Element { get }
  var tail: Collection { get }
}

public protocol MutableNonEmpty: NonEmpty, MutableCollection {
}

public func uncons<S: NonEmpty>(_ xs: S) -> (S.Collection.Element, S.Collection) {
  return (xs.head, xs.tail)
}

extension NonEmpty {
  public var first: Collection.Element {
    return self.head
  }
}

extension NonEmpty where Collection: RandomAccessCollection {
  public var last: Collection.Element {
    return self.tail.last ?? self.head
  }
}

extension Array {
  public init<S: NonEmpty>(_ nonEmpty: S) where S.Collection.Element == Element {
    self = [nonEmpty.head] + Array(nonEmpty.tail)
  }
}

// MARK: - Sequence

extension NonEmpty {
  public func makeIterator() -> AnyIterator<Collection.Element> {
    var returnHead = true
    var tailIterator = self.tail.makeIterator()
    return .init {
      if returnHead {
        defer { returnHead = false }
        return self.head
      } else {
        return tailIterator.next()
      }
    }
  }
}

// MARK: - Collection

extension NonEmpty {
  public var startIndex: Collection.Index {
    return self.tail.startIndex
  }

  public var endIndex: Collection.Index {
    return self.tail.index(after: self.tail.endIndex)
  }

  public func index(after i: Collection.Index) -> Collection.Index {
    return self.tail.index(after: i)
  }

  public subscript(_ idx: Collection.Index) -> Collection.Element {
    return idx == self.tail.startIndex ? self.head : self.tail[self.tail.index(after: idx)]
  }
}

// MARK: - Functor

extension NonEmpty {
  public func map<A>(_ f: @escaping (Collection.Element) -> A) -> NonEmptyArray<A> {
    return .init(head: f(self.head), tail: tail.map(f))
  }

  public static func <¢> <A>(f: @escaping (Collection.Element) -> A, xs: Self) -> NonEmptyArray<A> {
    return xs.map(f)
  }
}

// MARK: - Apply

extension NonEmpty {
  public func apply<A>(_ f: NonEmptyArray<(Collection.Element) -> A>) -> NonEmptyArray<A> {
    return f.flatMap(self.map)
  }

  public static func <*> <A>(f: NonEmptyArray<(Collection.Element) -> A>, xs: Self) -> NonEmptyArray<A> {
    return xs.apply(f)
  }
}

public func apply<S: NonEmpty, A>(_ f: NonEmptyArray<(S.Collection.Element) -> A>) -> (S) -> NonEmptyArray<A> {
  return { xs in
    f <*> xs
  }
}

// MARK: - Bind/Monad

extension NonEmpty {
  public func flatMap<A>(_ f: (Collection.Element) -> NonEmptyArray<A>) -> NonEmptyArray<A> {
    let (x, xs) = (f(self.head), self.tail.map(f))
    return x.head >| x.tail + xs.flatMap { [$0.head] + $0.tail }
  }

  public static func >>- <A>(f: (Collection.Element) -> NonEmptyArray<A>, xs: Self) -> NonEmptyArray<A> {
    return xs.flatMap(f)
  }
}

public func flatMap<S: NonEmpty, A>(_ f: @escaping (S.Collection.Element) -> NonEmptyArray<A>)
  -> (S)
  -> NonEmptyArray<A> {

    return { xs in
      f >>- xs
    }
}

// MARK: - Equatable

extension NonEmpty where Collection.Element: Equatable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    guard lhs.head == rhs.head else { return false }
    for (x, y) in zip(lhs.tail, rhs.tail) {
      guard x == y else { return false }
    }
    return true
  }

  public static func !=(lhs: Self, rhs: Self) -> Bool {
    return !(lhs == rhs)
  }
}

// MARK: - Foldable

extension NonEmpty {
  public func reduce<A>(_ x: A, _ f: (A, Collection.Element) -> A) -> A {
    return Array(self).reduce(x, f)
  }
}
