public func first<A, B>(_ x: (A, B)) -> A {
  return x.0
}

public func second<A, B>(_ x: (A, B)) -> B {
  return x.1
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
