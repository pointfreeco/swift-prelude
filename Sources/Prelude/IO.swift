import Dispatch
import Foundation

public struct IO<A> {
  private let compute: () -> A

  public init(_ compute: @escaping () -> A) {
    self.compute = compute
  }

  public func perform() -> A {
    self.compute()
  }
}

public func perform<A>(_ io: IO<A>) -> A {
  io.perform()
}

extension IO {
  public static func wrap<I>(_ f: @escaping (I) -> A) -> (I) -> IO<A> {
    { input in
      .init { f(input) }
    }
  }
}

extension IO {
  public init(_ callback: @escaping (@escaping (A) -> ()) -> ()) {
    self.init {
      var computed: A?
      let semaphore = DispatchSemaphore(value: 0)
      callback {
        computed = $0
        semaphore.signal()
      }
      semaphore.wait()
      return computed!
    }
  }

  public func delay(_ interval: DispatchTimeInterval) -> IO {
    .init { callback in
      DispatchQueue.global().asyncAfter(deadline: .now() + interval) {
        callback(self.perform())
      }
    }
  }

  public func delay(_ interval: TimeInterval) -> IO {
    .init { callback in
      DispatchQueue.global().asyncAfter(deadline: .now() + interval) {
        callback(self.perform())
      }
    }
  }
}

public func delay<A>(_ interval: DispatchTimeInterval) -> (IO<A>) -> IO<A> {
  { $0.delay(interval) }
}

public func delay<A>(_ interval: TimeInterval) -> (IO<A>) -> IO<A> {
  { $0.delay(interval) }
}

extension IO {
  public var parallel: Parallel<A> {
    Parallel { callback in
      callback(self.perform())
    }
  }
}

// MARK: - Functor

extension IO {
  public func map<B>(_ f: @escaping (A) -> B) -> IO<B> {
    IO<B> {
      self.perform() |> f
    }
  }

  public static func <¢> <B>(f: @escaping (A) -> B, x: IO<A>) -> IO<B> {
    x.map(f)
  }
}

public func map<A, B>(_ f: @escaping (A) -> B) -> (IO<A>) -> IO<B> {
  { f <¢> $0 }
}

// MARK: - Apply

extension IO {
  public func apply<B>(_ f: IO<(A) -> B>) -> IO<B> {
    IO<B> {
      f.perform() <| self.perform()
    }
  }

  public static func <*> <B>(f: IO<(A) -> B>, x: IO<A>) -> IO<B> {
    x.apply(f)
  }
}

public func apply<A, B>(_ f: IO<(A) -> B>) -> (IO<A>) -> IO<B> {
  { f <*> $0 }
}

// MARK: - Applicative

public func pure<A>(_ a: A) -> IO<A> {
  IO { a }
}

// MARK: - Traversable

public func traverse<S, A, B>(
  _ f: @escaping (A) -> IO<B>
  )
  -> (S)
  -> IO<[B]>
  where S: Sequence, S.Element == A {

    return { xs in
      IO<[B]> {
        xs.map { f($0).perform() }
      }
    }
}

public func sequence<S, A>(
  _ xs: S
  )
  -> IO<[A]>
  where S: Sequence, S.Element == IO<A> {

    return xs |> traverse(id)
}

// MARK: - Bind/Monad

extension IO {
  public func flatMap<B>(_ f: @escaping (A) -> IO<B>) -> IO<B> {
    IO<B> {
      f(self.perform()).perform()
    }
  }
}

public func flatMap<A, B>(_ f: @escaping (A) -> IO<B>) -> (IO<A>) -> IO<B> {
  { $0.flatMap(f) }
}

public func >=> <A, B, C>(lhs: @escaping (A) -> IO<B>, rhs: @escaping (B) -> IO<C>) -> (A) -> IO<C> {
  lhs >>> flatMap(rhs)
}

// MARK: - Semigroup

extension IO: Semigroup where A: Semigroup {
  public static func <> (lhs: IO, rhs: IO) -> IO {
    curry(<>) <¢> lhs <*> rhs
  }
}

// MARK: - Monoid

extension IO: Monoid where A: Monoid {
  public static var empty: IO {
    pure(A.empty)
  }
}
