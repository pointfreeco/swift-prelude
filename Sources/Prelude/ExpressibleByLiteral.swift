// MARK: - Applicative

public func pure<A: ExpressibleByArrayLiteral>(_ x: A.ArrayLiteralElement) -> A {
  return A(arrayLiteral: x)
}

public func pure<S: ExpressibleByStringLiteral>(_ x: S.StringLiteralType) -> S {
  return S(stringLiteral: x)
}

// MARK: - Plus

extension ExpressibleByArrayLiteral {
  public var empty: Self {
    return []
  }
}

extension ExpressibleByNilLiteral {
  public var empty: Self {
    return nil
  }
}

extension ExpressibleByStringLiteral {
  public var empty: Self {
    return ""
  }
}
