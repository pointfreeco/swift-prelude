public func traversed<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
  return { xs in xs.map(f) }
}

public func traversed<A, B>(_ f: @escaping (A) -> B) -> (A?) -> B? {
  return { x in x.map(f) }
}
