import Prelude

// MARK: - Getter

/// Produces a getter lens from a key path.
///
///     "Hello, world!" .^ getting(\.count) // 13
///
/// - Parameter keyPath: A key path.
/// - Returns: A getter from the root of the key path to its value.
public func getting<S, A>(_ keyPath: KeyPath<S, A>) -> Getter<S, S, A, A> {
  return { forget in
    .init(forget.unwrap <<< get(keyPath))
  }
}
