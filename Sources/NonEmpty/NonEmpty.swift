import Prelude

infix operator >|: infixr5 // NonEmpty

public protocol NonEmpty: Collection {
  associatedtype Collection: Swift.Collection
  var head: Collection.Element { get }
  var tail: Collection { get }
}

public struct NonEmptyIndex<C: Collection>: Comparable {
  let index: C.Index?

  public static func < (lhs: NonEmptyIndex, rhs: NonEmptyIndex) -> Bool {
    switch (lhs.index, rhs.index) {
    case (.none, .some):
      return true
    case let (.some(lhs), .some(rhs)):
      return lhs < rhs
    case (.some, .none), (.none, .none):
      return false
    }
  }

  public static func == (lhs: NonEmptyIndex, rhs: NonEmptyIndex) -> Bool {
    return lhs.index == rhs.index
  }
}

public protocol MutableNonEmpty: NonEmpty, MutableCollection {}

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

// MARK: - Functor

extension NonEmpty {
  public func map<A>(_ f: @escaping (Collection.Element) -> A) -> NonEmptyArray<A> {
    return .init(head: f(self.head), tail: tail.map(f))
  }

  public static func <¢> <A>(f: @escaping (Collection.Element) -> A, xs: Self) -> NonEmptyArray<A> {
    return xs.map(f)
  }
}

public func map<S: NonEmpty, A>(_ f: @escaping (S.Collection.Element) -> A) -> (S) -> NonEmptyArray<A> {
  return { xs in
    f <¢> xs
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

  public static func >>- <A>(xs: Self, f: (Collection.Element) -> NonEmptyArray<A>) -> NonEmptyArray<A> {
    return xs.flatMap(f)
  }
}

public func flatMap<S: NonEmpty, A>(_ f: @escaping (S.Collection.Element) -> NonEmptyArray<A>)
  -> (S)
  -> NonEmptyArray<A> {

    return { xs in
      xs >>- f
    }
}
