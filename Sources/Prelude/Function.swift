public func id<A>(_ a: A) -> A {
  return a
}

public func <<< <A, B, C>(_ b2c: @escaping (B) -> C, _ a2b: @escaping (A) -> B) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

public func >>> <A, B, C>(_ a2b: @escaping (A) -> B, _ b2c: @escaping (B) -> C) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

public func const<A, B>(_ a: A) -> (B) -> A {
  return { _ in a }
}

public func <| <A, B> (f: (A) throws -> B, a: A) rethrows -> B {
  return try f(a)
}

public func |> <A, B> (a: A, f: (A) throws -> B) rethrows -> B {
  return try f(a)
}

public func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
  return { b in
    { a in
      f(a)(b)
    }
  }
}

// MARK: - Bind/Monad

public func >>- <A, B, C>(lhs: @escaping (B) -> ((A) -> C), rhs: @escaping (A) -> B) -> (A) -> C {
  return { a in
    lhs(rhs(a))(a)
  }
}

public func >-> <A, B, C, D>(lhs: @escaping (A) -> ((D) -> B), rhs: @escaping (B) -> ((D) -> C))
  -> (A)
  -> ((D) -> C) {
    return { a in
      rhs >>- lhs(a)
    }
}
