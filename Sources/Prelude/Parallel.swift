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
  .init {
    $0(io.perform())
  }
}

extension Parallel {
  public var sequential: IO<A> {
    .init { callback in
      self.run(callback)
    }
  }
}

public func sequential<A>(_ x: Parallel<A>) -> IO<A> {
  x.sequential
}

// MARK: - Functor

extension Parallel {
  public func map<B>(_ f: @escaping (A) -> B) -> Parallel<B> {
    .init {
      self.run($0 <<< f)
    }
  }

  public static func <¢> <B>(f: @escaping (A) -> B, x: Parallel<A>) -> Parallel<B> {
    x.map(f)
  }
}

public func map<A, B>(_ f: @escaping (A) -> B) -> (Parallel<A>) -> Parallel<B> {
  { f <¢> $0 }
}

// MARK: - Apply

extension Parallel {
  public func apply<B>(_ f: Parallel<(A) -> B>) -> Parallel<B> {
    .init { g in
      f.run { f in if let x = self.computed { g(f(x)) } }
      self.run { x in if let f = f.computed { g(f(x)) } }
    }
  }

  public static func <*> <B>(f: Parallel<(A) -> B>, x: Parallel<A>) -> Parallel<B> {
    x.apply(f)
  }
}

public func apply<A, B>(_ f: Parallel<(A) -> B>) -> (Parallel<A>) -> Parallel<B> {
  { f <*> $0 }
}

// MARK: - Applicative

public func pure<A>(_ x: A) -> Parallel<A> {
  parallel <<< pure <| x
}

// MARK: - Traversable

public func traverse<C, A, B>(
  _ f: @escaping (A) -> Parallel<B>
  )
  -> (C)
  -> Parallel<[B]>
  where C: Collection, C.Element == A {

    return { xs in
      guard !xs.isEmpty else { return pure([]) }

      return Parallel<[B]> { callback in
        let queue = DispatchQueue(label: "pointfree.parallel.sequence")

        var completed = 0
        var results = [B?](repeating: nil, count: Int(xs.count))

        for (idx, parallel) in xs.map(f).enumerated() {
          parallel.run { b in
            queue.sync {
              results[idx] = b
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

extension Parallel: Alt {
  public static func <|> (lhs: Parallel, rhs: @autoclosure @escaping () -> Parallel) -> Parallel {
    .init { f in
      var finished = false
      let callback: (A) -> () = {
        guard !finished else { return }
        finished = true
        f($0)
      }
      lhs.run(callback)
      rhs().run(callback)
    }
  }
}

// MARK: - Semigroup

extension Parallel: Semigroup where A: Semigroup {
  public static func <> (lhs: Parallel, rhs: Parallel) -> Parallel {
    curry(<>) <¢> lhs <*> rhs
  }
}

// MARK: - Monoid

extension Parallel: Monoid where A: Monoid {
  public static var empty: Parallel {
    pure(A.empty)
  }
}
