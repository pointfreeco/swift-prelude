public struct FreeNearSemiring<A>: NearSemiring {
  public let elements: [[A]]

  public init(_ elements: [[A]]) {
    self.elements = elements
  }

  public static func +(lhs: FreeNearSemiring<A>, rhs: FreeNearSemiring<A>) -> FreeNearSemiring<A> {
    return .init(lhs.elements <> rhs.elements)
  }

  public static func *(xss: FreeNearSemiring<A>, yss: FreeNearSemiring<A>) -> FreeNearSemiring<A> {
    return .init(
      xss.elements.flatMap { xs in
        yss.elements.map { ys in
          xs <> ys
        }
      }
    )
  }

  public static var zero: FreeNearSemiring<A> { return .init([]) }

  public static var one: FreeNearSemiring<A> { return .init([[]]) }
}

// MARK: - Functor

public func map<A, B>(_ f: @escaping (A) -> B) -> (FreeNearSemiring<A>) -> FreeNearSemiring<B> {
  return { s in
    .init(s.elements.map { $0.map(f) })
  }
}

// MARK: - Apply

public func apply<A, B>(_ fss: FreeNearSemiring<(A) -> B>) -> (FreeNearSemiring<A>) -> FreeNearSemiring<B> {
  return { (xss: FreeNearSemiring<A>) -> FreeNearSemiring<B> in

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

public func pure<A>(_ a: A) -> FreeNearSemiring<A> {
  return .init([[a]])
}

// MARK: - Equatable

public func ==<A: Equatable>(lhs: FreeNearSemiring<A>, rhs: FreeNearSemiring<A>) -> Bool {
  return lhs.elements.count == rhs.elements.count
    && zip(lhs.elements, rhs.elements).reduce(true) { accum, x in
      accum && x.0 == x.1
  }
}

// MARK: - Forgetful Functor Adjoint

public func liftFree<A, S: NearSemiring>(_ f: @escaping (A) -> S) -> (FreeNearSemiring<A>) -> S {
  return { xss in
    xss.elements.reduce(.zero) { accum, xs in
      accum + xs.map(f).reduce(.one, *)
    }
  }
}

public func lowerFree<A, S: NearSemiring>(_ f: @escaping (FreeNearSemiring<A>) -> S) -> (A) -> S {
  return pure >>> f
}

// MARK: - Sum & Product

public func sum<S: NearSemiring>(_ xs: [S]) -> S {
  return xs.reduce(.zero, +)
}

public func product<S: NearSemiring>(_ xs: [S]) -> S {
  return xs.reduce(.one, *)
}
