import Prelude

infix operator .^: infixl8 // viewOn

public typealias Getter<S, T, A, B> = Fold<A, S, T, A, B>

public func .^ <S, T, A, B>(source: S, getter: Getter<S, T, A, B>) -> A {
  return getter(Forget<A, A, B>(id)).unwrap(source)
}
