extension Unit: Equatable {
  public static func == (_: Unit, _: Unit) -> Bool {
    return true
  }
}

public func equal<A: Equatable>(to a: A) -> (A) -> Bool {
  return curry(==) <| a
}

public func == <A, B: Equatable>(f: @escaping (A) -> B, g: @escaping (A) -> B) -> (A) -> Bool {
  return { a in f(a) == g(a) }
}

public func != <A, B: Equatable>(f: @escaping (A) -> B, g: @escaping (A) -> B) -> (A) -> Bool {
  return { a in f(a) != g(a) }
}

public func == <A, B: Equatable>(f: @escaping (A) -> B, x: B) -> (A) -> Bool {
  return f == const(x)
}

public func != <A, B: Equatable>(f: @escaping (A) -> B, x: B) -> (A) -> Bool {
  return f != const(x)
}
