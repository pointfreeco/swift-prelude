import Prelude

public struct Tagged<A, B> {
  public let value: B
}

public typealias Review<S, T, A, B> = (Tagged<A, B>) -> Tagged<S, T>
