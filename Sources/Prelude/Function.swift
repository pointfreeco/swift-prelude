public struct Function<A, B>: FunctionProtocol {
  public typealias Source = A
  public typealias Target = B

  public let call: (A) -> B
  public init(_ call: @escaping (A) -> B) {
    self.call = call
  }
}

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

public func <| <A, B> (f: (A) -> B, a: A) -> B {
  return f(a)
}

public func |> <A, B> (a: A, f: (A) -> B) -> B {
  return f(a)
}

public func uncurry<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (A, B) -> C {
  return { a, b in
    f(a)(b)
  }
}

public func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
  return { b in
    { a in
      f(a)(b)
    }
  }
}

public func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
  return { a in
    { b in
      f(a, b)
    }
  }
}

public func >>- <A, B, C>(lhs: @escaping (B) -> ((A) -> C), rhs: @escaping (A) -> B) -> (A) -> C {
  return { a in
    lhs(rhs(a))(a)
  }
}

public func >-> <A, B, C, D>(lhs: @escaping (A) -> ((D) -> B), rhs: @escaping (B) -> ((D) -> C)) -> (A) -> ((D) -> C) {
  return { a in
    rhs >>- lhs(a)
  }
}
