public func optional<A, B>(_ default: @autoclosure @escaping () -> B) -> (@escaping (A) -> B) -> (A?) -> B {
  { a2b in
    { a in
      a.map(a2b) ?? `default`()
    }
  }
}

public func coalesce<A>(with default: @autoclosure @escaping () -> A) -> (A?) -> A {
  optional(`default`()) <| id
}


extension Optional {
  public func `do`(_ f: (Wrapped) -> Void) {
    if let x = self { f(x) }
  }
}

// MARK: - Functor

extension Optional {
  public static func <¢> <A>(f: (Wrapped) -> A, x: Optional) -> A? {
    x.map(f)
  }
}

public func map<A, B>(_ a2b: @escaping (A) -> B) -> (A?) -> B? {
  { a in
    a2b <¢> a
  }
}

// MARK: - Apply

extension Optional {
  public func apply<A>(_ f: ((Wrapped) -> A)?) -> A? {
    // return f.flatMap(self.map) // https://bugs.swift.org/browse/SR-5422
    guard let f = f, let a = self else { return nil }
    return f(a)
  }

  public static func <*> <A>(f: ((Wrapped) -> A)?, x: Optional) -> A? {
    x.apply(f)
  }
}

public func apply<A, B>(_ a2b: ((A) -> B)?) -> (A?) -> B? {
  { a in
    a2b <*> a
  }
}

// MARK: - Applicative

public func pure<A>(_ a: A) -> A? {
  .some(a)
}

// MARK: - Traversable

public func traverse<S, A, B>(
  _ f: @escaping (A) -> B?
  )
  -> (S)
  -> [B]?
  where S: Sequence, S.Element == A {

    return { xs in
      var ys: [B] = []
      for x in xs {
        guard let y = f(x) else { return nil }
        ys.append(y)
      }
      return ys
    }
}

public func sequence<A>(_ xs: [A?]) -> [A]? {
  xs |> traverse(id)
}

// MARK: - Bind/Monad

public func flatMap<A, B>(_ a2b: @escaping (A) -> B?) -> (A?) -> B? {
  { a in
    a.flatMap(a2b)
  }
}

public func >=> <A, B, C>(lhs: @escaping (A) -> B?, rhs: @escaping (B) -> C?) -> (A) -> C? {
  lhs >>> flatMap(rhs)
}

// MARK: - Semigroup

extension Optional: Semigroup where Wrapped: Semigroup {
  public static func <> (lhs: Optional, rhs: Optional) -> Optional {
    switch (lhs, rhs) {
    case (.none, _):
      return rhs
    case (_, .none):
      return lhs
    case let (.some(l), .some(r)):
      return .some(l <> r)
    }
  }
}

// MARK: - Monoid

extension Optional: Monoid where Wrapped: Semigroup {
  public static var empty: Optional {
    .none
  }
}

// MARK: - Foldable/Sequence

extension Optional {
  public func foldMap<M: Monoid>(_ f: @escaping (Wrapped) -> M) -> M {
    self.map(f) ?? M.empty
  }
}

public func foldMap<A, M: Monoid>(_ f: @escaping (A) -> M) -> (A?) -> M {
  { xs in
    xs.foldMap(f)
  }
}
