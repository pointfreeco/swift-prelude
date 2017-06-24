public func uncons<A>(_ xs: [A]) -> (A, [A])? {
  guard let x = xs.first else { return nil }
  return (x, Array(xs.dropFirst()))
}

public func <*> <A, B> (fs: [(A) -> B], xs: [A]) -> [B] {
  return fs.flatMap { f in xs.map(f) }
}

public func pure<A>(_ a: A) -> [A] {
  return [a]
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

public func lookup<A: Equatable, B>(_ x: A) -> ([(A, B)]) -> B? {
  return { pairs in
    pairs.first { pair in pair.0 == x }.map(second)
  }
}

public func replicate<A>(_ n: Int) -> (A) -> [A] {
  return { a in (1...n).map(const(a)) }
}
