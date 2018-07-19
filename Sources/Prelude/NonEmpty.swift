@_exported import NonEmpty

extension NonEmpty /* : Functor */ {
  public func map<A>(_ f: @escaping (C.Element) -> A) -> NonEmpty<[A]> {
    return .init(f(self.head), tail.map(f))
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
  return .init(a, [])
}

public func pure(_ a: Character) -> NonEmpty<String> {
  return .init(a, "")
}

extension NonEmpty /* : Monad */ {
  public func flatMap<D>(_ f: (C.Element) -> NonEmpty<D>) -> NonEmpty<[D.Element]> {
    let (x, xs) = (f(self.head), self.tail.map(f))
    return .init(x.head, x.tail + xs.flatMap { [$0.head] + $0.tail })
  }
}

public func flatMap<C, D>(_ f: @escaping (C.Element) -> NonEmpty<D>)
  -> (NonEmpty<C>)
  -> NonEmpty<[D.Element]> {

    return { xs in
      xs.flatMap(f)
    }
}
