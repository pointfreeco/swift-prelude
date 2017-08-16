import Prelude

extension KeyPath {
  public static func <<< <NextValue>(lhs: KeyPath, rhs: KeyPath<Value, NextValue>)
    -> KeyPath<Root, NextValue> {
      return lhs.appending(path: rhs)
  }
}

// MARK: - Getter

public func getting<S, A>(_ keyPath: KeyPath<S, A>) -> Getter<S, S, A, A> {
  return { forget in
    .init(forget.unwrap <<< get(keyPath))
  }
}

public func <<< <A, B, S, T, U, V>(
  _ lhs: @escaping Getter<U, V, S, T>,
  _ rhs: @escaping Getter<S, T, A, B>
  )
  ->
  Getter<U, V, A, B> {

  return { forget in
    .init(forget.unwrap <<< rhs(Forget(id)).unwrap <<< lhs(Forget(id)).unwrap)
  }
}

// (Overloads required to allow for shorthand key path syntax.)
extension KeyPath {
  public static func <<< <NextValue>(lhs: KeyPath, rhs: @escaping Getter<Value, Value, NextValue, NextValue>)
    -> Getter<Root, Root, NextValue, NextValue> {

      return getting(lhs) <<< rhs
  }

  public static func <<< <SuperRoot>(lhs: @escaping Getter<SuperRoot, SuperRoot, Root, Root>, rhs: KeyPath)
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
