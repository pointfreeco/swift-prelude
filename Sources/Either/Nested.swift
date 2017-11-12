public typealias E2<A, Z> = Either<A, Z>
public typealias E3<A, B, Z> = Either<A, E2<B, Z>>
public typealias E4<A, B, C, Z> = Either<A, E3<B, C, Z>>
public typealias E5<A, B, C, D, Z> = Either<A, E4<B, C, D, Z>>
public typealias E6<A, B, C, D, E, Z> = Either<A, E5<B, C, D, E, Z>>
public typealias E7<A, B, C, D, E, F, Z> = Either<A, E6<B, C, D, E, F, Z>>

public typealias Either1<A> = E2<A, Never>
public typealias Either2<A, B> = E3<A, B, Never>
public typealias Either3<A, B, C> = E4<A, B, C, Never>
public typealias Either4<A, B, C, D> = E5<A, B, C, D, Never>
public typealias Either5<A, B, C, D, E> = E6<A, B, C, D, E, Never>
public typealias Either6<A, B, C, D, E, F> = E7<A, B, C, D, E, F, Never>

public func inj1<A, Z>(_ v: A) -> E2<A, Z> {
  return .left(v)
}

public func inj2<A, B, Z>(_ v: B) -> E3<A, B, Z> {
  return .right(.left(v))
}

public func inj3<A, B, C, Z>(_ v: C) -> E4<A, B, C, Z> {
  return .right(.right(.left(v)))
}

public func inj4<A, B, C, D, Z>(_ v: D) -> E5<A, B, C, D, Z> {
  return .right(.right(.right(.left(v))))
}

public func inj5<A, B, C, D, E, Z>(_ v: E) -> E6<A, B, C, D, E, Z> {
  return .right(.right(.right(.right(.left(v)))))
}

public func inj6<A, B, C, D, E, F, Z>(_ v: F) -> E7<A, B, C, D, E, F, Z> {
  return .right(.right(.right(.right(.right(.left(v))))))
}

public func get1<A, Z>(_ e: E2<A, Z>) -> A? {
  if case let .left(v) = e { return v }
  return nil
}

public func get2<A, B, Z>(_ e: E3<A, B, Z>) -> B? {
  if case let .right(.left(v)) = e { return v }
  return nil
}

public func get3<A, B, C, Z>(_ e: E4<A, B, C, Z>) -> C? {
  if case let .right(.right(.left(v))) = e { return v }
  return nil
}

public func get4<A, B, C, D, Z>(_ e: E5<A, B, C, D, Z>) -> D? {
  if case let .right(.right(.right(.left(v)))) = e { return v }
  return nil
}

public func get5<A, B, C, D, E, Z>(_ e: E6<A, B, C, D, E, Z>) -> E? {
  if case let .right(.right(.right(.right(.left(v))))) = e { return v }
  return nil
}

public func get6<A, B, C, D, E, F, Z>(_ e: E7<A, B, C, D, E, F, Z>) -> F? {
  if case let .right(.right(.right(.right(.right(.left(v)))))) = e { return v }
  return nil
}

public func at1<A, R, Z>(_ v: R, _ f: @escaping (A) -> R) -> (E2<A, Z>) -> R {
  return { get1($0).map(f) ?? v }
}

public func at2<A, B, R, Z>(_ v: R, _ f: @escaping (B) -> R) -> (E3<A, B, Z>) -> R {
  return { get2($0).map(f) ?? v }
}

public func at3<A, B, C, R, Z>(_ v: R, _ f: @escaping (C) -> R) -> (E4<A, B, C, Z>) -> R {
  return { get3($0).map(f) ?? v }
}

public func at4<A, B, C, D, R, Z>(_ v: R, _ f: @escaping (D) -> R) -> (E5<A, B, C, D, Z>) -> R {
  return { get4($0).map(f) ?? v }
}

public func at5<A, B, C, D, E, R, Z>(_ v: R, _ f: @escaping (E) -> R) -> (E6<A, B, C, D, E, Z>) -> R {
  return { get5($0).map(f) ?? v }
}

public func at6<A, B, C, D, E, F, R, Z>(_ v: R, _ f: @escaping (F) -> R) -> (E7<A, B, C, D, E, F, Z>) -> R {
  return { get6($0).map(f) ?? v }
}

public func == <A: Equatable, B: Equatable> (lhs: Either2<A, B>, rhs: Either2<A, B>) -> Bool {

  switch (lhs, rhs) {
  case let (.left(lhs), .left(rhs)):
    return lhs == rhs
  case let (.right(lhs), .right(rhs)):
    return lhs == rhs
  case (.left, .right), (.right, .left):
    return false
  }
}
public func == <A: Equatable, B: Equatable, C: Equatable> (
  lhs: Either3<A, B, C>,
  rhs: Either3<A, B, C>
  ) -> Bool {

  switch (lhs, rhs) {
  case let (.left(lhs), .left(rhs)):
    return lhs == rhs
  case let (.right(lhs), .right(rhs)):
    return lhs == rhs
  case (.left, .right), (.right, .left):
    return false
  }
}
public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable> (
  lhs: Either4<A, B, C, D>,
  rhs: Either4<A, B, C, D>
  ) -> Bool {

  switch (lhs, rhs) {
  case let (.left(lhs), .left(rhs)):
    return lhs == rhs
  case let (.right(lhs), .right(rhs)):
    return lhs == rhs
  case (.left, .right), (.right, .left):
    return false
  }
}
public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable> (
  lhs: Either5<A, B, C, D, E>,
  rhs: Either5<A, B, C, D, E>
  ) -> Bool {

  switch (lhs, rhs) {
  case let (.left(lhs), .left(rhs)):
    return lhs == rhs
  case let (.right(lhs), .right(rhs)):
    return lhs == rhs
  case (.left, .right), (.right, .left):
    return false
  }
}
public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable> (
  lhs: Either6<A, B, C, D, E, F>,
  rhs: Either6<A, B, C, D, E, F>
  ) -> Bool {

  switch (lhs, rhs) {
  case let (.left(lhs), .left(rhs)):
    return lhs == rhs
  case let (.right(lhs), .right(rhs)):
    return lhs == rhs
  case (.left, .right), (.right, .left):
    return false
  }
}



public func _destructure<A, B, Z>(
  _ either: E2<A, Z>,
  _ a2b: (A) -> B
  )
  -> B {
    switch either {
    case let .left(a):
      return a2b(a)
    case .right:
      fatalError()
    }
}
public func _destructure<A, B, C, Z>(
  _ either: E3<A, B, Z>,
  _ a2c: (A) -> C,
  _ b2c: (B) -> C
  )
  -> C {
    switch either {
    case let .left(a):
      return a2c(a)
    case let .right(.left(b)):
      return b2c(b)
    case .right:
      fatalError()
    }
}
public func _destructure<A, B, C, D, Z>(
  _ either: E4<A, B, C, Z>,
  _ a2d: (A) -> D,
  _ b2d: (B) -> D,
  _ c2d: (C) -> D
  )
  -> D {
    switch either {
    case let .left(a):
      return a2d(a)
    case let .right(.left(b)):
      return b2d(b)
    case let .right(.right(.left(c))):
      return c2d(c)
    case .right:
      fatalError()
    }
}




public func destructure<A, B>(
  _ either: Either1<A>,
  _ a2b: (A) -> B
  )
  -> B {
    switch either {
    case let .left(a):
      return a2b(a)
    }
}

public func destructure<A, B, C>(
  _ either: Either2<A, B>,
  _ a2c: (A) -> C,
  _ b2c: (B) -> C
  )
  -> C {
    switch either {
    case let .left(a):
      return a2c(a)
    case let .right(.left(b)):
      return b2c(b)
    }
}

public func destructure<A, B, C, D>(
  _ either: Either3<A, B, C>,
  _ a2d: (A) -> D,
  _ b2d: (B) -> D,
  _ c2d: (C) -> D
  )
  -> D {
    switch either {
    case let .left(a):
      return a2d(a)
    case let .right(.left(b)):
      return b2d(b)
    case let .right(.right(.left(c))):
      return c2d(c)
    }
}

public func destructure<A, B, C, D, E>(
  _ either: Either4<A, B, C, D>,
  _ a2e: (A) -> E,
  _ b2e: (B) -> E,
  _ c2e: (C) -> E,
  _ d2e: (D) -> E
  )
  -> E {
    switch either {
    case let .left(a):
      return a2e(a)
    case let .right(.left(b)):
      return b2e(b)
    case let .right(.right(.left(c))):
      return c2e(c)
    case let .right(.right(.right(.left(d)))):
      return d2e(d)
    }
}

public func destructure<A, B, C, D, E, F>(
  _ either: Either5<A, B, C, D, E>,
  _ a2f: (A) -> F,
  _ b2f: (B) -> F,
  _ c2f: (C) -> F,
  _ d2f: (D) -> F,
  _ e2f: (E) -> F
  )
  -> F {
    switch either {
    case let .left(a):
      return a2f(a)
    case let .right(.left(b)):
      return b2f(b)
    case let .right(.right(.left(c))):
      return c2f(c)
    case let .right(.right(.right(.left(d)))):
      return d2f(d)
    case let .right(.right(.right(.right(.left(e))))):
      return e2f(e)
    }
}

public func destructure<A, B, C, D, E, F, G>(
  _ either: Either6<A, B, C, D, E, F>,
  _ a2g: (A) -> G,
  _ b2g: (B) -> G,
  _ c2g: (C) -> G,
  _ d2g: (D) -> G,
  _ e2g: (E) -> G,
  _ f2g: (F) -> G
  )
  -> G {
    switch either {
    case let .left(a):
      return a2g(a)
    case let .right(.left(b)):
      return b2g(b)
    case let .right(.right(.left(c))):
      return c2g(c)
    case let .right(.right(.right(.left(d)))):
      return d2g(d)
    case let .right(.right(.right(.right(.left(e))))):
      return e2g(e)
    case let .right(.right(.right(.right(.right(.left(f)))))):
      return f2g(f)
    }
}





public func embed1<A, B, Z>(_ e: Either1<A>) -> E3<A, B, Z> {
  return destructure(e, inj1)
}
public func embed2<A, B, C, Z>(_ e: Either2<A, B>) -> E4<A, B, C, Z> {
  return destructure(e, inj1, inj2)
}
public func embed3<A, B, C, D, Z>(_ e: Either3<A, B, C>) -> E5<A, B, C, D, Z> {
  return destructure(e, inj1, inj2, inj3)
}


