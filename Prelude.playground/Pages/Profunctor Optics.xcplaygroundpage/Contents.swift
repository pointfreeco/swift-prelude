import Either
import Optics
import Prelude

(1, 2)
  |> first(String.init)

((1, 2), 3)
  |> (first <<< second)(const("hello"))

((1, 2), 3)
  |> first(const("hello"))

let add: (Int) -> (Int) -> Int = { x in { y in x + y } }
let incr = add(1)

// Strong/Lens

typealias Lens<S, T, A, B> = (@escaping (A) -> B) -> (S) -> T

func lens<S, T, A, B>(_ to: @escaping (S) -> (A, (B) -> T)) -> Lens<S, T, A, B> {
  return { pab in to >>> first(pab) >>> { bf in bf.1(bf.0) } }
}

func lens<S, T, A, B>(_ get: @escaping (S) -> A, _ set: @escaping (S, B) -> T) -> Lens<S, T, A, B> {
  return lens({ s in (get(s), { b in set(s, b) }) })
}

struct User {
  var id: Int
  var name: String
}

let user = User(id: 1, name: "Stephen")

let userIdLens = lens({ $0.id }, { (user: User, id: Int) in User(id: id, name: user.name) })
let userNameLens = lens({ $0.name }, { (user: User, name: String) in User(id: user.id, name: name) })

user |> userIdLens(const(2))

func %~ <S, T, A, B>(l: Lens<S, T, A, B>, over: @escaping (A) -> B) -> (S) -> T {
  return l(over)
}

func .~ <S, T, A, B>(l: Lens<S, T, A, B>, set: B) -> (S) -> T {
  return l %~ const(set)
}

dump(
  user |> userIdLens .~ 2
)

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

let projectCreatorLens = lens(
  { $0.creator },
  { (p: Project, c: User) in Project(id: p.id, creator: c, reviewer: p.reviewer, backers: p.backers) }
)

let projectReviewerLens = lens(
  { $0.reviewer },
  { (p: Project, r: User?) in Project(id: p.id, creator: p.creator, reviewer: r, backers: p.backers) }
)

let projectBackersLens = lens(
  { $0.backers },
  { (p: Project, bs: [User]) in Project(id: p.id, creator: p.creator, reviewer: p.reviewer, backers: bs) }
)

dump(
  project |> projectCreatorLens <<< userIdLens .~ 2
)

((1, 2), 3) |> first <<< second %~ incr

// Choice/Prism

Either<Int, Int>.left(2) |> right %~ incr
Either<Int, Int>.right(2) |> right %~ incr
Either<Int, Either<Int, Int>>.right(.right(1)) |> right <<< right %~ incr

func some<A, B>(_ a2b: @escaping (A) -> B) -> (A?) -> Either<B?, B?> {
  return { some in some.map(a2b >>> Either.right) ?? .left(.none) }
}

func none<A, B>(_ a2b: @escaping (()) -> ()) -> (A?) -> Either<B?, B?> {
  return { some in some.map(const(Either.left(.none))) ?? .right(.none) }
}

Either<User?, Int>.left(.none) |> left <<< some <<< userIdLens %~ incr

Optional.some(user) |> some <<< userIdLens .~ 666
Optional.none |> some <<< userIdLens .~ 666

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
  project |> projectBackersLens <<< traversed <<< userNameLens %~ uppercased
)

projectBackersLens <<< traversed <<< userIdLens %~ incr

func traversed<A, B>(_ a2b: @escaping (A) -> B) -> (A?) -> B? {
  return { arr in arr.map(a2b) }
}

project |> projectReviewerLens <<< traversed <<< userNameLens %~ uppercased

// Getter

struct Forget<R, A, B> {
  let unwrap: (A) -> R
}

typealias Getter<S, T, A, B> = (Forget<A, A, B>) -> Forget<A, S, T>

func .^ <S, T, A, B>(s: S, f: Getter<S, T, A, B>) -> A {
  return f(Forget<A, A, B>(unwrap: id)).unwrap(s)
}

let idGetter: Getter<Project, Project, Int, Int> = { forget in
  return Forget<Int, Project, Project> { project in forget.unwrap(project.id) }
}

project .^ idGetter

func getter<S, A>(_ keyPath: KeyPath<S, A>) -> Getter<S, S, A, A> {
  return { forget in
    .init(unwrap: { s in forget.unwrap(s[keyPath: keyPath]) })
  }
}

func .^ <S, A>(s: S, kp: KeyPath<S, A>) -> A {
  return s .^ getter(kp)
}

project .^ \.id

typealias Setter<S, T, A, B> = Lens<S, T, A, B>

func setter<S, A>(_ keyPath: WritableKeyPath<S, A>) -> Setter<S, S, A, A> {
  return { f in
    { s in
      var t = s
      t[keyPath: keyPath] = f(t[keyPath: keyPath])
      return t
    }
  }
}

func %~ <S, A>(kp: WritableKeyPath<S, A>, a: @escaping (A) -> A) -> (S) -> S {
  return setter(kp) %~ a
}

project |> \.id %~ incr
