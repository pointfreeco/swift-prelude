public struct FreeSemiring<A>: Semiring {
  public let elements: [[A]]

  public init(_ elements: [[A]]) {
    self.elements = elements
  }

  public static func +(lhs: FreeSemiring<A>, rhs: FreeSemiring<A>) -> FreeSemiring<A> {
    return .init(lhs.elements <> rhs.elements)
  }

  public static func *(xss: FreeSemiring<A>, yss: FreeSemiring<A>) -> FreeSemiring<A> {
    return .init(
      xss.elements.flatMap { xs in
        yss.elements.map { ys in
          xs <> ys
        }
      }
    )
  }

  public static var zero: FreeSemiring<A> { return .init([]) }

  public static var one: FreeSemiring<A> { return .init([[]]) }
}

// MARK: - Functor

public func map<A, B>(_ f: @escaping (A) -> B) -> (FreeSemiring<A>) -> FreeSemiring<B> {
  return { s in
    .init(s.elements.map { $0.map(f) })
  }
}

// MARK: - Apply

public func apply<A, B>(_ fss: FreeSemiring<(A) -> B>) -> (FreeSemiring<A>) -> FreeSemiring<B> {
  return { (xss: FreeSemiring<A>) -> FreeSemiring<B> in

    .init(
      fss.elements
        .flatMap { fs in
          xss.elements.map { xs in
            fs <*> xs
          }
      }
    )
  }
}

// MARK: - Applicative

public func pure<A>(_ a: A) -> FreeSemiring<A> {
  return .init([[a]])
}

// MARK: - Equatable

public func ==<A: Equatable>(lhs: FreeSemiring<A>, rhs: FreeSemiring<A>) -> Bool {
  return lhs.elements.count == rhs.elements.count
    && zip(lhs.elements, rhs.elements).reduce(true) { accum, x in
      accum && x.0 == x.1
  }
}

// MARK: - Forgetful Functor Adjoint

public func liftFree<A, S: Semiring>(_ f: @escaping (A) -> S) -> (FreeSemiring<A>) -> S {
  return { xss in
    xss.elements.reduce(.zero) { accum, xs in
      accum + xs.map(f).reduce(.one, *)
    }
  }
}

public func lowerFree<A, S: Semiring>(_ f: @escaping (FreeSemiring<A>) -> S) -> (A) -> S {
  return pure >>> f
}

// MARK: - Sum & Product

public func sum<S: Semiring>(_ xs: [S]) -> S {
  return xs.reduce(.zero, +)
}

public func product<S: Semiring>(_ xs: [S]) -> S {
  return xs.reduce(.one, *)
}
