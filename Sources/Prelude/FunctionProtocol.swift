public protocol FunctionProtocol {
  associatedtype Source
  associatedtype Target
  var call: (Source) -> Target { get }
  init(_ call: @escaping (Source) -> Target)
}

public struct Function<A, B>: FunctionProtocol {
  public typealias Source = A
  public typealias Target = B

  public let call: (A) -> B
  public init(_ call: @escaping (A) -> B) {
    self.call = call
  }
}

// MARK: - Functor

extension FunctionProtocol {
  public func map<B, F: FunctionProtocol>(
    _ f: @escaping (Target) -> B
    )
    -> F
    where F.Source == Source, F.Target == B {

      return .init(self.call >>> f)
  }

  public static func <¢> <C, G: FunctionProtocol>(
    f: @escaping (Target) -> C,
    g: Self
    )
    -> G
    where G.Source == Source, G.Target == C {

      return g.map(f)
  }
}

public func map<A, B, C, F: FunctionProtocol, G: FunctionProtocol>(
  _ f: @escaping (B) -> C
  )
  -> (F)
  -> (G)
  where F.Source == A, F.Target == B, G.Source == A, G.Target == C {

    return { g in g.map(f) }
}

// MARK: - Contravariant Functor

extension FunctionProtocol {
  public func contramap<C, G: FunctionProtocol>(
    _ f: @escaping (C) -> Source
    )
    -> G
    where G.Source == C, G.Target == Target {

      return .init(f >>> self.call)
  }

  public static func >¢< <C, G: FunctionProtocol>(
    f: @escaping (C) -> Source
    , g: Self
    )
    -> G
    where G.Source == C, G.Target == Target {
      return g.contramap(f)
  }
}

public func contramap<A, B, C, F: FunctionProtocol, G: FunctionProtocol>(
  _ f: @escaping (C) -> A
  )
  -> (F)
  -> G
  where F.Source == A, F.Target == B, G.Source == C, G.Target == B {
    return { g in g.contramap(f) }
}

// MARK: - Apply

extension FunctionProtocol {
  public func ap<C, F: FunctionProtocol, G: FunctionProtocol>(_ f: F) -> G
    where F.Source == Source,
    F.Target: FunctionProtocol,
    F.Target.Source == Target,
    F.Target.Target == C,
    G.Source == Source,
    G.Target == C {

      return .init { a in f.call(a).call(self.call(a)) }
  }

  public static func <*><C, F: FunctionProtocol, G: FunctionProtocol>(f: F, x: Self) -> G
    where F.Source == Source,
    F.Target: FunctionProtocol,
    F.Target.Source == Target,
    F.Target.Target == C,
    G.Source == Source,
    G.Target == C {

      return x.ap(f)
  }
}

// MARK: - Applicative

public func pure<A, B, F: FunctionProtocol>(_ b: B) -> F
  where F.Source == A, F.Target == B {
    return .init(const(b))
}

// MARK: - Monad

extension FunctionProtocol {
  public func flatMap<C, F: FunctionProtocol>(_ f: @escaping (Target) -> F) -> F
    where F.Source == Source, F.Target == C {
      return .init { a in f(self.call(a)).call(a) }
  }

  public static func >>- <C, F: FunctionProtocol>(x: Self, f: @escaping (Target) -> F) -> F
    where F.Source == Source, F.Target == C {

      return x.flatMap(f)
  }
}

public func >>> <A, B, C, F: FunctionProtocol, G: FunctionProtocol, H: FunctionProtocol>(f: F, g: G) -> H
  where F.Source == A, F.Target == B, G.Source == B, G.Target == C, H.Source == A, H.Target == C {
    return .init(f.call >>> g.call)
}

public func |> <A, B, F: FunctionProtocol> (a: A, f: F) -> B
  where F.Source == A, F.Target == B {
    return f.call(a)
}
