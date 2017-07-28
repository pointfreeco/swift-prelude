import Prelude

public typealias Setter<S, T, A, B> = (@escaping (A) -> B) -> (S) -> T

public func %~ <S, T, A, B>(l: Setter<S, T, A, B>, over: @escaping (A) -> B) -> (S) -> T {
  return l(over)
}

public func .~ <S, T, A, B>(l: Setter<S, T, A, B>, set: B) -> (S) -> T {
  return l %~ const(set)
}

