import Prelude

struct First<A>: Monoid {
  let unwrap: A?

  init(_ unwrap: A?) {
    self.unwrap = unwrap
  }

  static func <>(lhs: First<A>, rhs: First<A>) -> First<A> {
    return .init(lhs.unwrap ?? rhs.unwrap)
  }

  static var empty: First<A> { return .init(nil) }
}

public typealias Fold<R, S, T, A, B> = (Forget<R, A, B>) -> Forget<R, S, T>

func under<A, B>(_ f: @escaping (First<A>) -> First<B>) -> (A?) -> B? {
  return { a in f(.init(a)).unwrap }
}

func unwrap<A>(_ wrapped: First<A>) -> A? {
  return wrapped.unwrap
}

func preview<S, T, A, B>(_ fold: @escaping Fold<First<A>, S, T, A, B>) -> (S) -> A? {
  return unwrap <<< foldMapOf(fold)(First.init <<< A?.some)
}

func previewOn<S, T, A, B>(_ s: S, _ fold: @escaping Fold<First<A>, S, T, A, B>) -> A? {
  return preview(fold) <| s
}

infix operator ^?: infixl8
func ^? <S, T, A, B> (s: S, fold: @escaping Fold<First<A>, S, T, A, B>) -> A? {
  return previewOn(s, fold)
}

func foldMapOf<R, S, T, A, B>(_ fold: @escaping Fold<R, S, T, A, B>) -> (@escaping (A) -> R) -> (S) -> R {
  return { f in
    return { s in
      fold(.init(f)).unwrap(s)
    }
  }
}

func foldOf<S, T, A, B>(_ fold: @escaping Fold<A, S, T, A, B>) -> (S) -> A {
  return foldMapOf(fold)(id)
}

//func allOf<R: HeytingAlgebra, S, T, A, B>(_ fold: Fold


//-- | Whether all foci of a `Fold` satisfy a predicate.
//allOf :: forall s t a b r. HeytingAlgebra r => Fold (Conj r) s t a b -> (a -> r) -> s -> r
//allOf p f = unwrap <<< foldMapOf p (Conj <<< f)







