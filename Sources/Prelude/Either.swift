public enum Either<L, R> {
  case left(L)
  case right(R)
}

extension Either {
  public var left: L? {
    switch self {
    case let .left(l):
      return l
    case .right:
      return nil
    }
  }

  public var right: R? {
    switch self {
    case .left:
      return nil
    case let .right(r):
      return r
    }
  }
}

public func rights<L, R>(_ xs: [Either<L, R>]) -> [R] {
  return xs |> mapOptional { $0.right }
}

// MARK: - Functor

extension Either {
  public func map<A>(_ r2a: (R) -> A) -> Either<L, A> {
    switch self {
    case let .left(l):
      return .left(l)
    case let .right(r):
      return .right(r2a(r))
    }
  }
}

public func map<A, B, C>(_ b2c: @escaping (B) -> C) -> (Either<A, B>) -> Either<A, C> {
  return { b in
    b.map(b2c)
  }
}

public func <¢> <A, B, C>(b2c: (B) -> C, b: Either<A, B>) -> Either<A, C> {
  return b.map(b2c)
}

// MARK: - Apply

public func <*> <A, B, C>(b2c: Either<A, (B) -> C>, b: Either<A, B>) -> Either<A, C> {
  return b2c.flatMap { f in b.map(f) }
}

// MARK: - Applicative

public func pure<L, R>(_ r: R) -> Either<L, R> {
  return .right(r)
}

// MARK: - Alt

public func <|> <L, R>(lhs: Either<L, R>, rhs: Either<L, R>) -> Either<L, R> {
  switch (lhs, rhs) {
  case (.left, .right):
    return rhs
  default:
    return lhs
  }
}

// MARK: - Bind/Monad

extension Either {
  public func flatMap<A>(_ r2a: (R) -> Either<L, A>) -> Either<L, A> {
    switch self {
    case let .left(l):
      return .left(l)
    case let .right(r):
      return r2a(r)
    }
  }
}

public func >>- <A, B, C>(b2c: (B) -> Either<A, C>, b: Either<A, B>) -> Either<A, C> {
  return b.flatMap(b2c)
}

// MARK: - Semigroup

public func <> <L, R: Semigroup>(lhs: Either<L, R>, rhs: Either<L, R>) -> Either<L, R> {
  return lhs.flatMap { lhs in rhs.map { rhs in lhs <> rhs } }
}
