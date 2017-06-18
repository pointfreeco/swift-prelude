public protocol OptionalProtocol {
  associatedtype WrappedType
  func toOptional() -> WrappedType?
}

extension Optional: OptionalProtocol {
  public func toOptional() -> Wrapped? {
    return self
  }
}

extension ImplicitlyUnwrappedOptional: OptionalProtocol {
  public func toOptional() -> Wrapped? {
    return self
  }
}

public func coalesce<A>(with `default`: A) -> (A?) -> A {
  return { x in x ?? `default` }
}
