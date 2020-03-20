import Prelude

infix operator %~: infixr4 // over
infix operator .~: infixr4 // set
infix operator +~: infixr4 // addOver
infix operator -~: infixr4 // subOver
infix operator *~: infixr4 // mulOver
infix operator /~: infixr4 // divOver
infix operator ||~: infixr4 // disjOver
infix operator &&~: infixr4 // conjOver
infix operator <>~: infixr4 // appendOver

/// A setter lens.
public typealias Setter<S, T, A, B> = (@escaping (A) -> B) -> (S) -> T

public func lens<S, T, A, B>(_ to: @escaping (S) -> (A, (B) -> T)) -> Setter<S, T, A, B> {
  { pab in to >>> first(pab) >>> { bf in bf.1(bf.0) } }
}

public func lens<S, T, A, B>(_ get: @escaping (S) -> A, _ set: @escaping (S, B) -> T) -> Setter<S, T, A, B> {
  lens({ s in (get(s), { b in set(s, b) }) })
}

/// Maps a function over the focus of a setter.
///
/// - Parameters:
///   - setter: A setter.
///   - over: A transformation function from the focus of a setter to a new value.
/// - Returns: A function that takes a source and returns a target by mapping a function over the focus of a
///   setter.
public func %~ <S, T, A, B>(setter: Setter<S, T, A, B>, over: @escaping (A) -> B) -> (S) -> T {
  setter(over)
}

/// Sets the focus of a setter to a constant value.
///
/// - Parameters:
///   - setter: A setter.
///   - set: A new value to replace the focus of a setter.
/// - Returns: A function that takes a source and returns a target by replacing the focus of a setter with the
///   given value.
public func .~ <S, T, A, B>(setter: Setter<S, T, A, B>, set: B) -> (S) -> T {
  setter %~ const(set)
}

/// Adds a value to the focus of a setter.
///
/// - Parameters:
///   - setter: A setter with a near-semiring focus.
///   - value: A value added to the focus of a setter.
/// - Returns: A function that takes a source and returns a target by adding a value to the focus of a setter.
public func +~ <S, T, A: NearSemiring>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  setter %~ { $0 + value }
}

/// Multiplies the focus of a setter.
///
/// - Parameters:
///   - setter: A setter with a near-semiring focus.
///   - value: A value the focus of a setter is multiplied by.
/// - Returns: A function that takes a source and returns a target by multiplying the focus of a setter with
///   the given value.
public func *~ <S, T, A: NearSemiring>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  setter %~ { $0 * value }
}

/// Subtracts from the focus of a setter.
///
/// - Parameters:
///   - setter: A setter with a ring focus.
///   - value: A value subtracted from the focus of a setter.
/// - Returns: A function that takes a source and returns a target by subtracting a value from the focus of a
///   setter.
public func -~ <S, T, A: Ring>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  setter %~ { $0 - value }
}

/// Divides the focus of a setter.
///
/// - Parameters:
///   - setter: A setter with a Euclidean ring focus.
///   - value: A value the focus of a setter is divided by.
/// - Returns: A function that takes a source and returns a target by dividing the focus of a setter by the
///   given value.
public func /~ <S, T, A: EuclideanRing>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  setter %~ { $0 / value }
}

/// Performs a logical OR operation on the focus of a setter.
///
/// - Parameters:
///   - setter: A setter with a Heyting algebra focus.
///   - value: A value the focus of a setter joins.
/// - Returns: A function that takes a source and returns a target by joining the focus of a setter with the
///   given value.
public func ||~ <S, T, A: HeytingAlgebra>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  setter %~ { $0 || value }
}

/// Performs a logical AND operation on the focus of a setter.
///
/// - Parameters:
///   - setter: A setter with a Heyting algebra focus.
///   - value: A value the focus of a setter meets.
/// - Returns: A function that takes a source and returns a target by meeting the focus of a setter with the
///   given value.
public func &&~ <S, T, A: HeytingAlgebra>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  setter %~ { $0 && value }
}

/// Performs a semigroup operation on the focus of a setter.
///
/// - Parameters:
///   - setter: A setter with a semigroup focus.
///   - value: A value appended to the focus of a setter.
/// - Returns: A function that takes a source and returns a new target by performing a semigroup operation on
///   the focus of a setter and the given value.
public func <>~ <S, T, A: Semigroup>(setter: Setter<S, T, A, A>, value: A) -> (S) -> T {
  setter %~ { $0 <> value }
}
