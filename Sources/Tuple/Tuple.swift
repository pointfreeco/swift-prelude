import Prelude

public struct Tuple<A, B> {
  public let first: A
  public let second: B
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

public func .*. <A, B> (lhs: A, rhs: B) -> Tuple2<A, B> {
  return .init(first: lhs, second: Tuple1(first: rhs, second: unit))
}
public func .*. <A, B> (lhs: A, rhs: Tuple1<B>) -> Tuple2<A, B> {
  return .init(first: lhs, second: rhs)
}
public func .*. <A, B, C> (lhs: A, rhs: Tuple2<B, C>) -> Tuple3<A, B, C> {
  return .init(first: lhs, second: rhs)
}
public func .*. <A, B, C, D> (lhs: A, rhs: Tuple3<B, C, D>) -> Tuple4<A, B, C, D> {
  return .init(first: lhs, second: rhs)
}
public func .*. <A, B, C, D, E> (lhs: A, rhs: Tuple4<B, C, D, E>) -> Tuple5<A, B, C, D, E> {
  return .init(first: lhs, second: rhs)
}
public func .*. <A, B, C, D, E, F> (lhs: A, rhs: Tuple5<B, C, D, E, F>) -> Tuple6<A, B, C, D, E, F> {
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

public func over1<A, R, Z>(_ o: @escaping (A) -> R) -> (T2<A, Z>) -> T2<R, Z> {
  return { t in T2(first: o(t.first), second: t.second) }
}
public func over2<A, B, R, Z>(_ o: @escaping (B) -> R) -> (T3<A, B, Z>) -> T3<A, R, Z> {
  return { t in T3(first: t.first, second: T2(first: o(t.second.first), second: t.second.second)) }
}
public func over3<A, B, C, R, Z>(_ o: @escaping (C) -> R) -> (T4<A, B, C, Z>) -> T4<A, B, R, Z> {
  return { t in
    T4(
      first: t.first,
      second: T3(
        first: t.second.first,
        second: T2(
          first: o(t.second.second.first),
          second: t.second.second.second
        )
      )
    )
  }
}
public func over4<A, B, C, D, R, Z>(_ o: @escaping (D) -> R) -> (T5<A, B, C, D, Z>) -> T5<A, B, C, R, Z> {
  return { t in
    T5(
      first: t.first,
      second: T4(
        first: t.second.first,
        second: T3(
          first: t.second.second.first,
          second: T2(
            first: o(t.second.second.second.first),
            second: t.second.second.second.second
          )
        )
      )
    )
  }
}
public func over5<A, B, C, D, E, R, Z>(_ o: @escaping (E) -> R) -> (T6<A, B, C, D, E, Z>)
  -> T6<A, B, C, D, R, Z> {
    return { t in
      T6(
        first: t.first,
        second: T5(
          first: t.second.first,
          second: T4(
            first: t.second.second.first,
            second: T3(
              first: t.second.second.second.first,
              second: T2(
                first: o(t.second.second.second.second.first),
                second: t.second.second.second.second.second
              )
            )
          )
        )
      )
    }
}
public func over6<A, B, C, D, E, F, R, Z>(_ o: @escaping (F) -> R) -> (T7<A, B, C, D, E, F, Z>)
  -> T7<A, B, C, D, E, R, Z> {
    return { t in
      T7(
        first: t.first,
        second: T6(
          first: t.second.first,
          second: T5(
            first: t.second.second.first,
            second: T4(
              first: t.second.second.second.first,
              second: T3(
                first: t.second.second.second.second.first,
                second: T2(
                  first: o(t.second.second.second.second.second.first),
                  second: t.second.second.second.second.second.second
                )
              )
            )
          )
        )
      )
    }
}

public func == <A: Equatable, B: Equatable> (lhs: Tuple<A, B>, rhs: Tuple<A, B>) -> Bool {
  return lhs.first == rhs.first && lhs.second == rhs.second
}
public func == <A: Equatable, B: Equatable> (lhs: Tuple2<A, B>, rhs: Tuple2<A, B>) -> Bool {
  return lhs.first == rhs.first && lhs.second == rhs.second
}
public func == <A: Equatable, B: Equatable, C: Equatable> (
  lhs: Tuple3<A, B, C>,
  rhs: Tuple3<A, B, C>
  ) -> Bool {
  return lhs.first == rhs.first && lhs.second == rhs.second
}
public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable> (
  lhs: Tuple4<A, B, C, D>,
  rhs: Tuple4<A, B, C, D>
  ) -> Bool {
  return lhs.first == rhs.first && lhs.second == rhs.second
}
public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable> (
  lhs: Tuple5<A, B, C, D, E>,
  rhs: Tuple5<A, B, C, D, E>
  ) -> Bool {
  return lhs.first == rhs.first && lhs.second == rhs.second
}
public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable> (
  lhs: Tuple6<A, B, C, D, E, F>,
  rhs: Tuple6<A, B, C, D, E, F>
  ) -> Bool {
  return lhs.first == rhs.first && lhs.second == rhs.second
}

public func lift<A, B>(_ tuple: (A, B)) -> Tuple2<A, B> {
  return tuple.0 .*. tuple.1
}
public func lift<A, B, C>(_ tuple: (A, B, C)) -> Tuple3<A, B, C> {
  return tuple.0 .*. tuple.1 .*. tuple.2
}
public func lift<A, B, C, D>(_ tuple: (A, B, C, D)) -> Tuple4<A, B, C, D> {
  return tuple.0 .*. tuple.1 .*. tuple.2 .*. tuple.3
}
public func lift<A, B, C, D, E>(_ tuple: (A, B, C, D, E)) -> Tuple5<A, B, C, D, E> {
  return tuple.0 .*. tuple.1 .*. tuple.2 .*. tuple.3 .*. tuple.4
}
public func lift<A, B, C, D, E, F>(_ tuple: (A, B, C, D, E, F)) -> Tuple6<A, B, C, D, E, F> {
  return tuple.0 .*. tuple.1 .*. tuple.2 .*. tuple.3 .*. tuple.4 .*. tuple.5
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
