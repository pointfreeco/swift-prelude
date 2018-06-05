import Prelude

public struct Reader<R, A> {
  let runReader: (R) -> A

  public init(_ runReader: @escaping (R) -> A) {
    self.runReader = runReader
  }
}

// MARK: - Functor

extension Reader {
  public func map<B>(_ f: @escaping (A) -> B) -> Reader<R, B> {
    return .init(self.runReader >>> f)
  }

  public static func <¢> <R, A, B> (f: @escaping (A) -> B, reader: Reader<R, A>) -> Reader<R, B> {
    return reader.map(f)
  }
}

// MARK: - Apply

extension Reader {
  public func apply<B>(_ f: Reader<R, (A) -> B>) -> Reader<R, B> {
    return .init { r in
      f.runReader(r) <| self.runReader(r)
    }
  }

  public static func <*> <R, A, B> (f: Reader<R, (A) -> B>, reader: Reader<R, A>) -> Reader<R, B> {
    return reader.apply(f)
  }
}

// MARK: - Applicative

public func pure<R, A>(_ a: A) -> Reader<R, A> {
  return .init(const(a))
}

// MARK: - Monad

extension Reader {

  public func flatMap<B>(_ f: @escaping (A) -> Reader<R, B>) -> Reader<R, B> {
    return .init { r in
      f(self.runReader(r)).runReader(r)
    }
  }
}
