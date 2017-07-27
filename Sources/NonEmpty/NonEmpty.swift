import Prelude

infix operator >|: infixr5 // NonEmpty

public protocol NonEmpty {
  associatedtype Sequence: Swift.Sequence
  var head: Sequence.Element { get }
  var tail: Sequence { get }
}

extension NonEmpty {
  public var count: Int {
    return self.count + 1
  }

  public var first: Sequence.Element {
    return self.head
  }
}

extension NonEmpty where Sequence: RandomAccessCollection {
  public var last: Sequence.Element {
    return self.tail.last ?? self.head
  }
}

extension Array {
  public init<S: NonEmpty>(_ nonEmpty: S) where S.Sequence.Element == Element {
    self = [nonEmpty.head] + Array(nonEmpty.tail)
  }
}

// MARK: - Functor

extension NonEmpty {
  public func map<A>(_ f: @escaping (Sequence.Element) -> A) -> NonEmptyArray<A> {
    return .init(head: f(self.head), tail: tail.map(f))
  }

  public static func <¢> <A>(f: @escaping (Sequence.Element) -> A, xs: Self) -> NonEmptyArray<A> {
    return xs.map(f)
  }
}

// MARK: - Apply

extension NonEmpty {
  public func apply<A>(_ f: NonEmptyArray<(Sequence.Element) -> A>) -> NonEmptyArray<A> {
    return f.flatMap(self.map)
  }

  public static func <*> <A>(f: NonEmptyArray<(Sequence.Element) -> A>, xs: Self) -> NonEmptyArray<A> {
    return xs.apply(f)
  }
}

public func apply<S: NonEmpty, A>(_ f: NonEmptyArray<(S.Sequence.Element) -> A>) -> (S) -> NonEmptyArray<A> {
  return { xs in
    f <*> xs
  }
}

// MARK: - Bind/Monad

extension NonEmpty {
  public func flatMap<A>(_ f: (Sequence.Element) -> NonEmptyArray<A>) -> NonEmptyArray<A> {
    let (x, xs) = (f(self.head), self.tail.map(f))
    return x.head >| x.tail + xs.flatMap { [$0.head] + $0.tail }
  }

  public static func >>- <A>(f: (Sequence.Element) -> NonEmptyArray<A>, xs: Self) -> NonEmptyArray<A> {
    return xs.flatMap(f)
  }
}

public func flatMap<S: NonEmpty, A>(_ f: @escaping (S.Sequence.Element) -> NonEmptyArray<A>)
  -> (S)
  -> NonEmptyArray<A> {

    return { xs in
      f >>- xs
    }
}

// MARK: - Equatable

extension NonEmpty where Sequence.Element: Equatable {
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
  public func reduce<A>(_ x: A, _ f: (A, Sequence.Element) -> A) -> A {
    return Array(self).reduce(x, f)
  }
}
