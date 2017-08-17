public struct IO<A> {
  private let compute: () -> A

  public init(_ compute: @escaping () -> A) {
    self.compute = compute
  }

  public func perform() -> A {
    return self.compute()
  }
}

extension IO {
  public static func wrap<I>(_ f: @escaping (I) -> A) -> (I) -> IO<A> {
    return { input in
      .init { f(input) }
    }
  }

  // FIXME: can remove?
  public static func wrap(_ f: @escaping () -> A) -> () -> IO<A> {
    return {
      .init { f() }
    }
  }
}

// MARK: - Functor

extension IO {
  public func map<B>(_ a2b: @escaping (A) -> B) -> IO<B> {
    return IO<B> {
      self.perform() |> a2b
    }
  }

  public static func <¢> <B>(a2b: @escaping (A) -> B, a: IO<A>) -> IO<B> {
    return a.map(a2b)
  }
}

public func map<A, B>(_ a2b: @escaping (A) -> B) -> (IO<A>) -> IO<B> {
  return { a in
    a2b <¢> a
  }
}

// MARK: - Apply

extension IO {
  public func apply<B>(_ a2b: IO<(A) -> B>) -> IO<B> {
    return IO<B> {
      a2b.perform() <| self.perform()
    }
  }

  public static func <*> <B>(a2b: IO<(A) -> B>, a: IO<A>) -> IO<B> {
    return a.apply(a2b)
  }
}

public func apply<A, B>(_ a2b: IO<(A) -> B>) -> (IO<A>) -> IO<B> {
  return { a in
    a2b <*> a
  }
}

// MARK: - Applicative

public func pure<A>(_ a: A) -> IO<A> {
  return IO { a }
}

// MARK: - Bind/Monad

extension IO {
  public func flatMap<B>(_ a2b: @escaping (A) -> IO<B>) -> IO<B> {
    return IO<B> {
      a2b(self.perform()).perform()
    }
  }

  public static func >>- <B>(a: IO<A>, a2b: @escaping (A) -> IO<B>) -> IO<B> {
    return a.flatMap(a2b)
  }
}

public func flatMap<A, B>(_ a2b: @escaping (A) -> IO<B>) -> (IO<A>) -> IO<B> {
  return { a in
    a >>- a2b
  }
}

// MARK: - Semigroup

extension IO where A: Semigroup {
  public static func <> (lhs: IO, rhs: IO) -> IO {
    return curry(<>) <¢> lhs <*> rhs
  }
}
