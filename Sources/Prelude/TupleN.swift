
public struct Tuple<A, B> {
  fileprivate let first: A
  fileprivate let second: B
}


public typealias T2<A, Z> = Tuple<A, Z>
public typealias T3<A, B, Z> = Tuple<A, T2<B, Z>>
public typealias T4<A, B, C, Z> = Tuple<A, T3<B, C, Z>>
public typealias T5<A, B, C, D, Z> = Tuple<A, T4<B, C, D, Z>>
public typealias T6<A, B, C, D, E, Z> = Tuple<A, T5<B, C, D, E, Z>>

public typealias Tuple1<A> = T2<A, Unit>
public typealias Tuple2<A, B> = T3<A, B, Unit>
public typealias Tuple3<A, B, C> = T4<A, B, C, Unit>
public typealias Tuple4<A, B, C, D> = T5<A, B, C, D, Unit>
public typealias Tuple5<A, B, C, D, E> = T6<A, B, C, D, E, Unit>

precedencegroup Tuple {
  associativity: right
}
infix operator .*.: Tuple

public func .*. <A, B> (lhs: A, rhs: B) -> Tuple2<A, B> {
  return Tuple2(first: lhs, second: Tuple1(first: rhs, second: unit))
}

public func .*. <A, B, C> (lhs: A, rhs: Tuple2<B, C>) -> Tuple3<A, B, C> {
  return Tuple3<A, B, C>(first: lhs, second: rhs)
}

public func .*. <A, B, C, D> (lhs: A, rhs: Tuple3<B, C, D>) -> Tuple4<A, B, C, D> {
  return Tuple4<A, B, C, D>(first: lhs, second: rhs)
}

public func get1<A, Z>(_ t: T2<A, Z>) -> A {
  return t.first
}
public func get2<A, B, Z>(_ t: T3<A, B, Z>) -> B {
  return t.second.first
}


//let x = 1 .*. "hello" .*. false
//
//
//get1(x)
//get2(x)

