import Prelude

public struct State<S, A> {
  public let run: (S) -> (result: A, finalState: S)

  public init(run: @escaping (S) -> (result: A, finalState: S)) {
    self.run = run
  }

  public func eval(_ state: S) -> A {
    return self.run(state).result
  }

  public func exec(_ state: S) -> S {
    return self.run(state).finalState
  }

  public func with(_ modification: @escaping (S) -> S) -> State<S, A> {
    return State(run: self.run <<< modification)
  }
}

extension State {
  public static var get: State<S, S> {
    return .init { ($0, $0) }
  }

  public static func gets(_ f: @escaping (S) -> A) -> State<S, A> {
    return .init { (f($0), $0) }
  }

  public static func put(_ state: S) -> State<S, Unit> {
    return .init { _ in (unit, state) }
  }

  public static func modify(_ f: @escaping (S) -> S) -> State<S, Unit> {
    return .init { (unit, f($0)) }
  }
}

// MARK: - Functor

extension State {
  public func map<B>(_ a2b: @escaping (A) -> B) -> State<S, B> {
    return State<S, B> { state in
      let (result, finalState) = self.run(state)
      return (a2b(result), finalState)
    }
  }

  public static func <¢> <B>(a2b: @escaping (A) -> B, sa: State<S, A>) -> State<S, B> {
    return sa.map(a2b)
  }

  public static func <^> <B>(a2b: @escaping (A) -> B, sa: State<S, A>) -> State<S, B> {
      return sa.map(a2b)
  }
}

// MARK: - Apply

extension State {
  public func apply<B>(_ sa2b: State<S, (A) -> B>) -> State<S, B> {
    return sa2b.flatMap { a2b in self.map(a2b) }
  }

  public static func <*> <B>(sa2b: State<S, (A) -> B>, sa: State) -> State<S, B> {
    return sa.apply(sa2b)
  }
}

// MARK: - Applicative

public func pure<S, A>(_ a: A) -> State<S, A> {
  return .init { (a, $0) }
}

// MARK: - Bind/Monad

extension State {
  public func flatMap<B>(_ a2sb: @escaping (A) -> State<S, B>) -> State<S, B> {
    return State<S, B> { state in
      let (result, nextState) = self.run(state)
      return a2sb(result).run(nextState)
    }
  }
}
