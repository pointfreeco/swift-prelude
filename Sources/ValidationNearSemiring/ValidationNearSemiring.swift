import Prelude

public enum Validation<E, A> {
  case valid(A)
  case invalid(E)
}

public extension Validation {
  public func validate<B>(_ e2b: (E) -> B, _ a2b: (A) -> B) -> B {
    switch self {
    case let .valid(a):
      return a2b(a)
    case let .invalid(e):
      return e2b(e)
    }
  }

  public var isValid: Bool {
    return validate(const(false), const(true))
  }
}

public func validate<A, B, C>(_ a2c: @escaping (A) -> C) -> (@escaping (B) -> C) -> (Validation<A, B>) -> C {
  return { b2c in
    { ab in
      ab.validate(a2c, b2c)
    }
  }
}

// MARK: - Functor

extension Validation {
  public func map<B>(_ a2b: (A) -> B) -> Validation<E, B> {
    switch self {
    case let .valid(a):
      return .valid(a2b(a))
    case let .invalid(e):
      return .invalid(e)
    }
  }

  public static func <¢> <B>(a2b: (A) -> B, a: Validation) -> Validation<E, B> {
    return a.map(a2b)
  }
}

public func map<A, B, C>(_ b2c: @escaping (B) -> C)
  -> (Validation<A, B>)
  -> Validation<A, C> {
    return { ab in
      b2c <¢> ab
    }
}

// MARK: - Bifunctor

extension Validation {
  public func bimap<B, C>(_ e2b: (E) -> B, _ a2c: (A) -> C) -> Validation<B, C> {
    switch self {
    case let .valid(a):
      return .valid(a2c(a))
    case let .invalid(e):
      return .invalid(e2b(e))
    }
  }
}

public func bimap<A, B, C, D>(_ a2c: @escaping (A) -> C)
  -> (@escaping (B) -> D)
  -> (Validation<A, B>)
  -> Validation<C, D> {
    return { b2d in
      { ab in
        ab.bimap(a2c, b2d)
      }
    }
}

// MARK: - Apply

extension Validation where E: NearSemiring {
  public func apply<B>(_ a2b: Validation<E, (A) -> B>) -> Validation<E, B> {
    switch (a2b, self) {
    case let (.valid(f), _):
      return self.map(f)
    case let (.invalid(e), .valid):
      return .invalid(e)
    case let (.invalid(e1), .invalid(e2)):
      return .invalid(e1 * e2)
    }
  }

  public static func <*> <B>(a2b: Validation<E, (A) -> B>, a: Validation) -> Validation<E, B> {
    return a.apply(a2b)
  }
}

public func apply<A: NearSemiring, B, C>(_ b2c: Validation<A, (B) -> C>)
  -> (Validation<A, B>)
  -> Validation<A, C> {
    return { ab in
      b2c <*> ab
    }
}

// MARK: - Applicative

public func pure<E, A>(_ a: A) -> Validation<E, A> {
  return .valid(a)
}

// MARK: - Alt

public extension Validation where E: NearSemiring {
  public static func <|> (lhs: Validation, rhs: Validation) -> Validation {
    switch (lhs, rhs) {
    case (.invalid, .valid):
      return rhs
    case let (.invalid(e1), .invalid(e2)):
      return .invalid(e1 + e2)
    default:
      return lhs
    }
  }
}

// MARK: - Eq/Equatable

extension Validation where E: Equatable, A: Equatable {
  public static func == (lhs: Validation, rhs: Validation) -> Bool {
    switch (lhs, rhs) {
    case let (.invalid(e1), .invalid(e2)):
      return e1 == e2
    case let (.valid(a1), .valid(a2)):
      return a1 == a2
    default:
      return false
    }
  }

  public static func != (lhs: Validation, rhs: Validation) -> Bool {
    return !(lhs == rhs)
  }
}

// MARK: - Ord/Comparable

extension Validation where E: Comparable, A: Comparable {
  public static func < (lhs: Validation, rhs: Validation) -> Bool {
    switch (lhs, rhs) {
    case let (.invalid(e1), .invalid(e2)):
      return e1 < e2
    case let (.valid(a1), .valid(a2)):
      return a1 < a2
    case (.invalid, .valid):
      return true
    case (.valid, .invalid):
      return false
    }
  }

  public static func <= (lhs: Validation, rhs: Validation) -> Bool {
    return lhs < rhs || lhs == rhs
  }

  public static func > (lhs: Validation, rhs: Validation) -> Bool {
    return !(lhs <= rhs)
  }

  public static func >= (lhs: Validation, rhs: Validation) -> Bool {
    return lhs > rhs || lhs == rhs
  }
}

// MARK: - Semigroup

extension Validation where E: Semiring, A: Semigroup {
  public static func <> (lhs: Validation, rhs: Validation) -> Validation {
    return curry(<>) <¢> lhs <*> rhs
  }
}
