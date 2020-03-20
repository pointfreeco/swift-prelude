public func catOptionals<S: Sequence, A>(_ xs: S) -> [A] where S.Element == A? {
  return xs |> mapOptional(id)
}

public func mapOptional<S: Sequence, A>(_ f: @escaping (S.Element) -> A?) -> (S) -> [A] {
  { xs in
    xs.compactMap(f)
  }
}

// MARK: - Functor

extension Sequence {
  public static func <¢> <A>(f: (Element) -> A, xs: Self) -> [A] {
    xs.map(f)
  }
}

public func map<S: Sequence, A>(_ f: @escaping (S.Element) -> A) -> (S) -> [A] {
  { xs in
    f <¢> xs
  }
}

// MARK: - Apply

extension Sequence {
  public func apply<S: Sequence, A>(_ fs: S) -> [A] where S.Element == ((Element) -> A) {
    // return fs.flatMap(self.map) // https://bugs.swift.org/browse/SR-5251
    return fs.flatMap { f in self.map { x in f(x) } }
  }

  public static func <*> <S: Sequence, A>(fs: S, xs: Self) -> [A] where S.Element == ((Element) -> A) {
    // return xs.apply(fs) // https://bugs.swift.org/browse/SR-5251
    return fs.flatMap { f in xs.map { x in f(x) } }
  }
}

public func apply<S: Sequence, T: Sequence, A>(_ fs: S) -> (T) -> [A] where S.Element == ((T.Element) -> A) {
  return { xs in
    // fs <*> xs // https://bugs.swift.org/browse/SR-5251
    fs.flatMap { f in xs.map { x in f(x) } }
  }
}

// MARK: - Bind/Monad

public func flatMap<S: Sequence, A>(_ f: @escaping (S.Element) -> [A]) -> (S) -> [A] {
  { xs in
    xs.flatMap(f)
  }
}

// MARK: - Monoid

extension Sequence where Element: Monoid {
  public func concat() -> Element {
    Prelude.concat(self)
  }
}

public func concat<S: Sequence>(_ xs: S) -> S.Element where S.Element: Monoid {
  return xs.reduce(.empty, <>)
}

// MARK: - Foldable/Sequence

extension Sequence {
  public func foldMap<M: Monoid>(_ f: @escaping (Element) -> M) -> M {
    self.reduce(M.empty) { m, x in m <> f(x) }
  }
}

public func foldMap<S: Sequence, M: Monoid>(_ f: @escaping (S.Element) -> M) -> (S) -> M {
  { xs in
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
  { xs in
    xs.contains(where: p)
  }
}

public func filter<S: Sequence>(_ p: @escaping (S.Element) -> Bool) -> (S) -> [S.Element] {
  { xs in
    xs.filter(p)
  }
}

public func flatMap<S: Sequence, T: Sequence>(_ f: @escaping (S.Element) -> T) -> (S) -> [T.Element] {
  { xs in
    xs.flatMap(f)
  }
}

public func forEach<S: Sequence>(_ f: @escaping (S.Element) -> ()) -> (S) -> () {
  return { xs in
    xs.forEach(f)
  }
}

public func map<A, S: Sequence>(_ f: @escaping (S.Element) -> A) -> (S) -> [A] {
  { xs in
    xs.map(f)
  }
}

public func reduce<A, S: Sequence>(_ f: @escaping (A, S.Element) -> A) -> (A) -> (S) -> A {
  { a in
    { xs in
      xs.reduce(a, f)
    }
  }
}

public func sorted<S: Sequence>(_ xs: S) -> [S.Element] where S.Element: Comparable {
  return xs.sorted()
}

public func sorted<S: Sequence>(by f: @escaping (S.Element, S.Element) -> Bool) -> (S) -> [S.Element] {
  { xs in
    xs.sorted(by: f)
  }
}

public func zipWith<S: Sequence, T: Sequence, A>(_ f: @escaping (S.Element, T.Element) -> A)
  -> (S)
  -> (T)
  -> [A] {
    { xs in
      { ys in
        zip(xs, ys).map { f($0.0, $0.1) }
      }
    }
}

public func intersperse<A>(_ a: A) -> ([A]) -> [A] {
  { xs in
    var result = [A]()
    for x in xs.dropLast() {
      result.append(x)
      result.append(a)
    }
    xs.last.do { result.append($0) }
    return result
  }
}
