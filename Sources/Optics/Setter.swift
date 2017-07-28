import Prelude

infix operator %~: infixr4 // over
infix operator .~: infixr4 // set
infix operator +~: infixr4 // addOver
infix operator -~: infixr4 // subOver
infix operator *~: infixr4 // mulOver
infix operator /~: infixr4 // divOver
infix operator ||~: infixr4 // disjOver
infix operator &&~: infixr4 // conjOver
infix operator <>~: infixr4 // appendOver

public typealias Setter<S, T, A, B> = (@escaping (A) -> B) -> (S) -> T

//public func lens<S, T, A, B>(_ to: @escaping (S) -> (A, (B) -> T)) -> Setter<S, T, A, B> {
//  return { pab in to >>> first(pab) >>> { bf in bf.1(bf.0) } }
//}
//
//public func lens<S, T, A, B>(_ get: @escaping (S) -> A, _ set: @escaping (S, B) -> T) -> Setter<S, T, A, B> {
//  return lens({ s in (get(s), { b in set(s, b) }) })
//}

public func %~ <S, T, A, B>(setter: Setter<S, T, A, B>, over: @escaping (A) -> B) -> (S) -> T {
  return setter(over)
}

public func .~ <S, T, A, B>(setter: Setter<S, T, A, B>, set: B) -> (S) -> T {
  return setter %~ const(set)
}

public func +~ <S, T, A: NearSemiring>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  return setter %~ { $0 + value }
}

public func *~ <S, T, A: NearSemiring>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  return setter %~ { $0 * value }
}

public func -~ <S, T, A: Ring>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  return setter %~ { $0 - value }
}

public func /~ <S, T, A: EuclideanRing>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  return setter %~ { $0 / value }
}

public func ||~ <S, T, A: HeytingAlgebra>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  return setter %~ { try! $0 || value }
}

public func &&~ <S, T, A: HeytingAlgebra>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  return setter %~ { try! $0 && value }
}

public func <>~ <S, T, A: Semigroup>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  return setter %~ { $0 <> value }
}
