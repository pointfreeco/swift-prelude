import Prelude

public final class Event<A> {
  private var subs: [(A) -> ()] = []
  private var latest: A?

  public static func create() -> (Event, (A) -> ()) {
    let event = Event()
    return (event, event.push)
  }

  public static var never: Event {
    return Event()
  }

  public static func combine<B>(_ a: Event, _ b: Event<B>) -> Event<(A, B)> {
    return curry({ ($0, $1) }) <¢> a <*> b
  }

  public static func merge(_ es: Event...) -> Event {
    return self.merge(es)
  }

  public static func merge(_ es: [Event]) -> Event {
    let event = Event()
    es.forEach { e in e.subscribe(event.push) }
    return event
  }

  public func filter(_ p: @escaping (A) -> Bool) -> Event {
    let event = Event()
    self.subscribe { a in
      if p(a) {
        event.push(a)
      }
    }
    return event
  }

  public func reduce<B>(_ initialResult: B, _ nextPartialResult: @escaping (B, A) -> B) -> Event<B> {
    let event = Event<B>()
    var latest = initialResult
    self.subscribe { a in
      latest = nextPartialResult(latest, a)
      event.push(latest)
    }
    return event
  }

  public var count: Event<Int> {
    return self.reduce(0) { n, _ in n + 1 }
  }

  public var withLast: Event<(now: A, last: A?)> {
    let event = Event<(now: A, last: A?)>()

    self.subscribe { a in
      event.push((a, self.latest))
    }

    return event
  }

  public func sample<B>(on other: Event<B>) -> Event {
    let event = Event()
    other.subscribe { _ in
      if let a = self.latest {
        event.push(a)
      }
    }
    return event
  }

  public func mapOptional<B>(_ f: @escaping (A) -> B?) -> Event<B> {
    let event = Event<B>()
    self.subscribe { a in
      if let b = f(a) {
        event.push(b)
      }
    }
    return event
  }

  public func skipRepeats(_ f: @escaping (A, A) -> Bool) -> Event {
    return self
      .withLast
      .filter { pair in return pair.last.map { !f(pair.now, $0) } ?? false }
      .map(first)
  }

  public func subscribe(_ f: @escaping (A) -> ()) {
    defer { self.latest.map(f) }
    self.subs.append(f)
  }

  internal func push(_ a: A) {
    defer { self.latest = a }
    self.subs.forEach { sub in sub(a) }
  }
}

extension Event where A: Equatable {
  public func skipRepeats() -> Event {
    return self.skipRepeats(==)
  }
}

public func sample<A, B>(on a: Event<A>) -> (Event<(A) -> B>) -> Event<B> {
  return { a2b in
    let (event, push) = Event<B>.create()

    var latest: A?
    a.subscribe { a in latest = a }
    a2b.subscribe { a2b in
      if let a = latest {
        push(a2b(a))
      }
    }

    return event
  }
}

public func catOptionals<A>(_ a: Event<A?>) -> Event<A> {
  return a |> mapOptional(id)
}

public func mapOptional<A, B>(_ f: @escaping (A) -> B?) -> (Event<A>) -> Event<B> {
  return { a in
    a.mapOptional(f)
  }
}

// MARK: - Functor

extension Event {
  public func map<B>(_ a2b: @escaping (A) -> B) -> Event<B> {
    let event = Event<B>()
    self.subscribe(a2b >>> event.push)
    return event
  }

  public static func <¢> <B>(a2b: @escaping (A) -> B, a: Event<A>) -> Event<B> {
    return a.map(a2b)
  }

  public static func <¢ <B>(a: A, p: Event<B>) -> Event {
    return const(a) <¢> p
  }

  public static func ¢> <B>(p: Event<B>, a: A) -> Event {
    return const(a) <¢> p
  }
}

public func map <A, B>(_ a2b: @escaping (A) -> B) -> (Event<A>) -> Event<B> {
  return curry(<¢>) <| a2b
}

// MARK: - Apply

extension Event {
  public func apply<B>(_ a2b: Event<(A) -> B>) -> Event<B> {
    let (event, push) = Event<B>.create()

    self.subscribe { a in
      if let a2b = a2b.latest {
        push(a2b(a))
      }
    }

    a2b.subscribe { a2b in
      if let a = self.latest {
        push(a2b(a))
      }
    }

    return event
  }

  public static func <*> <B>(a2b: Event<(A) -> B>, a: Event<A>) -> Event<B> {
    return a.apply(a2b)
  }
}

public func apply<A, B>(_ a2b: Event<(A) -> B>) -> (Event<A>) -> Event<B> {
  return curry(<*>) <| a2b
}

// MARK: - Applicative

public func pure<A>(_ a: A) -> Event<A> {
  let (event, push) = Event<A>.create()
  push(a)
  return event
}

// MARK: - Alt

extension Event: Alt {
  public static func <|>(lhs: Event, rhs: Event) -> Event {
    return .merge(lhs, rhs)
  }
}

// MARK: - Semigroup

extension Event /* : Semigroup */ where A: Semigroup {
  public static func <>(lhs: Event, rhs: Event) -> Event {
    return curry(<>) <¢> lhs <*> rhs
  }
}

// MARK: - Monoid

extension Event /* : Monoid */ where A: Monoid {
  public static var empty: Event {
    return pure(A.empty)
  }

  public func concat() -> Event {
    return self.reduce(A.empty) { $0 <> $1 }
  }
}
