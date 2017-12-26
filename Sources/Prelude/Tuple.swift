public func tuple<A, B>(_ x: A) -> (B) -> (A, B) {
  return { y in (x, y) }
}

public func first<A, B>(_ x: (A, B)) -> A {
  return x.0
}

public func second<A, B>(_ x: (A, B)) -> B {
  return x.1
}

public func first<A, B, C, D>(_ a2b: @escaping (A) -> B) -> ((A, C, D)) -> (B, C, D) {
  return { ac in (a2b(ac.0), ac.1, ac.2) }
}

func requireFirst<A, B, C>(_ x: (A?, B, C)) -> (A, B, C)? {
  return x.0.map { ($0, x.1, x.2) }
}

public func tupleArray<A>(_ tuple: (A, A)) -> [A] {
  return [tuple.0, tuple.1]
}

public func tupleArray<A>(_ tuple: (A, A, A)) -> [A] {
  return [tuple.0, tuple.1, tuple.2]
}

public func tupleArray<A>(_ tuple: (A, A, A, A)) -> [A] {
  return [tuple.0, tuple.1, tuple.2, tuple.3]
}

public func tupleArray<A>(_ tuple: (A, A, A, A, A)) -> [A] {
  return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4]
}

public func tupleArray<A>(_ tuple: (A, A, A, A, A, A)) -> [A] {
  return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4, tuple.5]
}

public func tupleArray<A>(_ tuple: (A, A, A, A, A, A, A)) -> [A] {
  return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4, tuple.5, tuple.6]
}

public func tupleArray<A>(_ tuple: (A, A, A, A, A, A, A, A)) -> [A] {
  return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4, tuple.5, tuple.6, tuple.7]
}

public func tupleArray<A>(_ tuple: (A, A, A, A, A, A, A, A, A)) -> [A] {
  return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4, tuple.5, tuple.6, tuple.7, tuple.8]
}

public func tupleArray<A>(_ tuple: (A, A, A, A, A, A, A, A, A, A)) -> [A] {
  return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4, tuple.5, tuple.6, tuple.7, tuple.8, tuple.9]
}

// MARK: - Semigroupoid

public func >>> <A, B, C>(_ ab: (A, B), _ bc: (B, C)) -> (A, C) {
  return (ab.0, bc.1)
}

public func <<< <A, B, C>(_ bc: (B, C), _ ab: (A, B)) -> (A, C) {
  return (ab.0, bc.1)
}

// MARK: - Semigroup

public func <> <A: Semigroup, B: Semigroup>(_ ab1: (A, B), _ ab2: (A, B)) -> (A, B) {
  return (ab1.0 <> ab2.0, ab1.1 <> ab2.1)
}

// MARK: - Monoid

public func empty<A: Monoid, B: Monoid>() -> (A, B) {
  return (A.empty, B.empty)
}
