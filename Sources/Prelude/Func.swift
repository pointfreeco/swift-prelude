public struct Func<A, B>: Function {
  public let call: (A) -> B

  public init(_ call: @escaping (A) -> B) {
    self.call = call
  }
}

public protocol Function {
  associatedtype A
  associatedtype B
  typealias Signature = (A) -> B
  var call: Signature { get }
  init(_ call: @escaping Signature)
}

extension Function {
  public func eraseToFunc() -> Func<A, B> {
    return Func(call)
  }
}

extension Function {
  public func callAsFunction(_ input: A) -> B {
    return call(input)
  }
}

extension Function where A == Void {
  public func callAsFunction() -> B {
    return call(())
  }
}

extension Function /* : Semigroupoid */ {
  public static func >>> <G: Function>(f: Self, g: G) -> Func<A, G.B> where G.A == B {
    return .init(f.call >>> g.call)
  }

  public static func <<< <F: Function>(f: F, g: Self) -> Func<A, F.B> where F.A == B {
    return .init(f.call <<< g.call)
  }
}

extension Function /* : Functor */ {
  public func map<C>(_ f: @escaping (B) -> C) -> Func<A, C> {
    return .init(self.call >>> f)
  }

  public static func <¢> <C>(f: @escaping (B) -> C, g: Self) -> Func<A, C> {
    return g.map(f)
  }
}

public func map<A, B, C, F: Function>(_ f: @escaping (B) -> C) -> (F) -> Func<A, C>
where F.A == A, F.B == B {
  return { $0.map(f) }
}

extension Function {
  public func contramap<Z>(_ f: @escaping (Z) -> A) -> Func<Z, B> {
    return .init(f >>> self.call)
  }
}

// Have to implement in on a Func type directly due to compilation error:
// - Member operator '>¢<' of protocol 'Function' must have at least one argument of type 'Self'
extension Func /* : Contravariant */ {
  public static func >¢< <A, B, C>(f: @escaping (B) -> A, g: Func<A, C>) -> Func<B, C> {
    return g.contramap(f)
  }
}

public func contramap<A, B, C, G: Function>(_ f: @escaping (B) -> A) -> (G) -> Func<B, C>
where G.A == A, G.B == C {
  return { $0.contramap(f) }
}

extension Function /* : Profunctor */ {
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

extension Function /* : Apply */ {
  public func apply<F: Function, G: Function, C>(_ f: F) -> Func<A, C>
  where F.A == A, F.B == G, G.A == B, G.B == C {
    return .init { a in f.call(a).call(self.call(a)) }
  }

  public static func <*> <F: Function, G: Function, C>(f: F, x: Self) -> Func<A, C>
  where F.A == A, F.B == G, G.A == B, G.B == C {
    return x.apply(f)
  }
}

public func apply<F: Function, G: Function, B, C>(_ f: F) -> (Func<F.A, B>) -> Func<F.A, C>
where F.B == G, G.A == B, G.B == C {
  return { $0.apply(f) }
}

// MARK: Applicative
extension Function {
  public static func pure(_ b: B) -> Self {
    .init(const(b))
  }
}

public func pure<A, B>(_ b: B) -> Func<A, B> {
  return .init(const(b))
}

extension Function /* : Monad */ {
  public func flatMap<F: Function>(_ f: @escaping (B) -> F) -> Func<A, F.B>
  where F.A == A {
    return .init { f(self.call($0)).call($0) }
  }
}

public func flatMap<F: Function, C>(_ f: @escaping (C) -> F) -> (Func<F.A, C>) -> Func<F.A, F.B> {
  return { $0.flatMap(f) }
}

extension Function where B: Semigroup {
  public static func <> (f: Self, g: Self) -> Self {
    return .init { f.call($0) <> g.call($0) }
  }
}

extension Func: Semigroup where B: Semigroup {}

extension Function where B: Monoid {
  public static var empty: Self {
    return .init(const(B.empty))
  }
}
  
extension Func: Monoid where B: Monoid {}

extension Function where B: NearSemiring {
  public static func + (f: Self, g: Self) -> Self {
    return .init { f.call($0) + g.call($0) }
  }

  public static func * (f: Self, g: Self) -> Self {
    return .init { f.call($0) * g.call($0) }
  }

  public static var zero: Self {
    return .init(const(B.zero))
  }
}

extension Func: NearSemiring where B: NearSemiring {}

extension Function where B: Semiring {
  public static var one: Self {
    return .init(const(B.one))
  }
}

extension Func: Semiring where B: Semiring {}
