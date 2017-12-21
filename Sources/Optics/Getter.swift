import Prelude

infix operator .^: infixl8 // viewOn

/// A getter lens.
public typealias Getter<S, T, A, B> = Fold<A, S, T, A, B>

// TODO: Add `first` to `Forget`.
//public func lens<S, T, A, B>(_ to: @escaping (S) -> (A, (B) -> T)) -> Getter<S, T, A, B> {
//  return { pab in to >>> first(pab) >>> { bf in bf.1(bf.0) } }
//}
//
//public func lens<S, T, A, B>(_ get: @escaping (S) -> A, _ set: @escaping (S, B) -> T) -> Getter<S, T, A, B> {
//  return lens({ s in (get(s), { b in set(s, b) }) })
//}

/// Composes two getters together.
///
///     (1, (2, 3)) .^ second <<< first // 2
///
/// - Parameters:
///   - lhs: The root getter.
///   - rhs: A getter with a source matching the target of the left-hand getter.
/// - Returns: A new getter from the source of the left-hand getter to the target of the right-hand getter.
public func <<< <A, B, S, T, U, V>(
  _ lhs: @escaping Getter<U, V, S, T>,
  _ rhs: @escaping Getter<S, T, A, B>)
  -> Getter<U, V, A, B> {

    return { forget in
      .init(forget.unwrap <<< rhs(Forget(id)).unwrap <<< lhs(Forget(id)).unwrap)
    }
}

/// Produces a getter function from a getter lens.
///
/// - Parameter getter: A getter.
/// - Returns: A function from the source of a getter to its focus.
public func view<S, T, A, B>(_ getter: @escaping Getter<S, T, A, B>) -> (S) -> A {
  return getter(.init(id)).unwrap
}

/// An operator version of `view`, flipped.
///
///     (1, 2) .^ second // 2
///
/// - Parameters:
///   - source: A source value.
///   - getter: A getter from a source to its focus.
/// - Returns: The focus of the source.
public func .^ <S, T, A, B>(source: S, getter: @escaping Getter<S, T, A, B>) -> A {
  return source |> view(getter)
}

/// Converts a function into a getter.
///
/// - Parameter f: A function from a source value to its focus.
/// - Returns: A getter.
public func to<R, S, T, A, B>(_ f: @escaping (S) -> A) -> Fold<R, S, T, A, B> {
  return { p in
    .init(p.unwrap <<< f)
  }
}
