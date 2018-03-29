
public struct Func<A, B> {
  public let call: (A) -> B

  public init(_ call: @escaping (A) -> B) {
    self.call = call
  }
}

extension Func /* : Semigroupoid */ {
  public static func >>> <C>(f: Func, g: Func<B, C>) -> Func<A, C> {
    return .init(f.call >>> g.call)
  }

  public static func <<< <C>(f: Func<B, C>, g: Func) -> Func<A, C> {
    return .init(f.call <<< g.call)
  }
}

extension Func /* : Functor */ {
  public func map<C>(_ f: @escaping (B) -> C) -> Func<A, C> {
    return .init(self.call >>> f)
  }

  public static func <¢> <C>(f: @escaping (B) -> C, g: Func) -> Func<A, C> {
    return g.map(f)
  }
}

public func map<A, B, C>(_ f: @escaping (B) -> C) -> (Func<A, B>) -> Func<A, C> {
  return { $0.map(f) }
}

extension Func /* : Contravariant */ {
  public func contramap<Z>(_ f: @escaping (Z) -> A) -> Func<Z, B> {
    return .init(f >>> self.call)
  }

  public static func >¢< <A, B, C>(f: @escaping (B) -> A, g: Func<A, C>) -> Func<B, C> {
    return g.contramap(f)
  }
}

public func contramap<A, B, C>(_ f: @escaping (B) -> A) -> (Func<A, C>) -> Func<B, C> {
  return { $0.contramap(f) }
}

extension Func /* : Profunctor */ {
  public func dimap<Z, C>(_ f: @escaping (Z) -> A, _ g: @escaping (B) -> C) -> Func<Z, C> {
    return .init(f >>> self.call >>> g)
  }
}

public func dimap<A, B, C, D>(
  _ f: @escaping (A) -> B,
  _ g: @escaping (C) -> D
  )
  -> (Func<B, C>)
  -> Func<A, D> {

    return { $0.dimap(f, g) }
}

extension Func /* : Apply */ {
  public func apply<C>(_ f: Func<A, Func<B, C>>) -> Func<A, C> {
    return .init { a in f.call(a).call(self.call(a)) }
  }

  public static func <*> <C>(f: Func<A, Func<B, C>>, x: Func) -> Func<A, C> {
    return x.apply(f)
  }
}

public func apply<A, B, C>(_ f: Func<A, Func<B, C>>) -> (Func<A, B>) -> Func<A, C> {
  return { $0.apply(f) }
}

// MARK: Applicative
public func pure<A, B>(_ b: B) -> Func<A, B> {
  return .init(const(b))
}

extension Func /* : Monad */ {
  public func flatMap<C>(_ f: @escaping (B) -> Func<A, C>) -> Func<A, C> {
    return .init { f(self.call($0)).call($0) }
  }

  public static func >>- <C>(f: @escaping (B) -> Func<A, C>, g: Func<A, B>) -> Func<A, C> {
    return g.flatMap(f)
  }
}

public func flatMap<A, B, C>(_ f: @escaping (B) -> Func<A, C>) -> (Func<A, B>) -> Func<A, C> {
  return { $0.flatMap(f) }
}

extension Func: Semigroup where B: Semigroup {
  public static func <> (f: Func, g: Func) -> Func {
    return .init { f.call($0) <> g.call($0) }
  }
}

extension Func: Monoid where B: Monoid {
  public static var empty: Func {
    return .init(const(B.empty))
  }
}

extension Func: NearSemiring where B: NearSemiring {
  public static func + (f: Func, g: Func) -> Func {
    return .init { f.call($0) + g.call($0) }
  }

  public static func * (f: Func, g: Func) -> Func {
    return .init { f.call($0) * g.call($0) }
  }

  public static var zero: Func {
    return .init(const(B.zero))
  }
}

extension Func: Semiring where B: Semiring {
  public static var one: Func {
    return .init(const(B.one))
  }
}
