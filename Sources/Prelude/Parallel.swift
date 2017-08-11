import Dispatch

public final class Parallel<A> {
  private let compute: (@escaping (A) -> ()) -> ()
  private let queue = DispatchQueue(label: "Prelude.Parallel")
  fileprivate var computed: A?

  public init(_ compute : @escaping (@escaping (A) -> ()) -> ()) {
    self.compute = compute
  }

  public func run(_ callback: @escaping (A) -> ()) {
    queue.async {
      guard let computed = self.computed else {
        return self.compute { result in
          self.computed = result
          callback(result)
        }
      }
      callback(computed)
    }
  }
}

public func zip<A, B>(_ x: Parallel<A>, _ y: Parallel<B>) -> Parallel<(A, B)> {
  return Parallel<(A, B)> { f in
    x.run { x in if let y = y.computed { f((x, y)) } }
    y.run { y in if let x = x.computed { f((x, y)) } }
  }
}

public func parallel<A>(_ io: IO<A>) -> Parallel<A> {
  return .init {
    $0(io.perform())
  }
}

extension Parallel {
  public func run() -> IO<A> {
    return IO {
      var value: A?
      let semaphore = DispatchSemaphore(value: 0)
      self.run {
        value = $0
        semaphore.signal()
      }
      semaphore.wait()
      return value!
    }
  }
}

public func run<A>(_ x: Parallel<A>) -> IO<A> {
  return x.run()
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
    return zip(f, self).map { f, x in f(x) }
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
  return .init { $0(x) }
}

// MARK: - Alt

extension Parallel {
  public static func <|>(x: Parallel, y: Parallel) -> Parallel {
    return .init { f in
      var finished = false
      let callback: (A) -> () = {
        guard !finished else { return }
        finished = true
        f($0)
      }
      x.run(callback)
      y.run(callback)
    }
  }
}

// MARK: - Semigroup

extension Parallel where A: Semigroup {
  public static func <> (lhs: Parallel, rhs: Parallel) -> Parallel {
    return curry(<>) <¢> lhs <*> rhs
  }
}
