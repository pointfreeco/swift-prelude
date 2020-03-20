public struct FreeNearSemiring<A>: NearSemiring {
  public let elements: [[A]]

  public init(_ elements: [[A]]) {
    self.elements = elements
  }

  public static func + (lhs: FreeNearSemiring<A>, rhs: FreeNearSemiring<A>) -> FreeNearSemiring<A> {
    .init(lhs.elements <> rhs.elements)
  }

  public static func * (xss: FreeNearSemiring<A>, yss: FreeNearSemiring<A>) -> FreeNearSemiring<A> {
    .init(
      xss.elements.flatMap { xs in
        yss.elements.map { ys in
          xs <> ys
        }
      }
    )
  }

  public static var zero: FreeNearSemiring<A> { .init([]) }

  public static var one: FreeNearSemiring<A> { .init([[]]) }
}

// MARK: - Functor

public func map<A, B>(_ f: @escaping (A) -> B) -> (FreeNearSemiring<A>) -> FreeNearSemiring<B> {
  { s in
    .init(s.elements.map { $0.map(f) })
  }
}

// MARK: - Apply

public func apply<A, B>(_ fss: FreeNearSemiring<(A) -> B>) -> (FreeNearSemiring<A>) -> FreeNearSemiring<B> {
  { (xss: FreeNearSemiring<A>) -> FreeNearSemiring<B> in

    .init(
      fss.elements.flatMap { fs in
        xss.elements.map { xs in
          fs <*> xs
        }
      }
    )
  }
}

// MARK: - Applicative

public func pure<A>(_ a: A) -> FreeNearSemiring<A> {
  .init([[a]])
}

// MARK: - Equatable

extension FreeNearSemiring: Equatable where A: Equatable {
  public static func == (lhs: FreeNearSemiring, rhs: FreeNearSemiring) -> Bool {
    lhs.elements == rhs.elements
  }
}
