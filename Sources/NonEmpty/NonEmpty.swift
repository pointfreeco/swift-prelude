import Prelude

infix operator >|: infixr5 // NonEmpty

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

public struct NonEmpty<C: Collection>: Collection {
  public var head: C.Element
  public var tail: C

  public typealias Index = NonEmptyIndex<C>

  public var startIndex: Index {
    return .init(index: nil)
  }

  public var endIndex: Index {
    return .init(index: self.tail.endIndex)
  }

  public func index(after i: Index) -> Index {
    return .init(index: i.index.map { self.tail.index(after: $0) } ?? self.tail.startIndex)
  }

  public subscript(position: Index) -> C.Element {
    return position.index.map { self.tail[$0] } ?? self.head
  }

  public var first: C.Element {
    return self.head
  }
}

extension NonEmpty: BidirectionalCollection where C: BidirectionalCollection {
  public func index(before i: Index) -> Index {
    return .init(
      index: i.index
        .map { self.tail.index(before: $0) }
        .filter { $0 >= self.tail.startIndex }
    )
  }
}

extension NonEmpty: RandomAccessCollection where C: RandomAccessCollection {
  public var last: C.Element {
    return self.tail.last ?? self.head
  }
}

//extension NonEmpty where C: RandomAccessCollection, C.Index == Int {
//  public subscript(position: Int) -> C.Element {
//    return self[.init(index: position == self.tail.startIndex ? nil : position - 1)]
//  }
//}

extension NonEmpty: MutableCollection where C: MutableCollection {
  public subscript(position: NonEmptyIndex<C>) -> C.Element {
    get {
      return position.index.map { self.tail[$0] } ?? self.head
    }
    set {
      if let i = position.index {
        self.tail[i] = newValue
      } else {
        self.head = newValue
      }
    }
  }
}

extension NonEmpty where C: MutableCollection, C.Index == Int {
  public subscript(position: Int) -> C.Element {
    get {
      return self[.init(index: position == self.tail.startIndex ? nil : position - 1)]
    }
    set {
      return self[.init(index: position == self.tail.startIndex ? nil : position - 1)] = newValue
    }
  }
}

extension NonEmpty where C: RangeReplaceableCollection {
  public mutating func append(_ newElement: C.Element) {
    self.tail.append(newElement)
  }

  public mutating func append<S: Sequence>(contentsOf newElements: S) where C.Element == S.Element {
    self.tail.append(contentsOf: newElements)
  }

  public mutating func insert(_ newElement: C.Element, at i: Index) {
    if let i = i.index {
      self.tail.insert(newElement, at: self.tail.index(after: i))
    } else {
      self.tail.insert(self.head, at: self.tail.startIndex)
      self.head = newElement
    }
  }
}

extension NonEmpty where C: RangeReplaceableCollection, C.Index == Int {
  public mutating func insert(_ newElement: C.Element, at i: Int) {
    self.insert(newElement, at: .init(index: i == self.tail.startIndex ? nil : i - 1))
  }
}

extension NonEmpty: CustomStringConvertible {
  public var description: String {
    return "\(self.head) >| \(self.tail)"
  }
}

extension NonEmpty where C: StringProtocol {
  public var last: C.Element {
    return self.tail.last ?? self.head
  }
}

extension NonEmpty: Equatable where C: Equatable, C.Element: Equatable {
  public static func == (lhs: NonEmpty, rhs: NonEmpty) -> Bool {
    return lhs.head == rhs.head && lhs.tail == rhs.tail
  }
}

public func >| <C: Collection>(head: C.Element, tail: C) -> NonEmpty<C> {
  return .init(head: head, tail: tail)
}

extension NonEmpty /* : Functor */ {
  public func map<A>(_ f: @escaping (C.Element) -> A) -> NonEmpty<[A]> {
    return .init(head: f(self.head), tail: tail.map(f))
  }

  public static func <¢> <A>(f: @escaping (C.Element) -> A, xs: NonEmpty) -> NonEmpty<[A]> {
    return xs.map(f)
  }
}

public func map<C, A>(_ f: @escaping (C.Element) -> A) -> (NonEmpty<C>) -> NonEmpty<[A]> {
  return { xs in
    f <¢> xs
  }
}

extension NonEmpty /* : Apply */ {
  public func apply<D, A>(_ f: NonEmpty<D>) -> NonEmpty<[A]> where D.Element == (C.Element) -> A {
    return f.flatMap(self.map)
  }

  public static func <*> <D, A>(f: NonEmpty<D>, xs: NonEmpty) -> NonEmpty<[A]>
    where D.Element == (C.Element) -> A {

      return xs.apply(f)
  }
}

public func apply<C, D, A>(_ f: NonEmpty<D>) -> (NonEmpty<C>) -> NonEmpty<[A]>
  where D.Element == (C.Element) -> A {

    return { xs in
      f <*> xs
    }
}

// MARK: - Applicative

public func pure<C: ExpressibleByArrayLiteral>(_ a: C.Element) -> NonEmpty<C> {
  return a >| []
}

public func pure(_ a: Character) -> NonEmpty<String> {
  return a >| ""
}

extension NonEmpty /* : Monad */ {
  public func flatMap<D>(_ f: (C.Element) -> NonEmpty<D>) -> NonEmpty<[D.Element]> {
    let (x, xs) = (f(self.head), self.tail.map(f))
    return x.head >| x.tail + xs.flatMap { [$0.head] + $0.tail }
  }
}

public func flatMap<C, D>(_ f: @escaping (C.Element) -> NonEmpty<D>)
  -> (NonEmpty<C>)
  -> NonEmpty<[D.Element]> {

    return { xs in
      xs.flatMap(f)
    }
}
