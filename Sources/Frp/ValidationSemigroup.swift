import Prelude
import ValidationSemigroup

public func <*> <A, B, E: Semigroup>(a2b: Event<Validation<E, (A) -> B>>, a: Event<Validation<E, A>>)
  -> Event<Validation<E, B>> {

    return (<*>) <¢> (curry({ ($0, $1) }) <¢> a2b <*> a)
}

public func pure<E, A>(_ a: A) -> Event<Validation<E, A>> {
  return pure <<< pure <| a
}
