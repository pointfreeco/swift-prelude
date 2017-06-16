precedencegroup HashRocket {
  associativity: left
  higherThan: Semigroup
}
infix operator =>: HashRocket

precedencegroup Alt {
  associativity: left
}

precedencegroup Apply {
  higherThan: Alt
  associativity: left
}

precedencegroup Functor {
  higherThan: Apply
  associativity: left
}

precedencegroup FunctionApplication {
  associativity: left
  higherThan: Semigroup
}

precedencegroup FunctionApplicationFlipped {
  associativity: left
  higherThan: FunctionApplication
}

precedencegroup Semigroup {
  associativity: right
  higherThan: AdditionPrecedence
}

precedencegroup FunctionComposition {
  associativity: right
}

precedencegroup MonadicBind {
  associativity: right
}


infix operator <<<: FunctionComposition
infix operator >>>: FunctionComposition
infix operator <|: FunctionApplication
infix operator |>: FunctionApplicationFlipped
infix operator <|>: Alt
infix operator <*>: Apply
infix operator <*: Apply
infix operator *>: Apply

infix operator <¢>: Functor
infix operator <¢: Functor

infix operator <>: Semigroup
prefix operator <>
postfix operator <>

infix operator >>-: MonadicBind

// MARK: - Function

public func id<A>(_ a: A) -> A {
  return a
}

public func <<< <A, B, C>(_ b2c: @escaping (B) -> C, _ a2b: @escaping (A) -> B) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

public func >>> <A, B, C>(_ a2b: @escaping (A) -> B, _ b2c: @escaping (B) -> C) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

public func const<A, B>(_ a: A) -> (B) -> A {
  return { _ in a }
}

public func <| <A, B> (f: (A) -> B, a: A) -> B {
  return f(a)
}

public func |> <A, B> (a: A, f: (A) -> B) -> B {
  return f(a)
}

// MARK: - Array

public func uncons<A>(_ xs: [A]) -> (A, [A])? {
  guard let x = xs.first else { return nil }
  return (x, Array(xs.dropFirst()))
}

public func <¢> <A, B> (f: (A) -> B, xs: [A]) -> [B] {
  return xs.map(f)
}

public func <*> <A, B> (fs: [(A) -> B], xs: [A]) -> [B] {
  return fs.flatMap { f in xs.map(f) }
}

public func foldMap<A, M: Monoid>(_ f: @escaping (A) -> M) -> ([A]) -> M {
  return { xs in
    xs.reduce(M.e) { accum, x in accum <> f(x) }
  }
}

// MARK: Semigroup

public protocol Semigroup {
  static func <>(_: Self, _: Self) -> Self
}

public prefix func <><S: Semigroup>(rhs: S) -> (S) -> S {
  return { lhs in lhs <> rhs }
}

public postfix func <><S: Semigroup>(lhs: S) -> (S) -> S {
  return { rhs in lhs <> rhs }
}

public func concat<S: Semigroup>(_ xs: [S], _ e: S) -> S {
  return xs.reduce(e, <>)
}

// MARK: Monoid

public protocol Monoid: Semigroup {
  static var e: Self { get }
}

public func concat<M: Monoid>(_ xs: [M]) -> M {
  return xs.reduce(M.e, <>)
}

extension String: Monoid {
  public static let e = ""

  public static func <>(lhs: String, rhs: String) -> String {
    return lhs + rhs
  }
}

extension Array: Monoid {
  public static var e: Array { return [] }

  public static func <>(lhs: Array, rhs: Array) -> Array {
    return lhs + rhs
  }
}

public func joined<M: Monoid>(_ s: M) -> ([M]) -> M {
  return { xs in
    if let head = xs.first {
      return xs.dropFirst().reduce(head) { accum, x in accum <> s <> x }
    }
    return .e
  }
}

// MARK: Tuple

public func first<A, B>(_ x: (A, B)) -> A {
  return x.0
}

public func second<A, B>(_ x: (A, B)) -> B {
  return x.1
}

// MARK: Arrow

public func first<B, C, D>(_ f: @escaping (B) -> C) -> ((B, D)) -> (C, D) {
  return { bd in (f(bd.0), bd.1) }
}

public func second<B, C, D>(_ f: @escaping (B) -> C) -> ((D, B)) -> (D, C) {
  return { bd in (bd.0, f(bd.1)) }
}

// MARK: Array

public func partition<A>(_ p: @escaping (A) -> Bool) -> ([A]) -> ([A], [A]) {
  return { xs in
    xs.reduce(([], [])) { accum, x in
      p(x) ? (accum.0 + [x], accum.1) : (accum.0, accum.1 + [x])
    }
  }
}

public func elem<A: Equatable>(_ x: A) -> ([A]) -> Bool {
  return { xs in xs.contains(x) }
}

public func elem<A: Equatable>(of xs: [A]) -> (A) -> Bool {
  return { x in xs.contains(x) }
}

public func zipWith<A, B, C>(_ f: @escaping (A, B) -> C) -> ([A]) -> ([B]) -> [C] {
  return { xs in
    return { ys in
      return zip(xs, ys).map { f($0.0, $0.1) }
    }
  }
}

public func sorted<A>(by f: @escaping (A, A) -> Bool) -> ([A]) -> [A] {
  return { xs in
    xs.sorted(by: f)
  }
}

public func lookup<A: Equatable, B>(_ x: A) -> ([(A, B)]) -> B? {
  return { pairs in
    pairs.first { pair in pair.0 == x }.map(second)
  }
}

// MARK: Optional

public func coalesce<A>(with `default`: A) -> (A?) -> A {
  return { x in x ?? `default` }
}

// Mark: Unit

public struct Unit {}
public let unit = Unit()

// Mark: String

public func characterCount(_ str: String) -> Int {
  return str.characters.count
}

// Mark: Either

public enum Either<A, B> {
  case left(A)
  case right(B)

  public var left: A? {
    switch self {
    case let .left(x):
      return x
    case .right:
      return nil
    }
  }

  public var right: B? {
    switch self {
    case .left:
      return nil
    case let .right(x):
      return x
    }
  }
}

public func rights<A, B>(_ xs: [Either<A, B>]) -> [B] {
  return xs.flatMap { $0.right } // bad flatmap
}

// Mark: Functions

public func replicate<A>(_ n: Int) -> (A) -> [A] {
  return { a in (1...n).map(const(a)) }
}

public func replicate(_ n: Int) -> (String) -> String {
  return { str in (1...n).map(const(str)).joined() }
}


