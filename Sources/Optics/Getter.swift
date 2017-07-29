import Prelude

infix operator .^: infixl8 // viewOn

public typealias Getter<S, T, A, B> = Fold<A, S, T, A, B>

public func view<S, T, A, B>(_ getter: @escaping Getter<S, T, A, B>) -> (S) -> A {
  return getter(.init(id)).unwrap
}

public func viewOn<S, T, A, B>(_ source: S) -> (@escaping Getter<S, T, A, B>) -> A {
  return { getter in
    view(getter) <| source
  }
}

public func .^ <S, T, A, B>(source: S, getter: @escaping Getter<S, T, A, B>) -> A {
  return viewOn(source) <| getter
}

public func to<R, S, T, A, B>(_ f: @escaping (S) -> A) -> Fold<R, S, T, A, B> {
  return { p in
    .init(p.unwrap <<< f)
  }
}
