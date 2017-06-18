public func uncons<A>(_ xs: [A]) -> (A, [A])? {
  guard let x = xs.first else { return nil }
  return (x, Array(xs.dropFirst()))
}

public func <*> <A, B> (fs: [(A) -> B], xs: [A]) -> [B] {
  return fs.flatMap { f in xs.map(f) }
}

public func foldMap<A, M: Monoid>(_ f: @escaping (A) -> M) -> ([A]) -> M {
  return { xs in
    xs.reduce(M.e) { accum, x in accum <> f(x) }
  }
}

public func partition<A>(_ p: @escaping (A) -> Bool) -> ([A]) -> ([A], [A]) {
  return { xs in
    xs.reduce(([], [])) { accum, x in
      p(x) ? (accum.0 + [x], accum.1) : (accum.0, accum.1 + [x])
    }
  }
}

public func elem<A: Equatable>(_ x: A) -> ([A]) -> Bool {
  return { xs in xs.contains(x) }
}

public func elem<A: Equatable>(of xs: [A]) -> (A) -> Bool {
  return { x in xs.contains(x) }
}

public func zipWith<A, B, C>(_ f: @escaping (A, B) -> C) -> ([A]) -> ([B]) -> [C] {
  return { xs in
    return { ys in
      return zip(xs, ys).map { f($0.0, $0.1) }
    }
  }
}

public func sorted<A>(by f: @escaping (A, A) -> Bool) -> ([A]) -> [A] {
  return { xs in
    xs.sorted(by: f)
  }
}

public func lookup<A: Equatable, B>(_ x: A) -> ([(A, B)]) -> B? {
  return { pairs in
    pairs.first { pair in pair.0 == x }.map(second)
  }
}

public func replicate<A>(_ n: Int) -> (A) -> [A] {
  return { a in (1...n).map(const(a)) }
}
