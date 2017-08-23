import Prelude

public enum Either<L, R> {
  case left(L)
  case right(R)
}

extension Either {
  public func either<A>(_ l2a: (L) throws -> A, _ r2a: (R) -> A) rethrows -> A {
    switch self {
    case let .left(l):
      return try l2a(l)
    case let .right(r):
      return r2a(r)
    }
  }

  public var left: L? {
    return either(Optional.some, const(.none))
  }

  public var right: R? {
    return either(const(.none), Optional.some)
  }

  public var isLeft: Bool {
    return either(const(true), const(false))
  }

  public var isRight: Bool {
    return either(const(false), const(true))
  }
}

public func either<A, B, C>(_ a2c: @escaping (A) -> C, _ b2c: @escaping (B) -> C) -> (Either<A, B>) -> C {
  return { ab in
    ab.either(a2c, b2c)
  }
}

public func lefts<S: Sequence, L, R>(_ xs:S) -> [L] where S.Element == Either<L, R> {
  return xs |> mapOptional { $0.left }
}

public func rights<S: Sequence, L, R>(_ xs:S) -> [R] where S.Element == Either<L, R> {
  return xs |> mapOptional { $0.right }
}

public func note<L, R>(_ default: L) -> (R?) -> Either<L, R> {
  return optional(.left(`default`)) <| Either.right
}

public func hush<L, R>(_ lr: Either<L, R>) -> R? {
  return lr.either(const(.none), R?.some)
}

public extension Either where L == Error {
  public static func wrap<A>(_ f: @escaping (A) throws -> R) -> (A) -> Either {
    return { a in
      do {
        return .right(try f(a))
      } catch let error {
        return .left(error)
      }
    }
  }

  public static func wrap(_ f: @escaping () throws -> R) -> () -> Either {
    return {
      do {
        return .right(try f())
      } catch let error {
        return .left(error)
      }
    }
  }

  public func unwrap() throws -> R {
    return try either({ throw $0 }, id)
  }
}

public extension Either where L: Error {
  public func unwrap() throws -> R {
    return try either({ throw $0 }, id)
  }
}

public func unwrap<R>(_ either: Either<Error, R>) throws -> R {
  return try either.unwrap()
}

public func unwrap<L: Error, R>(_ either: Either<L, R>) throws -> R {
  return try either.unwrap()
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

  public static func <¢> <A>(r2a: (R) -> A, lr: Either) -> Either<L, A> {
    return lr.map(r2a)
  }
}

public func map<A, B, C>(_ b2c: @escaping (B) -> C) -> (Either<A, B>) -> Either<A, C> {
  return { ab in
    b2c <¢> ab
  }
}

// MARK: - Bifunctor

extension Either {
  public func bimap<A, B>(_ l2a: (L) -> A, _ r2b: (R) -> B) -> Either<A, B> {
    switch self {
    case let .left(l):
      return .left(l2a(l))
    case let .right(r):
      return .right(r2b(r))
    }
  }
}

public func bimap<A, B, C, D>(_ a2b: @escaping (A) -> B, _ c2d: @escaping (C) -> D)
  -> (Either<A, C>)
  -> Either<B, D> {
    return { ac in
      ac.bimap(a2b, c2d)
    }
}

// MARK: - Apply

extension Either {
  public func apply<A>(_ r2a: Either<L, (R) -> A>) -> Either<L, A> {
    return r2a.flatMap(self.map)
  }

  public static func <*> <A>(r2a: Either<L, (R) -> A>, lr: Either<L, R>) -> Either<L, A> {
    return lr.apply(r2a)
  }
}

public func apply<A, B, C>(_ b2c: Either<A, (B) -> C>) -> (Either<A, B>) -> Either<A, C> {
  return { ab in
    b2c <*> ab
  }
}

// MARK: - Applicative

public func pure<L, R>(_ r: R) -> Either<L, R> {
  return .right(r)
}

// MARK: - Alt

extension Either: Alt {
  public static func <|>(lhs: Either, rhs: @autoclosure () -> Either) -> Either {
    switch lhs {
    case .left:
      return rhs()
    case .right:
      return lhs
    }
  }
}

// MARK: - Bind/Monad

extension Either {
  public func flatMap<A>(_ r2a: (R) -> Either<L, A>) -> Either<L, A> {
    return either(Either<L, A>.left, r2a)
  }

  public static func >>- <A>(lr: Either, r2a: (R) -> Either<L, A>) -> Either<L, A> {
    return lr.flatMap(r2a)
  }
}

public func flatMap <L, R, A>(_ r2a: @escaping (R) -> Either<L, A>) -> (Either<L, R>) -> Either<L, A> {
  return { lr in
    lr >>- r2a
  }
}

// MARK: - Extend

extension Either {
  public static func <<- <A>(r2a: @escaping (Either) -> A, lr: Either) -> Either<L, A> {
    switch (r2a, lr) {
    case let (_, .left(a)):
      return .left(a)
    case let (f, b):
      return .right(f(b))
    }
  }
}

// MARK: - Eq/Equatable

extension Either where L: Equatable, R: Equatable {
  public static func == (lhs: Either, rhs: Either) -> Bool {
    switch (lhs, rhs) {
    case let (.left(lhs), .left(rhs)):
      return lhs == rhs
    case let (.right(lhs), .right(rhs)):
      return lhs == rhs
    default:
      return false
    }
  }

  public static func != (lhs: Either, rhs: Either) -> Bool {
    return !(lhs == rhs)
  }
}

// MARK: - Ord/Comparable

extension Either where L: Comparable, R: Comparable {
  public static func < (lhs: Either, rhs: Either) -> Bool {
    switch (lhs, rhs) {
    case let (.left(lhs), .left(rhs)):
      return lhs < rhs
    case let (.right(lhs), .right(rhs)):
      return lhs < rhs
    case (.left, .right):
      return true
    case (.right, .left):
      return false
    }
  }

  public static func <= (lhs: Either, rhs: Either) -> Bool {
    return lhs < rhs || lhs == rhs
  }

  public static func > (lhs: Either, rhs: Either) -> Bool {
    return !(lhs <= rhs)
  }

  public static func >= (lhs: Either, rhs: Either) -> Bool {
    return lhs > rhs || lhs == rhs
  }
}

// MARK: - Foldable/Sequence

extension Either where R: Sequence {
  public func reduce<A>(_ a: A, _ f: @escaping (A, R.Element) -> A) -> A {
    return self.map(Prelude.reduce(f) <| a).either(const(a), id)
  }
}

public func foldMap<S: Sequence, M: Monoid, L>(_ f: @escaping (S.Element) -> M) -> (Either<L, S>) -> M {
  return { xs in
    xs.reduce(.empty) { accum, x in accum <> f(x) }
  }
}

// MARK: - Semigroup

extension Either where R: Semigroup {
  public static func <> (lhs: Either, rhs: Either) -> Either {
    return curry(<>) <¢> lhs <*> rhs
  }
}
