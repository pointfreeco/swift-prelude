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
