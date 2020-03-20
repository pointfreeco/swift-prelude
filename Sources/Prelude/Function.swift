public func id<A>(_ a: A) -> A {
  a
}

public func <<< <A, B, C>(_ b2c: @escaping (B) -> C, _ a2b: @escaping (A) -> B) -> (A) -> C {
  { a in b2c(a2b(a)) }
}

public func >>> <A, B, C>(_ a2b: @escaping (A) -> B, _ b2c: @escaping (B) -> C) -> (A) -> C {
  { a in b2c(a2b(a)) }
}

public func const<A, B>(_ a: A) -> (B) -> A {
  { _ in a }
}

public func <| <A, B> (f: (A) -> B, a: A) -> B {
  f(a)
}

public func |> <A, B> (a: A, f: (A) -> B) -> B {
  f(a)
}

public func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
  { b in
    { a in
      f(a)(b)
    }
  }
}

// MARK: - Bind/Monad

public func flatMap <A, B, C>(_ lhs: @escaping (B) -> ((A) -> C), _ rhs: @escaping (A) -> B) -> (A) -> C {
  { a in
    lhs(rhs(a))(a)
  }
}

public func >=> <A, B, C, D>(lhs: @escaping (A) -> ((D) -> B), rhs: @escaping (B) -> ((D) -> C))
  -> (A)
  -> ((D) -> C) {
    return { a in
      flatMap(rhs, lhs(a))
    }
}
