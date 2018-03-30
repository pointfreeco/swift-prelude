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
  return .init(first: lhs, second: rhs)
}

public func get1<A, Z>(_ t: T2<A, Z>) -> A {
  return t.first
}
public func get2<A, B, Z>(_ t: T3<A, B, Z>) -> B {
  return t.second.first
}
public func get3<A, B, C, Z>(_ t: T4<A, B, C, Z>) -> C {
  return t.second.second.first
}
public func get4<A, B, C, D, Z>(_ t: T5<A, B, C, D, Z>) -> D {
  return t.second.second.second.first
}
public func get5<A, B, C, D, E, Z>(_ t: T6<A, B, C, D, E, Z>) -> E {
  return t.second.second.second.second.first
}
public func get6<A, B, C, D, E, F, Z>(_ t: T7<A, B, C, D, E, F, Z>) -> F {
  return t.second.second.second.second.second.first
}

public func rest<A, Z>(_ t: T2<A, Z>) -> Z {
  return t.second
}
public func rest<A, B, Z>(_ t: T3<A, B, Z>) -> Z {
  return t.second.second
}
public func rest<A, B, C, Z>(_ t: T4<A, B, C, Z>) -> Z {
  return t.second.second.second
}
public func rest<A, B, C, D, Z>(_ t: T5<A, B, C, D, Z>) -> Z {
  return t.second.second.second.second
}
public func rest<A, B, C, D, E, Z>(_ t: T6<A, B, C, D, E, Z>) -> Z {
  return t.second.second.second.second.second
}
public func rest<A, B, C, D, E, F, Z>(_ t: T7<A, B, C, D, E, F, Z>) -> Z {
  return t.second.second.second.second.second.second
}

public func over1<A, R, Z>(_ o: @escaping (A) -> R) -> (T2<A, Z>) -> T2<R, Z> {
  return { t in o(t.first) .*. t.second }
}
public func over2<A, B, R, Z>(_ o: @escaping (B) -> R) -> (T3<A, B, Z>) -> T3<A, R, Z> {
  return { t in get1(t) .*. o(get2(t)) .*. rest(t) }
}
public func over3<A, B, C, R, Z>(_ o: @escaping (C) -> R) -> (T4<A, B, C, Z>) -> T4<A, B, R, Z> {
  return { t in get1(t) .*. get2(t) .*. o(get3(t)) .*. rest(t) }
}
public func over4<A, B, C, D, R, Z>(_ o: @escaping (D) -> R) -> (T5<A, B, C, D, Z>) -> T5<A, B, C, R, Z> {
  return { t in get1(t) .*. get2(t) .*. get3(t) .*. o(get4(t)) .*. rest(t) }
}
public func over5<A, B, C, D, E, R, Z>(
  _ o: @escaping (E) -> R
  )
  -> (T6<A, B, C, D, E, Z>)
  -> T6<A, B, C, D, R, Z> {

    return { t in get1(t) .*. get2(t) .*. get3(t) .*. get4(t) .*. o(get5(t)) .*. rest(t) }
}
public func over6<A, B, C, D, E, F, R, Z>(
  _ o: @escaping (F) -> R
  )
  -> (T7<A, B, C, D, E, F, Z>)
  -> T7<A, B, C, D, E, R, Z> {

    return { t in get1(t) .*. get2(t) .*. get3(t) .*. get4(t) .*. get5(t) .*. o(get6(t)) .*. rest(t) }
}

public func lift<A>(_ a: A) -> Tuple1<A> {
  return a .*. unit
}
public func lift<A, B>(_ tuple: (A, B)) -> Tuple2<A, B> {
  return tuple.0 .*. tuple.1 .*. unit
}
public func lift<A, B, C>(_ tuple: (A, B, C)) -> Tuple3<A, B, C> {
  return tuple.0 .*. tuple.1 .*. tuple.2 .*. unit
}
public func lift<A, B, C, D>(_ tuple: (A, B, C, D)) -> Tuple4<A, B, C, D> {
  return tuple.0 .*. tuple.1 .*. tuple.2 .*. tuple.3 .*. unit
}
public func lift<A, B, C, D, E>(_ tuple: (A, B, C, D, E)) -> Tuple5<A, B, C, D, E> {
  return tuple.0 .*. tuple.1 .*. tuple.2 .*. tuple.3 .*. tuple.4 .*. unit
}
public func lift<A, B, C, D, E, F>(_ tuple: (A, B, C, D, E, F)) -> Tuple6<A, B, C, D, E, F> {
  return tuple.0 .*. tuple.1 .*. tuple.2 .*. tuple.3 .*. tuple.4 .*. tuple.5 .*. unit
}

public func lower<A>(_ tuple: Tuple1<A>) -> A {
  return get1(tuple)
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
  return get1(x).map { over1(const($0)) <| x }
}
public func require2<A, B, Z>(_ x: T3<A, B?, Z>) -> T3<A, B, Z>? {
  return get2(x).map { over2(const($0)) <| x }
}
public func require3<A, B, C, Z>(_ x: T4<A, B, C?, Z>) -> T4<A, B, C, Z>? {
  return get3(x).map { over3(const($0)) <| x }
}

extension Tuple: Equatable where A: Equatable, B: Equatable {
  public static func == (lhs: Tuple, rhs: Tuple) -> Bool {
    return lhs.first == rhs.first && lhs.second == rhs.second
  }
}

extension Tuple: Comparable where A: Comparable, B: Comparable {
  public static func < (lhs: Tuple, rhs: Tuple) -> Bool {
    return lhs.first < rhs.first && lhs.second < rhs.second
  }
}
