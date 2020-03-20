import Prelude

public struct Tuple<A, B> {
  public var first: A
  public var second: B
}

public typealias T2<A, Z> = Tuple<A, Z>
public typealias T3<A, B, Z> = Tuple<A, T2<B, Z>>
public typealias T4<A, B, C, Z> = Tuple<A, T3<B, C, Z>>
public typealias T5<A, B, C, D, Z> = Tuple<A, T4<B, C, D, Z>>
public typealias T6<A, B, C, D, E, Z> = Tuple<A, T5<B, C, D, E, Z>>
public typealias T7<A, B, C, D, E, F, Z> = Tuple<A, T6<B, C, D, E, F, Z>>

public typealias Tuple1<A> = T2<A, Unit>
public typealias Tuple2<A, B> = T3<A, B, Unit>
public typealias Tuple3<A, B, C> = T4<A, B, C, Unit>
public typealias Tuple4<A, B, C, D> = T5<A, B, C, D, Unit>
public typealias Tuple5<A, B, C, D, E> = T6<A, B, C, D, E, Unit>
public typealias Tuple6<A, B, C, D, E, F> = T7<A, B, C, D, E, F, Unit>

infix operator .*.: infixr6

public func .*. <A, B> (lhs: A, rhs: B) -> T2<A, B> {
  .init(first: lhs, second: rhs)
}

public func get1<A, Z>(_ t: T2<A, Z>) -> A {
  t.first
}
public func get2<A, B, Z>(_ t: T3<A, B, Z>) -> B {
  t.second.first
}
public func get3<A, B, C, Z>(_ t: T4<A, B, C, Z>) -> C {
  t.second.second.first
}
public func get4<A, B, C, D, Z>(_ t: T5<A, B, C, D, Z>) -> D {
  t.second.second.second.first
}
public func get5<A, B, C, D, E, Z>(_ t: T6<A, B, C, D, E, Z>) -> E {
  t.second.second.second.second.first
}
public func get6<A, B, C, D, E, F, Z>(_ t: T7<A, B, C, D, E, F, Z>) -> F {
  t.second.second.second.second.second.first
}

public func rest<A, Z>(_ t: T2<A, Z>) -> Z {
  t.second
}
public func rest<A, B, Z>(_ t: T3<A, B, Z>) -> Z {
  t.second.second
}
public func rest<A, B, C, Z>(_ t: T4<A, B, C, Z>) -> Z {
  t.second.second.second
}
public func rest<A, B, C, D, Z>(_ t: T5<A, B, C, D, Z>) -> Z {
  t.second.second.second.second
}
public func rest<A, B, C, D, E, Z>(_ t: T6<A, B, C, D, E, Z>) -> Z {
  t.second.second.second.second.second
}
public func rest<A, B, C, D, E, F, Z>(_ t: T7<A, B, C, D, E, F, Z>) -> Z {
  t.second.second.second.second.second.second
}

public func over1<A, R, Z>(_ o: @escaping (A) -> R) -> (T2<A, Z>) -> T2<R, Z> {
  { t in o(t.first) .*. t.second }
}
public func over2<A, B, R, Z>(_ o: @escaping (B) -> R) -> (T3<A, B, Z>) -> T3<A, R, Z> {
  { t in get1(t) .*. o(get2(t)) .*. rest(t) }
}
public func over3<A, B, C, R, Z>(_ o: @escaping (C) -> R) -> (T4<A, B, C, Z>) -> T4<A, B, R, Z> {
  { t in get1(t) .*. get2(t) .*. o(get3(t)) .*. rest(t) }
}
public func over4<A, B, C, D, R, Z>(_ o: @escaping (D) -> R) -> (T5<A, B, C, D, Z>) -> T5<A, B, C, R, Z> {
  { t in get1(t) .*. get2(t) .*. get3(t) .*. o(get4(t)) .*. rest(t) }
}
public func over5<A, B, C, D, E, R, Z>(
  _ o: @escaping (E) -> R
  )
  -> (T6<A, B, C, D, E, Z>)
  -> T6<A, B, C, D, R, Z> {

    { t in get1(t) .*. get2(t) .*. get3(t) .*. get4(t) .*. o(get5(t)) .*. rest(t) }
}
public func over6<A, B, C, D, E, F, R, Z>(
  _ o: @escaping (F) -> R
  )
  -> (T7<A, B, C, D, E, F, Z>)
  -> T7<A, B, C, D, E, R, Z> {

    { t in get1(t) .*. get2(t) .*. get3(t) .*. get4(t) .*. get5(t) .*. o(get6(t)) .*. rest(t) }
}

public func lift<A>(_ a: A) -> Tuple1<A> {
  a .*. unit
}
public func lift<A, B>(_ tuple: (A, B)) -> Tuple2<A, B> {
  tuple.0 .*. tuple.1 .*. unit
}
public func lift<A, B, C>(_ tuple: (A, B, C)) -> Tuple3<A, B, C> {
  tuple.0 .*. tuple.1 .*. tuple.2 .*. unit
}
public func lift<A, B, C, D>(_ tuple: (A, B, C, D)) -> Tuple4<A, B, C, D> {
  tuple.0 .*. tuple.1 .*. tuple.2 .*. tuple.3 .*. unit
}
public func lift<A, B, C, D, E>(_ tuple: (A, B, C, D, E)) -> Tuple5<A, B, C, D, E> {
  tuple.0 .*. tuple.1 .*. tuple.2 .*. tuple.3 .*. tuple.4 .*. unit
}
public func lift<A, B, C, D, E, F>(_ tuple: (A, B, C, D, E, F)) -> Tuple6<A, B, C, D, E, F> {
  tuple.0 .*. tuple.1 .*. tuple.2 .*. tuple.3 .*. tuple.4 .*. tuple.5 .*. unit
}

public func lower<A>(_ tuple: Tuple1<A>) -> A {
  get1(tuple)
}
public func lower<A, B>(_ tuple: Tuple2<A, B>) -> (A, B) {
  return (tuple |> get1, tuple |> get2)
}
public func lower<A, B, C>(_ tuple: Tuple3<A, B, C>) -> (A, B, C) {
  return (tuple |> get1, tuple |> get2, tuple |> get3)
}
public func lower<A, B, C, D>(_ tuple: Tuple4<A, B, C, D>) -> (A, B, C, D) {
  return (tuple |> get1, tuple |> get2, tuple |> get3, tuple |> get4)
}
public func lower<A, B, C, D, E>(_ tuple: Tuple5<A, B, C, D, E>) -> (A, B, C, D, E) {
  return (tuple |> get1, tuple |> get2, tuple |> get3, tuple |> get4, tuple |> get5)
}
public func lower<A, B, C, D, E, F>(_ tuple: Tuple6<A, B, C, D, E, F>) -> (A, B, C, D, E, F) {
  return (tuple |> get1, tuple |> get2, tuple |> get3, tuple |> get4, tuple |> get5, tuple |> get6)
}

public func require1<A, Z>(_ x: T2<A?, Z>) -> T2<A, Z>? {
  get1(x).map { over1(const($0)) <| x }
}
public func require2<A, B, Z>(_ x: T3<A, B?, Z>) -> T3<A, B, Z>? {
  get2(x).map { over2(const($0)) <| x }
}
public func require3<A, B, C, Z>(_ x: T4<A, B, C?, Z>) -> T4<A, B, C, Z>? {
  get3(x).map { over3(const($0)) <| x }
}

extension Tuple: Equatable where A: Equatable, B: Equatable {
  public static func == (lhs: Tuple, rhs: Tuple) -> Bool {
    lhs.first == rhs.first && lhs.second == rhs.second
  }
}

extension Tuple: Comparable where A: Comparable, B: Comparable {
  public static func < (lhs: Tuple, rhs: Tuple) -> Bool {
    lhs.first < rhs.first && lhs.second < rhs.second
  }
}

extension Tuple: Semigroup where A: Semigroup, B: Semigroup {
  public static func <> (lhs: Tuple, rhs: Tuple) -> Tuple {
    Tuple(first: lhs.first <> rhs.first, second: lhs.second <> rhs.second)
  }
}

extension Tuple: Monoid where A: Monoid, B: Monoid {
  public static var empty: Tuple<A, B> {
    Tuple(first: A.empty, second: B.empty)
  }
}

extension Tuple: NearSemiring where A: NearSemiring, B: NearSemiring {
  public static func + (lhs: Tuple<A, B>, rhs: Tuple<A, B>) -> Tuple<A, B> {
    Tuple(first: lhs.first + rhs.first, second: lhs.second + rhs.second)
  }

  public static func * (lhs: Tuple<A, B>, rhs: Tuple<A, B>) -> Tuple<A, B> {
    Tuple(first: lhs.first * rhs.first, second: lhs.second * rhs.second)
  }

  public static var zero: Tuple<A, B> {
    Tuple(first: A.zero, second: B.zero)
  }
}

extension Tuple: Semiring where A: Semiring, B: Semiring {
  public static var one: Tuple<A, B> {
    Tuple(first: A.one, second: B.one)
  }
}

extension Tuple: Ring where A: Ring, B: Ring {
  public static func - (lhs: Tuple<A, B>, rhs: Tuple<A, B>) -> Tuple<A, B> {
    Tuple(first: lhs.first - rhs.first, second: lhs.second - rhs.second)
  }
}

extension Tuple: HeytingAlgebra where A: HeytingAlgebra, B: HeytingAlgebra {
  public static var ff: Tuple<A, B> {
    Tuple(first: A.ff, second: B.ff)
  }

  public static var tt: Tuple<A, B> {
    Tuple(first: A.tt, second: B.tt)
  }

  public static func implies(_ a: Tuple<A, B>, _ b: Tuple<A, B>) -> Tuple<A, B> {
    Tuple(first: A.implies(a.first, b.first), second: B.implies(a.second, b.second))
  }

  public static func && (lhs: Tuple<A, B>, rhs: @autoclosure () throws -> Tuple<A, B>) rethrows -> Tuple<A, B> {
    let rhs = try rhs()
    return Tuple(first: lhs.first && rhs.first, second: lhs.second && rhs.second)
  }

  public static func || (lhs: Tuple<A, B>, rhs: @autoclosure () throws -> Tuple<A, B>) rethrows -> Tuple<A, B> {
    let rhs = try rhs()
    return Tuple(first: lhs.first || rhs.first, second: lhs.second || rhs.second)
  }

  public static prefix func ! (not: Tuple<A, B>) -> Tuple<A, B> {
    Tuple(first: !not.first, second: !not.second)
  }
}
