import Prelude

/// A setter lens.
public typealias Setter<S, T, A, B> = (@escaping (A) -> B) -> (S) -> T

public func lens<S, T, A, B>(_ to: @escaping (S) -> (A, (B) -> T)) -> Setter<S, T, A, B> {
  return { pab in to >>> first(pab) >>> { bf in bf.1(bf.0) } }
}

public func lens<S, T, A, B>(_ get: @escaping (S) -> A, _ set: @escaping (S, B) -> T) -> Setter<S, T, A, B> {
  return lens({ s in (get(s), { b in set(s, b) }) })
}

/// Maps a function over the focus of a setter.
///
/// - Parameters:
///   - setter: A setter.
///   - over: A transformation function from the focus of a setter to a new value.
/// - Returns: A function that takes a source and returns a target by mapping a function over the focus of a
///   setter.
public func over<S, T, A, B>(_ setter: Setter<S, T, A, B>, _ f: @escaping (A) -> B) -> (S) -> T {
  return setter(f)
}

/// Sets the focus of a setter to a constant value.
///
/// - Parameters:
///   - setter: A setter.
///   - set: A new value to replace the focus of a setter.
/// - Returns: A function that takes a source and returns a target by replacing the focus of a setter with the
///   given value.
public func set<S, T, A, B>(_ setter: Setter<S, T, A, B>, _ value: B) -> (S) -> T {
  return over(setter, const(value))
}
