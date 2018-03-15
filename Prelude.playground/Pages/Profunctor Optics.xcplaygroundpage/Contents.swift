import Either
@testable import Optics
import Prelude

// is there a function lift: ((A) -> B) -> ([A]) -> [B]
// such that lift(id) == id and lift(f >>> g) == lift(f) >>> lift(g)


func lift<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
  return { xs in
//    xs.map(f).reversed()
    xs.enumerated().map { idx, x in

    }
  }
}

func f<A, B>(_ a: A) -> B { fatalError() }
func g<A, B>(_ a: A) -> B { fatalError() }
func h<A, B>(_ a: A) -> B { fatalError() }
func k<A, B>(_ a: A) -> B { fatalError() }

func fmap<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
  return { $0.map(f) }
}


let count: (String) -> Int = { $0.count }

fmap(fmap(count))
fmap(count)
fmap as (@escaping (String) -> Int) -> ([String]) -> [Int]


// if `f >>> g == h >>> k`
// then `map(f) >>> lift(g) == lift(h) >>> map(k)

// So, if `f = id` and `h = id`, then
//   id >>> g == id >>> k,
//     hence g == k
//   map(id) >>> lift(g) = lift(id) >>> map(k)
//   id >>> lift(g) = id >>> map(k)
//   lift(g) = map(k)
//   lift(g) = map(g)

// https://www.schoolofhaskell.com/user/edwardk/snippets/fmap

// https://bartoszmilewski.com/2014/09/22/parametricity-money-for-nothing-and-theorems-for-free/

// https://duplode.github.io/posts/what-does-fmap-preserve.html

print("Done")




//[1:1].map

//Set<Int>([1, 2]).map

func fakeMap1<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
  return { _ in [] }
}
func fakeMap2<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
  return { Array($0.map(f).reversed()) }
}

let incr = { $0 + 1 }
let square: (Int) -> Int = { $0 * $0 }

[1, 2, 3] |> fakeMap1(incr >>> square)

// map(f) >>> map(id) = map(f >>> id) = map(f)
// map(id) >>> map(f) = map(id >>> f) = map(f)


func r<A>(_ xs: [A]) -> [A] {
  return [xs, xs].flatMap { $0 }.reversed()
}

//r (map f as) = map f (r as)


[1, 2, 3] |> r >>> fmap(square)
[1, 2, 3] |> fmap(square) >>> r



// f >>> g = h >>> k

// lift(f) >>> map(g) == map(g) >>> lift(f)


func unkonwnArrayTransform<A>(_ xs: [A]) -> [A] {
  // return xs.reversed()
  // return []
  // return xs + xs
  // return xs + xs + xs
  // return xs.shuffle(seed: 42)
  // return Array(xs.prefix(1))
  // return Array(xs.prefix(2))
  // return Array(xs.suffix(1))
  // return Array(xs.suffix(2))
  fatalError()
}

func unknownTransform<A>(_ a: A) -> A {
  fatalError()
}

unkonwnArrayTransform >>> fmap(count)
fmap(count) >>> unkonwnArrayTransform


(lift(f) >>> fmap(count)) as ([String]) -> [Int]
fmap(count) >>> lift(unknownTransform)

// If f >>> g == h >>> k
// lift(f) >>> fmap(g) == fmap(h) >>> lift(k)
//


(unkonwnArrayTransform >>> fmap(f)) as ([String]) -> [Int]
(fmap(f) >>> unkonwnArrayTransform) as ([String]) -> [Int]


// f >>> g == h >>> k

//lift(f) >>> map(g)
//map(h) >>> lift(k)

[1, 2, 3] |> lift(incr) >>> fmap(square)
[1, 2, 3] |> map(incr >>> square) >>> lift(id)


// (lift(f) >>> fmap(g)) as ([String]) -> [Int]
// (fmap(f) >>> lift(g)) as ([String]) -> [Int]






