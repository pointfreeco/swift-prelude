import Either
@testable import Optics
import Prelude

(1, 2)
  |> first(String.init)

((1, 2), 3)
  |> (first <<< second)(const("hello"))

((1, 2), 3)
  |> first(const("hello"))

let add: (Int) -> (Int) -> Int = { x in { y in x + y } }
let incr = add(1)

struct User {
  var id: Int
  var name: String
}

let user = User(id: 1, name: "Stephen")

user |> \.id %~ incr

struct Project {
  var id: Int
  var creator: User
  var reviewer: User?
  var backers: [User]
}

let project = Project(
  id: 1,
  creator: user,
  reviewer: nil,
  backers: [User(id: 2, name: "Lisa"), User(id: 3, name: "Brandon")]
)

dump(
  project |> \.creator.id .~ 2
)

((1, 2), 3) |> first <<< second %~ incr

// Choice/Prism

Either<Int, Int>.left(2) |> right %~ incr
Either<Int, Int>.right(2) |> right %~ incr
Either<Int, Either<Int, Int>>.right(.right(1)) |> right <<< right %~ incr

Either<User?, Int>.left(.none) |> left <<< some <<< setting(\.id) %~ incr
Optional.some(user) |> some <<< setting(\User.id) .~ 666
Optional.none |> some <<< setting(\User.id) .~ 666

//typealias Prism<S, T, A, B> = (@escaping (A) -> B) -> (S) -> Either<T, T>
//
//func prism<S, T, A, B>(_ to: @escaping (B) -> T, _ fro: @escaping (S) -> Either<T, A>) -> Prism<S, T, A, B> {
//  return { pab in fro >>> right(pab >>> to) }
//}
//
//func prism<S, A>(_ to: @escaping (A) -> S, _ fro: @escaping (S) -> A?) -> Prism<S, S, A, A> {
//  return prism(to, { s in fro(s).map(Either.right) ?? .left(s) })
//}
//
//func _none<A, B>() -> Prism<A?, B?, (), ()> {
//  return prism(const(Optional.none), { a in a.map(const(Either.left(.none))) ?? .right(()) })
//}
//
//func _some<A, B>() -> Prism<A?, B?, A, B> {
//  return prism(Optional.some, { a in a.map(Either.right) ?? .left(.none) })
//}
//
// Traversal

func traversed<A, B>(_ a2b: @escaping (A) -> B) -> ([A]) -> [B] {
  return { arr in arr.map(a2b) }
}

let uppercased: (String) -> String = { $0.uppercased() }

dump(
  project |> \.backers <<< traversed <<< \.name %~ uppercased
)

\Project.backers <<< traversed <<< \.id %~ incr

func traversed<A, B>(_ a2b: @escaping (A) -> B) -> (A?) -> B? {
  return { arr in arr.map(a2b) }
}

project |> \.reviewer <<< traversed <<< \.name %~ uppercased
