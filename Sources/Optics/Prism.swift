import Either
import Prelude

//class Profunctor p <= Choice p where
//  left :: forall a b c. p a b -> p (Either a c) (Either b c)
//  right :: forall a b c. p b c -> p (Either a b) (Either a c)

//type Review s t a b = Optic Tagged s t a b
//type Review' s a = Review s s a a

//newtype Tagged a b = Tagged b

//type Prism s t a b = forall p. Choice p => Optic p s t a b
//type Prism' s a = Prism s s a a

public typealias Market<A, B, S, T> = (review: (B) -> T, preview: (S) -> Either<T, A>)

public typealias APrism<S, T, A, B> = (Market<A, B, A, B>) -> Market<A, B, S, T>

public func withPrism<S, T, A, B, R>(_ prism: APrism<S, T, A, B>, _ f: (Market<A, B, S, T>) -> R) -> R {
  f <| prism((id, Either.right))
}

public func matching<S, T, A, B>(_ prism: @escaping APrism<S, T, A, B>) -> (S) -> Either<T, A> {
  { s in
    withPrism(prism) { $0.preview <| s }
  }
}

public func `is`<S, T, A, B, R: HeytingAlgebra>(_ prism: @escaping APrism<S, T, A, B>) -> (S) -> R {
  either(const(R.ff), const(R.tt)) <<< matching(prism)
}

public func isnt<S, T, A, B, R: HeytingAlgebra>(_ prism: @escaping APrism<S, T, A, B>) -> (S) -> R {
  (!) <<< `is`(prism)
}

// Optional

public func some<A, B>(_ a2b: @escaping (A) -> B) -> (A?) -> Either<B?, B?> {
  { some in some.map(a2b >>> Either.right) ?? .left(.none) }
}

public func none<A, B>(_ a2b: @escaping (()) -> ()) -> (A?) -> Either<B?, B?> {
  { some in some.map(const(Either.left(.none))) ?? .right(.none) }
}
