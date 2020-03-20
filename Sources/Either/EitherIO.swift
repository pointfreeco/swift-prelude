import Dispatch
import Foundation
import Prelude

/// A monad transformer (like `ExceptT`) for `IO` and `Either`.
public struct EitherIO<E, A> {
  public let run: IO<Either<E, A>>

  public init(run: IO<Either<E, A>>) {
    self.run = run
  }

  public func `catch`(_ f: @escaping (E) -> EitherIO) -> EitherIO {
    catchE(self, f)
  }

  public func mapExcept<F, B>(_ f: @escaping (Either<E, A>) -> Either<F, B>) -> EitherIO<F, B> {
    .init(
      run: self.run.map(f)
    )
  }

  public func withExcept<F>(_ f: @escaping (E) -> F) -> EitherIO<F, A> {
    self.bimap(f, id)
  }
}

public func lift<E, A>(_ x: Either<E, A>) -> EitherIO<E, A> {
  EitherIO.init <<< pure <| x
}

public func lift<E, A>(_ x: IO<A>) -> EitherIO<E, A> {
  EitherIO.init <<< map(Either.right) <| x
}

public func throwE<E, A>(_ x: E) -> EitherIO<E, A> {
  lift(.left(x))
}

public func catchE<E, A>(_ x: EitherIO<E, A>, _ f: @escaping (E) -> EitherIO<E, A>) -> EitherIO<E, A> {
  .init(
    run: x.run.flatMap(either(^\.run <<< f, pure <<< Either.right))
  )
}

public func mapExcept<E, F, A, B>(_ f: @escaping (Either<E, A>) -> Either<F, B>) -> (EitherIO<E, A>) -> EitherIO<F, B> {
  { $0.mapExcept(f) }
}

public func withExcept<E, F, A>(_ f: @escaping (E) -> F) -> (EitherIO<E, A>) -> EitherIO<F, A> {
  { $0.withExcept(f) }
}

extension EitherIO where E == Error {
  public static func wrap(_ f: @escaping () throws -> A) -> EitherIO {
    EitherIO.init <<< pure <| Either.wrap(f)
  }
}

extension EitherIO {
  public func retry(maxRetries: Int) -> EitherIO {
    retry(maxRetries: maxRetries, backoff: const(.seconds(0)))
  }

  public func retry(maxRetries: Int, backoff: @escaping (Int) -> DispatchTimeInterval) -> EitherIO {
    self.retry(maxRetries: maxRetries, attempts: 1, backoff: backoff)
  }

  private func retry(maxRetries: Int, attempts: Int, backoff: @escaping (Int) -> DispatchTimeInterval) -> EitherIO {

    guard attempts < maxRetries else { return self }

    return self <|> .init(run:
      self
        .retry(maxRetries: maxRetries, attempts: attempts + 1, backoff: backoff)
        .run
        .delay(backoff(attempts))
    )
  }

  public func delay(_ interval: DispatchTimeInterval) -> EitherIO {
    .init(run: self.run.delay(interval))
  }

  public func delay(_ interval: TimeInterval) -> EitherIO {
    .init(run: self.run.delay(interval))
  }
}

// MARK: - Functor

extension EitherIO {
  public func map<B>(_ f: @escaping (A) -> B) -> EitherIO<E, B> {
    .init(
      run: self.run.map { $0.map(f) }
    )
  }

  public static func <¢> <B>(f: @escaping (A) -> B, x: EitherIO) -> EitherIO<E, B> {
    x.map(f)
  }
}

public func map<E, A, B>(_ f: @escaping (A) -> B) -> (EitherIO<E, A>) -> EitherIO<E, B> {
  { f <¢> $0 }
}

// MARK: - Bifunctor

extension EitherIO {
  public func bimap<F, B>(_ f: @escaping (E) -> F, _ g: @escaping (A) -> B) -> EitherIO<F, B> {
    .init(run: self.run.map { $0.bimap(f, g) })
  }
}

public func bimap<E, F, A, B>(_ f: @escaping (E) -> F, _ g: @escaping (A) -> B)
  -> (EitherIO<E, A>)
  -> EitherIO<F, B> {
    { $0.bimap(f, g) }
}

// MARK: - Apply

extension EitherIO {
  public func apply<B>(_ f: EitherIO<E, (A) -> B>) -> EitherIO<E, B> {
    .init(run: curry(<*>) <¢> f.run <*> self.run)
  }

  public static func <*> <B>(f: EitherIO<E, (A) -> B>, x: EitherIO) -> EitherIO<E, B> {
    x.apply(f)
  }
}

public func apply<E, A, B>(_ f: EitherIO<E, (A) -> B>) -> (EitherIO<E, A>) -> EitherIO<E, B> {
  { f <*> $0 }
}

// MARK: - Applicative

public func pure<E, A>(_ x: (A)) -> EitherIO<E, A> {
  EitherIO.init <<< pure <<< pure <| x
}

// MARK: - Traversable

// Sequences an array of `EitherIO`'s by first sequencing the `IO` values, and then sequencing the `Either`
// values.
public func sequence<S, E, A>(
  _ xs: S
  )
  -> EitherIO<E, [A]>
  where S: Sequence, S.Element == EitherIO<E, A> {

    return EitherIO(run: sequence(xs.map(^\.run)).map(sequence))
}

// MARK: - Alt

extension EitherIO: Alt {
  public static func <|> (lhs: EitherIO, rhs: @autoclosure @escaping () -> EitherIO) -> EitherIO {
    .init(run: .init { lhs.run.perform() <|> rhs().run.perform() })
  }
}

// MARK: - Bind/Monad

extension EitherIO {
  public func flatMap<B>(_ f: @escaping (A) -> EitherIO<E, B>) -> EitherIO<E, B> {
    .init(
      run: self.run.flatMap(either(pure <<< Either.left, ^\.run <<< f))
    )
  }
}

public func flatMap<E, A, B>(_ f: @escaping (A) -> EitherIO<E, B>) -> (EitherIO<E, A>) -> EitherIO<E, B> {
  { $0.flatMap(f) }
}

public func >=> <E, A, B, C>(f: @escaping (A) -> EitherIO<E, B>, g: @escaping (B) -> EitherIO<E, C>) -> (A) -> EitherIO<E, C> {
  f >>> flatMap(g)
}
