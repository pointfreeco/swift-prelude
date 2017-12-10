import Prelude

/// A monad transformer (like `ExceptT`) for `IO` and `Either`.
public struct EitherIO<E, A> {
  public let run: IO<Either<E, A>>

  public init(run: IO<Either<E, A>>) {
    self.run = run
  }
}

public func lift<E, A>(_ x: Either<E, A>) -> EitherIO<E, A> {
  return EitherIO.init <<< pure <| x
}

public func lift<E, A>(_ x: IO<A>) -> EitherIO<E, A> {
  return EitherIO.init <<< map(Either.right) <| x
}

public func throwE<E, A>(_ x: E) -> EitherIO<E, A> {
  return lift(.left(x))
}

public func catchE<E, A>(_ x: EitherIO<E, A>, _ f: @escaping (E) -> EitherIO<E, A>) -> EitherIO<E, A> {
  return .init(
    run: x.run.flatMap(either(get(\.run) <<< f, pure <<< Either.right))
  )
}

extension EitherIO where E == Error {
  public static func wrap(_ f: @escaping () throws -> A) -> EitherIO {
    return EitherIO.init <<< pure <| Either.wrap(f)
  }

  public func `catch`(_ f: @escaping (E) -> EitherIO) -> EitherIO {
    return catchE(self, f)
  }

  public func mapExcept<F, B>(_ f: @escaping (Either<E, A>) -> Either<F, B>) -> EitherIO<F, B> {
    return .init(
      run: self.run.map(f)
    )
  }

  public func withExcept<F>(_ f: @escaping (E) -> F) -> EitherIO<F, A> {
    return self.bimap(f, id)
  }
}

// MARK: - Functor

extension EitherIO {
  public func map<B>(_ f: @escaping (A) -> B) -> EitherIO<E, B> {
    return .init(
      run: self.run.map { $0.map(f) }
    )
  }

  public static func <¢> <B>(f: @escaping (A) -> B, x: EitherIO) -> EitherIO<E, B> {
    return x.map(f)
  }
}

public func map<E, A, B>(_ f: @escaping (A) -> B) -> (EitherIO<E, A>) -> EitherIO<E, B> {
  return { f <¢> $0 }
}

// MARK: - Bifunctor

extension EitherIO {
  public func bimap<F, B>(_ f: @escaping (E) -> F, _ g: @escaping (A) -> B) -> EitherIO<F, B> {
    return .init(run: self.run.map { $0.bimap(f, g) })
  }
}

public func bimap<E, F, A, B>(_ f: @escaping (E) -> F, _ g: @escaping (A) -> B)
  -> (EitherIO<E, A>)
  -> EitherIO<F, B> {
    return { $0.bimap(f, g) }
}

// MARK: - Apply

extension EitherIO {
  public func apply<B>(_ f: EitherIO<E, (A) -> B>) -> EitherIO<E, B> {
    return .init(run: curry(<*>) <¢> f.run <*> self.run)
  }

  public static func <*> <B>(f: EitherIO<E, (A) -> B>, x: EitherIO) -> EitherIO<E, B> {
    return x.apply(f)
  }
}

public func apply<E, A, B>(_ f: EitherIO<E, (A) -> B>) -> (EitherIO<E, A>) -> EitherIO<E, B> {
  return { f <*> $0 }
}

// MARK: - Applicative

public func pure<E, A>(_ x: (A)) -> EitherIO<E, A> {
  return EitherIO.init <<< pure <<< pure <| x
}

// MARK: - Alt

extension EitherIO: Alt {
  public static func <|>(lhs: EitherIO, rhs: @autoclosure @escaping () -> EitherIO) -> EitherIO {
    return .init(run: .init { lhs.run.perform() <|> rhs().run.perform() })
  }
}

// MARK: - Bind/Monad

extension EitherIO {
  public func flatMap<B>(_ f: @escaping (A) -> EitherIO<E, B>) -> EitherIO<E, B> {
    return .init(
      run: self.run.flatMap(either(pure <<< Either.left, get(\.run) <<< f))
    )
  }

  public static func >>- <B>(_ x: EitherIO<E, A>, _ f: @escaping (A) -> EitherIO<E, B>) -> EitherIO<E, B> {
    return x.flatMap(f)
  }
}

public func flatMap<E, A, B>(_ f: @escaping (A) -> EitherIO<E, B>) -> (EitherIO<E, A>) -> EitherIO<E, B> {
  return { $0 >>- f }
}
