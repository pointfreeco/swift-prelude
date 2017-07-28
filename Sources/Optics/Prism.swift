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
  return f <| prism((id, Either.right))
}

public func matching<S, T, A, B>(_ prism: @escaping APrism<S, T, A, B>) -> (S) -> Either<T, A> {
  return { s in
    withPrism(prism) { $0.preview <| s }
  }
}

public func `is`<S, T, A, B, R: HeytingAlgebra>(_ prism: @escaping APrism<S, T, A, B>) -> (S) -> R {
  return either(const(R.ff), const(R.tt)) <<< matching(prism)
}

public func `isnt`<S, T, A, B, R: HeytingAlgebra>(_ prism: @escaping APrism<S, T, A, B>) -> (S) -> R {
  return not <<< `is`(prism)
}


func ix<S>(_ idx: Int) -> APrism<[S], [S], S, S> {

  return { market in

    let tmp1 = market.preview
    let tmp2 = market.review

    fatalError()
  }
}

func _left<A, B, C>() -> APrism<Either<A, C>, Either<B, C>, A, B> {
  return { market in

    let tmp1 = market.preview
    let tmp2 = market.review

    let result: (review: (B) -> Either<B, C>, preview: (Either<A, C>) -> Either<Either<B, C>, A>)

    result.review = Either.left

    result.preview = { a_or_c in
      a_or_c.either(Either.right, { .left(.right($0)) })
    }

    return result
  }
}

//-- | Prism for the `Left` constructor of `Either`.
//_Left :: forall a b c. Prism (Either a c) (Either b c) a b
//_Left = left
//
//-- | Prism for the `Right` constructor of `Either`.
//_Right :: forall a b c. Prism (Either c a) (Either c b) a b
//_Right = right




