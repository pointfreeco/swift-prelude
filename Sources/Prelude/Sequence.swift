public func catOptionals<S: Sequence, A>(_ xs: S) -> [A] where S.Element == A? {
  return xs |> mapOptional(id)
}

public func mapOptional<S: Sequence, A>(_ f: @escaping (S.Element) -> A?) -> (S) -> [A] {
  return { xs in
    xs.flatMap(f)
  }
}

// MARK: - Functor

extension Sequence {
  public static func <¢> <A>(f: (Element) -> A, xs: Self) -> [A] {
    return xs.map(f)
  }
}

public func map<S: Sequence, A>(_ f: @escaping (S.Element) -> A) -> (S) -> [A] {
  return { xs in
    return f <¢> xs
  }
}

// MARK: - Apply

public extension Sequence {
  public func apply<S: Sequence, A>(_ fs: S) -> [A] where S.Element == ((Element) -> A) {
    return fs.flatMap { f in self.map { x in f(x) } }
  }

  public static func <*> <S: Sequence, A>(fs: S, xs: Self) -> [A] where S.Element == ((Element) -> A) {
    return fs.flatMap { f in xs.map { x in f(x) } }
  }
}

public func apply<S: Sequence, T: Sequence, A>(_ fs: S) -> (T) -> [A] where S.Element == ((T.Element) -> A) {
  return { xs in
    return fs.flatMap { f in xs.map { x in f(x) } }
  }
}

// MARK: - Bind/Monad

extension Sequence {
  public static func >>- <S: Sequence>(xs: Self, f: (Element) -> S) -> [S.Element] {
    return xs.flatMap(f)
  }
}

public func flatMap<S: Sequence, A>(_ f: @escaping (S.Element) -> [A]) -> (S) -> [A] {
  return { xs in
    xs >>- f
  }
}

// MARK: - Monoid

extension Sequence where Element: Monoid {
  public func concat() -> Element {
    return Prelude.concat(self)
  }
}

public func concat<S: Sequence>(_ xs: S) -> S.Element where S.Element: Monoid {
  return xs.concat()
}

// MARK: - Foldable/Traversable

extension Sequence {
  public func foldMap<M: Monoid>(_ f: @escaping (Element) -> M) -> M {
    return self.reduce(M.empty) { m, x in m <> f(x) }
  }
}

public func foldMap<S: Sequence, M: Monoid>(_ f: @escaping (S.Element) -> M) -> (S) -> M {
  return { xs in
    xs.foldMap(f)
  }
}

// MARK: - Point-free Standard Library

public func contains<S: Sequence>(_ x: S.Element) -> (S) -> Bool where S.Element: Equatable {
  return { xs in
    xs.contains(x)
  }
}

public func contains<S: Sequence>(where p: @escaping (S.Element) -> Bool) -> (S) -> Bool {
  return { xs in
    xs.contains(where: p)
  }
}

public func drop<S: Sequence>(while p: @escaping (S.Element) -> Bool) -> (S) -> S.SubSequence {
  return { xs in
    xs.drop(while: p)
  }
}

public func dropFirst<S: Sequence>(_ xs: S) -> S.SubSequence {
  return xs.dropFirst()
}

public func dropFirst<S: Sequence>(_ n: Int) -> (S) -> S.SubSequence {
  return { xs in
    xs.dropFirst(n)
  }
}

public func dropLast<S: Sequence>(_ xs: S) -> S.SubSequence {
  return xs.dropLast()
}

public func dropLast<S: Sequence>(_ n: Int) -> (S) -> S.SubSequence {
  return { xs in
    xs.dropLast(n)
  }
}

public func filter<S: Sequence>(_ p: @escaping (S.Element) -> Bool) -> (S) -> [S.Element] {
  return { xs in
    xs.filter(p)
  }
}

public func flatMap<S: Sequence, T: Sequence>(_ f: @escaping (S.Element) -> T) -> (S) -> [T.Element] {
  return { xs in
    xs.flatMap(f)
  }
}

public func forEach<S: Sequence>(_ f: @escaping (S.Element) -> ()) -> (S) -> () {
  return { xs in
    xs.forEach(f)
  }
}

public func map<A, S: Sequence>(_ f: @escaping (S.Element) -> A) -> (S) -> [A] {
  return { xs in
    xs.map(f)
  }
}

public func prefix<S: Sequence>(_ n: Int) -> (S) -> S.SubSequence {
  return { xs in
    xs.prefix(n)
  }
}

public func prefix<S: Sequence>(while p: @escaping (S.Element) -> Bool) -> (S) -> S.SubSequence {
  return { xs in
    xs.prefix(while: p)
  }
}

public func reduce<A, S: Sequence>(_ f: @escaping (A, S.Element) -> A) -> (A) -> (S) -> A {
  return { a in
    { xs in
      xs.reduce(a, f)
    }
  }
}

public func sorted<S: Sequence>(_ xs: S) -> [S.Element] where S.Element: Comparable {
  return xs.sorted()
}

public func sorted<S: Sequence>(by f: @escaping (S.Element, S.Element) -> Bool) -> (S) -> [S.Element] {
  return { xs in
    xs.sorted(by: f)
  }
}

public func suffix<S: Sequence>(_ n: Int) -> (S) -> S.SubSequence {
  return { xs in
    xs.suffix(n)
  }
}

public func zipWith<S: Sequence, T: Sequence, A>(_ f: @escaping (S.Element, T.Element) -> A)
  -> (S)
  -> (T)
  -> [A] {
    return { xs in
      return { ys in
        return zip(xs, ys).map { f($0.0, $0.1) }
      }
    }
}
