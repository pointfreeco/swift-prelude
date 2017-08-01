import Prelude

struct ArrayStar<A, B> {
  let call: (A) -> [B]
  init(_ call: @escaping (A) -> [B]) {
    self.call = call
  }

  func map<C>(_ f: @escaping (B) -> C) -> ArrayStar<A, C> {
    return .init(Prelude.map(f) <<< self.call)
  }

  func apply<C>(_ f: ArrayStar<A, (B) -> C>) -> ArrayStar<A, C> {
    return .init { a in
      f.call(a) <*> self.call(a)
    }
  }

  func dimap<C, D>(_ f: @escaping (C) -> A, _ g: @escaping (B) -> D) -> ArrayStar<C, D> {
    return .init(f >>> self.call >>> Prelude.map(g))
  }
}

func pure<A, B>(_ b: B) -> ArrayStar<A, B> {
  return .init(const(pure(b)))
}

func traverseOf<S, T, A, B>(_ optic: @escaping (ArrayStar<A, B>) -> ArrayStar<S, T>) -> (@escaping (A) -> [B]) -> (S) -> [T] {
  return { f in
    return { s in
      optic(.init(f)).call(s)
    }
  }
}
