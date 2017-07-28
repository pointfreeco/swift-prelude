import Prelude

public typealias Getter<S, T, A, B> = Fold<A, S, T, A, B>

public func .^ <S, T, A, B>(s: S, f: Getter<S, T, A, B>) -> A {
  return f(Forget<A, A, B>(id)).unwrap(s)
}

public func getter<S, A>(_ keyPath: KeyPath<S, A>) -> Getter<S, S, A, A> {
  return { forget in
    .init { s in forget.unwrap(s[keyPath: keyPath]) }
  }
}
