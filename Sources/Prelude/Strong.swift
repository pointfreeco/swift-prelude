public func first<A, B, C>(_ a2b: @escaping (A) -> B) -> ((A, C)) -> (B, C) {
  return { ac in (a2b(ac.0), ac.1) }
}

public func second<A, B, C>(_ b2c: @escaping (B) -> C) -> ((A, B)) -> (A, C) {
  return { ab in (ab.0, b2c(ab.1)) }
}
