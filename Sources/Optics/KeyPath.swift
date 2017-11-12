import Prelude

extension KeyPath {
  /// Composes two key paths together. An operator version of `appending`.
  ///
  /// - Parameters:
  ///   - lhs: The root key path.
  ///   - rhs: The key path to append.
  /// - Returns: A key path from the root of the left-hand key path to the value type of the right-hand path.
  public static func <<< <AppendedValue>(lhs: KeyPath, rhs: KeyPath<Value, AppendedValue>)
    -> KeyPath<Root, AppendedValue> {
      return lhs.appending(path: rhs)
  }
}

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

// (Overloads required to allow for shorthand key path syntax.)
extension KeyPath {
  public static func <<< <NextValue>(
    lhs: KeyPath,
    rhs: @escaping Getter<Value, Value, NextValue, NextValue>)
    -> Getter<Root, Root, NextValue, NextValue> {

      return getting(lhs) <<< rhs
  }

  public static func <<< <SuperRoot>(
    lhs: @escaping Getter<SuperRoot, SuperRoot, Root, Root>,
    rhs: KeyPath)
    -> Getter<SuperRoot, SuperRoot, Value, Value> {

      return lhs <<< getting(rhs)
  }

  public static func .^(root: Root, keyPath: KeyPath) -> Value {
    return root .^ getting(keyPath)
  }
}

// MARK: - Setter

func setting<S, A>(_ keyPath: WritableKeyPath<S, A>) -> Setter<S, S, A, A> {
  return over(keyPath)
}

// (Overloads required to allow for shorthand key path syntax.)
extension WritableKeyPath {
  public static func <<< <NextValue>(
    lhs: WritableKeyPath,
    rhs: @escaping Setter<Value, Value, NextValue, NextValue>)
    -> Setter<Root, Root, NextValue, NextValue> {

      return setting(lhs) <<< rhs
  }

  public static func <<< <PreviousRoot>(
    lhs: @escaping Setter<PreviousRoot, PreviousRoot, Root, Root>,
    rhs: WritableKeyPath)
    -> Setter<PreviousRoot, PreviousRoot, Value, Value> {

      return lhs <<< setting(rhs)
  }

  public static func %~(keyPath: WritableKeyPath, over: @escaping (Value) -> Value) -> (Root) -> Root {
    return setting(keyPath) %~ over
  }

  public static func .~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return setting(keyPath) .~ value
  }
}

extension WritableKeyPath where Value: NearSemiring {
  public static func +~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return setting(keyPath) +~ value
  }

  public static func *~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return setting(keyPath) *~ value
  }
}

extension WritableKeyPath where Value: Ring {
  public static func -~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return setting(keyPath) -~ value
  }
}

extension WritableKeyPath where Value: EuclideanRing {
  public static func /~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return setting(keyPath) /~ value
  }
}

extension WritableKeyPath where Value: HeytingAlgebra {
  public static func ||~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return setting(keyPath) ||~ value
  }

  public static func &&~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return setting(keyPath) &&~ value
  }
}

extension WritableKeyPath where Value: Semigroup {
  public static func <>~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return setting(keyPath) <>~ value
  }
}
