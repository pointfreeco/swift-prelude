public func hole<A>() -> A {
  fatalError()
}

public func hole<A, B>(_ a: A) -> B {
  fatalError()
}

public func hole<A, B, C>(_ a: A, _ b: B) -> C {
  fatalError()
}

public func hole<A, B, C, D>(_ a: A, _ b: B, _ c: C) -> D {
  fatalError()
}

public func hole<A, B, C, D, E>(_ a: A, _ b: B, _ c: C, _ d: D) -> E {
  fatalError()
}
