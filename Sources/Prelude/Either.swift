public enum Either<L, R> {
  case left(L)
  case right(R)
}

extension Either {
  public var left: L? {
    switch self {
    case let .left(x):
      return x
    case .right:
      return nil
    }
  }

  public var right: R? {
    switch self {
    case .left:
      return nil
    case let .right(x):
      return x
    }
  }
}

public func rights<L, R>(_ xs: [Either<L, R>]) -> [R] {
  return xs.flatMap { $0.right } // bad flatmap
}
