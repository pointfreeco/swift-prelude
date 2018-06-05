public func uncons<A>(_ xs: [A]) -> (A, [A])? {
  guard let x = xs.first else { return nil }
  return (x, Array(xs.dropFirst()))
}

public func partition<A>(_ p: @escaping (A) -> Bool) -> ([A]) -> ([A], [A]) {
  return { xs in
    xs.reduce(into: ([], [])) { accum, x in
      if p(x) {
        accum.0.append(x)
      } else {
        accum.1.append(x)
      }
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

// MARK: - Applicative

public func pure<A>(_ a: A) -> [A] {
  return [a]
}

// MARK: - Point-free Standard Library

public func joined(separator: String) -> ([String]) -> String {
  return { xs in
    xs.joined(separator: separator)
  }
}
