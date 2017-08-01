import Prelude

public struct Forget<R, A, B> {
  public let unwrap: (A) -> R

  public init(_ unwrap: @escaping (A) -> R) {
    self.unwrap = unwrap
  }

  public func map<S>(_ f: @escaping (R) -> S) -> Forget<S, A, B> {
    return .init(self.unwrap >>> f)
  }

  public func cmap<C>(_ f: @escaping (C) -> A) -> Forget<R, C, B> {
    return .init(f >>> self.unwrap)
  }
}

public func map<R, S, A, B>(_ f: @escaping (R) -> S) -> (Forget<R, A, B>) -> Forget<S, A, B> {
  return { forget in forget.map(f) }
}

public func cmap<R, A, C, B>(_ f: @escaping (C) -> A) -> (Forget<R, A, B>) -> Forget<R, C, B> {
  return { forget in forget.cmap(f) }
}
