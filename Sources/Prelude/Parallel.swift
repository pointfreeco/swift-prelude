import Dispatch

public final class Parallel<A> {
  private let compute: (@escaping (A) -> ()) -> ()
  private let queue = DispatchQueue(label: "Prelude.Parallel")
  fileprivate var computed: A?

  public init(_ compute: @escaping (@escaping (A) -> ()) -> ()) {
    self.compute = compute
  }

  public func run(_ callback: @escaping (A) -> ()) {
    self.queue.async {
      guard let computed = self.computed else {
        return self.compute { computed in
          self.computed = computed
          callback(computed)
        }
      }
      callback(computed)
    }
  }
}

public func parallel<A>(_ io: IO<A>) -> Parallel<A> {
  return .init {
    $0(io.perform())
  }
}

extension Parallel {
  public var sequential: IO<A> {
    return .init { callback in
      self.run(callback)
    }
  }
}

public func sequential<A>(_ x: Parallel<A>) -> IO<A> {
  return x.sequential
}

// MARK: - Functor

extension Parallel {
  public func map<B>(_ f: @escaping (A) -> B) -> Parallel<B> {
    return .init {
      self.run($0 <<< f)
    }
  }

  public static func <¢> <B>(f: @escaping (A) -> B, x: Parallel<A>) -> Parallel<B> {
    return x.map(f)
  }
}

public func map<A, B>(_ f: @escaping (A) -> B) -> (Parallel<A>) -> Parallel<B> {
  return { f <¢> $0 }
}

// MARK: - Apply

extension Parallel {
  public func apply<B>(_ f: Parallel<(A) -> B>) -> Parallel<B> {
    return .init { g in
      f.run { f in if let x = self.computed { g(f(x)) } }
      self.run { x in if let f = f.computed { g(f(x)) } }
    }
  }

  public static func <*> <B>(f: Parallel<(A) -> B>, x: Parallel<A>) -> Parallel<B> {
    return x.apply(f)
  }
}

public func apply<A, B>(_ f: Parallel<(A) -> B>) -> (Parallel<A>) -> Parallel<B> {
  return { f <*> $0 }
}

// MARK: - Applicative

public func pure<A>(_ x: A) -> Parallel<A> {
  return parallel <<< pure <| x
}

// MARK: - Traversable

public func traverse<C, A, B>(
  _ f: @escaping (A) -> Parallel<B>
  )
  -> (C)
  -> Parallel<[B]>
  where C: Collection, C.Element == A {

    return { xs in
      guard xs.isEmpty else { return pure([]) }

      return Parallel<[B]> { callback in
        let queue = DispatchQueue(label: "pointfree.parallel.sequence")

        var completed = 0
        var results = [B?](repeating: nil, count: Int(xs.count))

        for (idx, parallel) in xs.map(f).enumerated() {
          parallel.run {
            results[idx] = $0

            queue.sync {
              completed += 1
              if completed == xs.count {
                callback(results as! [B])
              }
            }
          }
        }
      }
    }
}

public func sequence<C, A>(_ xs: C) -> Parallel<[A]> where C: Collection, C.Element == Parallel<A> {
  return xs |> traverse(id)
}

// MARK: - Alt

extension Parallel {
  public static func <|>(lhs: Parallel, rhs: Parallel) -> Parallel {
    return .init { f in
      var finished = false
      let callback: (A) -> () = {
        guard !finished else { return }
        finished = true
        f($0)
      }
      lhs.run(callback)
      rhs.run(callback)
    }
  }
}

// MARK: - Semigroup

extension Parallel where A: Semigroup {
  public static func <>(lhs: Parallel, rhs: Parallel) -> Parallel {
    return curry(<>) <¢> lhs <*> rhs
  }
}

// MARK: - Monoid

extension Parallel where A: Monoid {
  public static var empty: Parallel {
    return pure(A.empty)
  }
}

public func zip2<A, B>(_ lhs: Parallel<A>, _ rhs: Parallel<B>) -> Parallel<(A, B)> {
  return tuple <¢> lhs <*> rhs
}

public func zip3<A, B, C>(_ a: Parallel<A>, _ b: Parallel<B>, _ c: Parallel<C>) -> Parallel<(A, B, C)> {
  return tuple3 <¢> a <*> b <*> c
}

public func zip4<A, B, C, D>(
  _ a: Parallel<A>,
  _ b: Parallel<B>,
  _ c: Parallel<C>,
  _ d: Parallel<D>
  ) -> Parallel<(A, B, C, D)> {

  return tuple4 <¢> a <*> b <*> c <*> d
}

public func zip5<A, B, C, D, E>(
  _ a: Parallel<A>,
  _ b: Parallel<B>,
  _ c: Parallel<C>,
  _ d: Parallel<D>,
  _ e: Parallel<E>
  ) -> Parallel<(A, B, C, D, E)> {

  return tuple5 <¢> a <*> b <*> c <*> d <*> e
}

public func tuple5<A, B, C, D, E>(_ a: A) -> (B) -> (C) -> (D) -> (E) -> (A, B, C, D, E) {
  return { b in { c in { d in { e in (a, b, c, d, e) } } } }
}
