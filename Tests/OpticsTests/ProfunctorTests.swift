import Either
import Optics
import Prelude
import XCTest

func traversed<A, B>(_ a2b: @escaping (A) -> B) -> ([A]) -> [B] {
  return { arr in arr.map(a2b) }
}

func some<A, B>(_ a2b: @escaping (A) -> B) -> (A?) -> Either<B?, B?> {
  return { some in some.map(a2b >>> Either.right) ?? .left(.none) }
}

// this is wrong v
func ix<A>(_ idx: Int) -> Getter<[A], [A], A, A> {
  return { (forget: Forget<A, A, A>) -> Forget<A, [A], [A]> in
    Forget<A, [A], [A]> { (xs: [A]) -> A in
      forget.unwrap(xs[idx])
    }
  }
}

let incr = { $0 + 1 }

class ProfunctorTests: XCTestCase {
  func testLens() {

    let data: [Either<[Int?], String>] = [
      .left([1, 2, nil, 3]),
      .right("hello!")
    ]

    dump(data |> traversed <<< left <<< traversed <<< some %~ incr)

    print("")

    dump(data .^ ix(0))
//    dump(data .^ (traversed <<< left <<< ix(0)))

    //dump(data .^ (traversed <<< left <<< traversed <<< some))
  }
}
