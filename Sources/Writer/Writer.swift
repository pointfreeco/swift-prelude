import Prelude

public struct Writer<W: Monoid, A> {
  let a: A
  let w: W

  public init(_ a: A, _ w: W) {
    self.a = a
    self.w = w
  }

  public var runWriter: (A, W) {
    return (a, w)
  }
}

// MARK: - Functor

extension Writer {
  public func map<B>(_ f: (A) -> B) -> Writer<W, B> {
    return .init(f(self.a), self.w)
  }

  public static func <¢> <W, A, B> (f: @escaping (A) -> B, writer: Writer<W, A>) -> Writer<W, B> {
    return writer.map(f)
  }
}

// MARK: - Apply

extension Writer {
  public func apply<B>(_ f: Writer<W, (A) -> B>) -> Writer<W, B> {
    return .init(f.a(self.a), self.w <> f.w)
  }

  public static func <*> <W, A, B> (f: Writer<W, (A) -> B>, writer: Writer<W, A>) -> Writer<W, B> {
    return writer.apply(f)
  }
}

// MARK: - Applicative

public func pure<W, A>(_ a: A) -> Writer<W, A> {
  return .init(a, W.empty)
}

// MARK: - Monad

extension Writer {
  public func flatMap<B>(_ f: (A) -> Writer<W, B>) -> Writer<W, B> {
    let writer = f(self.a)
    return .init(writer.a, self.w <> writer.w)
  }
}
