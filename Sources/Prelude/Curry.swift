public func curry<A, B, C>(_ f: @escaping (A, B) -> C)
  -> (A)
  -> (B)
  -> C {
    return { a in
      { b in
        f(a, b)
      }
    }
}

public func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D)
  -> (A)
  -> (B)
  -> (C)
  -> D {
    return { a in
      { b in
        { c in
          f(a, b, c)
        }
      }
    }
}

public func curry<A, B, C, D, E>(_ f: @escaping (A, B, C, D) -> E)
  -> (A)
  -> (B)
  -> (C)
  -> (D)
  -> E {
    return { a in
      { b in
        { c in
          { d in
            f(a, b, c, d)
          }
        }
      }
    }
}

public func curry<A, B, C, D, E, F>(_ f: @escaping (A, B, C, D, E) -> F)
  -> (A)
  -> (B)
  -> (C)
  -> (D)
  -> (E)
  -> (F) {
    return { a in
      { b in
        { c in
          { d in
            { e in
              f(a, b, c, d, e)
            }
          }
        }
      }
    }
}

public func uncurry<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (A, B) -> C {
  return { a, b in
    f(a)(b)
  }
}
