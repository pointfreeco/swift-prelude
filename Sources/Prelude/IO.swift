import Dispatch
import Foundation

public struct IO<A> {
  private let compute: () async -> A

  public init(_ compute: @escaping () -> A) {
    self.compute = compute
  }

  public init(_ compute: @escaping () async -> A) {
    self.compute = compute
  }

  @available(*, deprecated, message: "Use 'performAsync', instead.")
  public func perform() -> A {
    let a = LockIsolated<A?>(nil)
    let sema = DispatchSemaphore(value: 0)
    Task {
      let value = await self.compute()
      a.setValue(value)
      sema.signal()
    }
    sema.wait()
    return a.value!
  }

  public func performAsync() async -> A {
    await self.compute()
  }
}

@available(*, deprecated, message: "Use 'performAsync', instead.")
public func perform<A>(_ io: IO<A>) -> A {
  return io.perform()
}

extension IO {
  public static func wrap<I>(_ f: @escaping (I) -> A) -> (I) -> IO<A> {
    return { input in
      .init { f(input) }
    }
  }
}

extension IO {
  public init(_ callback: @escaping (@escaping (A) -> ()) -> ()) {
    self.init {
      await withUnsafeContinuation { continuation in
        callback { a in
          continuation.resume(returning: a)
        }
      }
    }
  }

  public func delay(_ interval: DispatchTimeInterval) -> IO {
    return .init {
      switch interval {
      case let .microseconds(n):
        try? await Task.sleep(nanoseconds: UInt64(n) * 1_000)
      case let .milliseconds(n):
        try? await Task.sleep(nanoseconds: UInt64(n) * 1_000_000)
      case .never:
        let never = AsyncStream<Void> { _ in }
        for await _ in never {}
      case let .nanoseconds(n):
        try? await Task.sleep(nanoseconds: UInt64(n))
      case let .seconds(n):
        try? await Task.sleep(nanoseconds: UInt64(n) * 1_000_000_000)
      @unknown default:
        let never = AsyncStream<Void> { _ in }
        for await _ in never {}
      }
      return await self.performAsync()
    }
  }

  public func delay(_ interval: TimeInterval) -> IO {
    return .init {
      try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
      return await self.performAsync()
    }
  }
}

public func delay<A>(_ interval: DispatchTimeInterval) -> (IO<A>) -> IO<A> {
  return { $0.delay(interval) }
}

public func delay<A>(_ interval: TimeInterval) -> (IO<A>) -> IO<A> {
  return { $0.delay(interval) }
}

extension IO {
  public var parallel: Parallel<A> {
    Parallel {
      await self.performAsync()
    }
  }
}

// MARK: - Functor

extension IO {
  public func map<B>(_ f: @escaping (A) -> B) -> IO<B> {
    return IO<B> {
      await self.performAsync() |> f
    }
  }

  public static func <¢> <B>(f: @escaping (A) -> B, x: IO<A>) -> IO<B> {
    return x.map(f)
  }
}

public func map<A, B>(_ f: @escaping (A) -> B) -> (IO<A>) -> IO<B> {
  return { f <¢> $0 }
}

// MARK: - Apply

extension IO {
  public func apply<B>(_ f: IO<(A) -> B>) -> IO<B> {
    return IO<B> {
      await f.performAsync() <| self.performAsync()
    }
  }

  public static func <*> <B>(f: IO<(A) -> B>, x: IO<A>) -> IO<B> {
    return x.apply(f)
  }
}

public func apply<A, B>(_ f: IO<(A) -> B>) -> (IO<A>) -> IO<B> {
  return { f <*> $0 }
}

// MARK: - Applicative

public func pure<A>(_ a: A) -> IO<A> {
  return IO { a }
}

// MARK: - Traversable

public func traverse<S, A, B>(
  _ f: @escaping (A) -> IO<B>
  )
  -> (S)
  -> IO<[B]>
  where S: Sequence, S.Element == A {

    return { (xs: S) -> IO<[B]> in
      IO<[B]> { () async -> [B] in
        return await withTaskGroup(of: (Int, B).self, returning: [B].self) { group in
          let xs = Array(xs)
          for (i, x) in zip(xs.indices, xs) {
            group.addTask { (i, await f(x).performAsync()) }
          }
          var ys: [B?] = Array(repeating: nil, count: xs.count)
          while let (i, y) = await group.next() {
            ys[i] = y
          }
          return ys.compactMap { $0 }
        }
      }
    }
}

public func sequence<S, A>(
  _ xs: S
  )
  -> IO<[A]>
  where S: Sequence, S.Element == IO<A> {

    return xs |> traverse(id)
}

// MARK: - Bind/Monad

extension IO {
  public func flatMap<B>(_ f: @escaping (A) -> IO<B>) -> IO<B> {
    return IO<B> {
      await f(self.performAsync()).performAsync()
    }
  }
}

public func flatMap<A, B>(_ f: @escaping (A) -> IO<B>) -> (IO<A>) -> IO<B> {
  return { $0.flatMap(f) }
}

public func >=> <A, B, C>(lhs: @escaping (A) -> IO<B>, rhs: @escaping (B) -> IO<C>) -> (A) -> IO<C> {
  return lhs >>> flatMap(rhs)
}

// MARK: - Semigroup

extension IO: Semigroup where A: Semigroup {
  public static func <> (lhs: IO, rhs: IO) -> IO {
    return curry(<>) <¢> lhs <*> rhs
  }
}

// MARK: - Monoid

extension IO: Monoid where A: Monoid {
  public static var empty: IO {
    return pure(A.empty)
  }
}

@dynamicMemberLookup
fileprivate final class LockIsolated<Value>: @unchecked Sendable {
  private var _value: Value
  private let lock = NSRecursiveLock()

  init(_ value: @autoclosure @Sendable () throws -> Value) rethrows {
    self._value = try value()
  }

  subscript<Subject: Sendable>(dynamicMember keyPath: KeyPath<Value, Subject>) -> Subject {
    self.lock.sync {
      self._value[keyPath: keyPath]
    }
  }

  func withValue<T: Sendable>(
    _ operation: (inout Value) throws -> T
  ) rethrows -> T {
    try self.lock.sync {
      var value = self._value
      defer { self._value = value }
      return try operation(&value)
    }
  }

  func setValue(_ newValue: @autoclosure @Sendable () throws -> Value) rethrows {
    try self.lock.sync {
      self._value = try newValue()
    }
  }
}

extension LockIsolated where Value: Sendable {
  /// The lock-isolated value.
  var value: Value {
    self.lock.sync {
      self._value
    }
  }
}

extension LockIsolated: Equatable where Value: Equatable {
  static func == (lhs: LockIsolated, rhs: LockIsolated) -> Bool {
    lhs.withValue { lhsValue in rhs.withValue { rhsValue in lhsValue == rhsValue } }
  }
}

extension LockIsolated: Hashable where Value: Hashable {
  func hash(into hasher: inout Hasher) {
    self.withValue { hasher.combine($0) }
  }
}

extension NSRecursiveLock {
  @inlinable @discardableResult
  @_spi(Internals) public func sync<R>(work: () throws -> R) rethrows -> R {
    self.lock()
    defer { self.unlock() }
    return try work()
  }
}
