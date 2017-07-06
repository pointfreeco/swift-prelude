public func left<A, B, C>(_ a2b: @escaping (A) -> B) -> (Either<A, C>) -> Either<B, C> {
  return { either in
    switch either {
    case let .left(a):
      return .left(a2b(a))
    case let .right(c):
      return .right(c)
    }
  }
}

public func right<A, B, C>(_ b2c: @escaping (B) -> C) -> (Either<A, B>) -> Either<A, C> {
  return { either in
    switch either {
    case let .left(a):
      return .left(a)
    case let .right(c):
      return .right(b2c(c))
    }
  }
}
