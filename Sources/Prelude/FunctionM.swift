public struct FunctionM<A, M: Monoid> {
  public let call: (A) -> M

  public init(_ call: @escaping (A) -> M) {
    self.call = call
  }
}

// MARK: - Semigroup

extension FunctionM: Semigroup {
  public static func <>(lhs: FunctionM, rhs: FunctionM) -> FunctionM {
    return FunctionM { props in
      lhs.call(props) <> rhs.call(props)
    }
  }
}

// MARK: - Monoid

extension FunctionM: Monoid {
  public static var empty: FunctionM {
    return FunctionM(const(M.empty))
  }
}

// MARK: - Functor

extension FunctionM {
  public func map<N>(_ f: @escaping (M) -> N) -> FunctionM<A, N> {
    return .init(self.call >>> f)
  }

  public static func <¢> <N>(f: @escaping (M) -> N, c: FunctionM) -> FunctionM<A, N> {
    return c.map(f)
  }
}

public func map<A, M, N>(_ f: @escaping (M) -> N) -> (FunctionM<A, M>) -> FunctionM<A, N> {
  return { g in g.map(f) }
}

// MARK: - Contravariant Functor

extension FunctionM {
  public func contramap<B>(_ f: @escaping (B) -> A) -> FunctionM<B, M> {
    return .init(f >>> self.call)
  }

  public static func >¢< <D, B, N>(f: @escaping (B) -> D, g: FunctionM<D, N>) -> FunctionM<B, N> {
    return g.contramap(f)
  }
}

public func contramap<D, B, N>(_ f: @escaping (B) -> D) -> (FunctionM<D, N>) -> FunctionM<B, N> {
  return { g in g.contramap(f) }
}

// MARK: - Apply

extension FunctionM {
  public func apply<N>(_ f: FunctionM<A, FunctionM<M, N>>) -> FunctionM<A, N> {
    return FunctionM<A, N>.init { a in
      f.call(a).call(self.call(a))
    }
  }

  public static func <*> <A, M, N>(f: FunctionM<A, FunctionM<M, N>>, x: FunctionM<A, M>) -> FunctionM<A, N> {
    return x.apply(f)
  }
}

// MARK: - Applicative

public func pure<A, M>(_ m: M) -> FunctionM<A, M> {
  return FunctionM(const(m))
}

// MARK: - Monad

extension FunctionM {
  public func flatMap<N>(_ f: @escaping (M) -> FunctionM<A, N>) -> FunctionM<A, N> {
    return FunctionM<A, N> { a in
      return f(self.call(a)).call(a)
    }
  }
}
