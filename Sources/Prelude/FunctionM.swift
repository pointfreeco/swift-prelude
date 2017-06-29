public struct FunctionM<A, M: Monoid>: FunctionProtocol {
  public typealias Source = A
  public typealias Target = M
  public let call: (A) -> M

  public init(_ call: @escaping (A) -> M) {
    self.call = call
  }
}

// MARK: - Semigroup

extension FunctionM: Semigroup {
  public static func <> (lhs: FunctionM, rhs: FunctionM) -> FunctionM {
    return FunctionM { props in
      lhs.call(props) <> rhs.call(props)
    }
  }
}

// MARK: - Monoid

extension FunctionM: Monoid {
  public static var e: FunctionM {
    return FunctionM(const(M.e))
  }
}
