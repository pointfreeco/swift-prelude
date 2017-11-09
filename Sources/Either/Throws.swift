import Prelude

extension Either where L == Error {
  public static func wrap(_ fn: @escaping () throws -> R) -> Either {
    do {
      return .right(try fn())
    } catch let error {
      return .left(error)
    }
  }

  public static func wrap<A>(_ fn: @escaping (A) throws -> R) -> (A) -> Either {
    return { a in
      do {
        return .right(try fn(a))
      } catch let error {
        return .left(error)
      }
    }
  }

  public static func wrap<A, B>(_ fn: @escaping (A, B) throws -> R) -> (A, B) -> Either {
    return { a, b in
      do {
        return .right(try fn(a, b))
      } catch let error {
        return .left(error)
      }
    }
  }

  public static func wrap<A, B, C>(_ fn: @escaping (A, B, C) throws -> R) -> (A, B, C) -> Either {
    return { a, b, c in
      do {
        return .right(try fn(a, b, c))
      } catch let error {
        return .left(error)
      }
    }
  }

  public static func wrap<A, B, C, D>(_ fn: @escaping (A, B, C, D) throws -> R) -> (A, B, C, D) -> Either {
    return { a, b, c, d in
      do {
        return .right(try fn(a, b, c, d))
      } catch let error {
        return .left(error)
      }
    }
  }

  public static func wrap<A, B, C, D, E>(_ fn: @escaping (A, B, C, D, E) throws -> R) -> (A, B, C, D, E)
    -> Either {
      return { a, b, c, d, e in
        do {
          return .right(try fn(a, b, c, d, e))
        } catch let error {
          return .left(error)
        }
      }
  }

  public static func wrap<A, B, C, D, E, F>(_ fn: @escaping (A, B, C, D, E, F) throws -> R)
    -> (A, B, C, D, E, F)
    -> Either {
      return { a, b, c, d, e, f in
        do {
          return .right(try fn(a, b, c, d, e, f))
        } catch let error {
          return .left(error)
        }
      }
  }
}

extension Either where L == Error {
  public func unwrap() throws -> R {
    switch self {
    case .left(let l):
      throw l
    case .right(let r):
      return r
    }
  }
}

public extension Either where L: Error {
  public func unwrap() throws -> R {
    switch self {
    case .left(let l):
      throw l
    case .right(let r):
      return r
    }
  }
}

public func unwrap<R>(_ either: Either<Error, R>) throws -> R {
  return try either.unwrap()
}

public func unwrap<L: Error, R>(_ either: Either<L, R>) throws -> R {
  return try either.unwrap()
}
