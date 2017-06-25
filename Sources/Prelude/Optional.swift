public func optional<A, B>(_ default: B) -> (@escaping (A) -> B) -> (A?) -> B {
  return { a2b in
    { a in
      a.map(a2b) ?? `default`
    }
  }
}

public func coalesce<A>(with default: A) -> (A?) -> A {
  return optional(`default`) <| id
}
