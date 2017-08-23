public func uncons<A>(_ xs: [A]) -> (A, [A])? {
  guard let x = xs.first else { return nil }
  return (x, Array(xs.dropFirst()))
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

// MARK: - Applicative

public func pure<A>(_ a: A) -> [A] {
  return [a]
}

// MARK: - Extend

extension Array {
  public static func <<- <A>(f: (Array) -> A, xs: Array) -> [A] {
    return xs.map { f([$0]) }
  }

  public static func ->> <A>(xs: Array, f: (Array) -> A) -> [A] {
    return f <<- xs
  }
}

public func ->- <A, B, C>(f: @escaping ([A]) -> B, g: @escaping ([B]) -> C) -> ([A]) -> C {
  return { w in
    g(f <<- w)
  }
}

public func -<- <A, B, C>(g: @escaping ([B]) -> C, f: @escaping ([A]) -> B) -> ([A]) -> C {
  return { w in
    g(f <<- w)
  }
}

public func duplicate<A>(_ xs: [A]) -> [[A]] {
  return id <<- xs
}

// MARK: - Point-free Standard Library

public func joined(separator: String) -> ([String]) -> String {
  return { xs in
    xs.joined(separator: separator)
  }
}
