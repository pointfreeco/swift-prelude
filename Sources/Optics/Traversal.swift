import Prelude

// MARK: - Getter

public func traversed<A>(_ f: Forget<A, A, A>) -> Forget<A, [A], [A]> where A: Monoid {
  return .init(foldMap(f.unwrap))
}

public func traversed<A>(_ f: Forget<A, A, A>) -> Forget<A, A?, A?> where A: Monoid {
  return .init(foldMap(f.unwrap))
}

// MARK: - Setter

public func traversed<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
  return { xs in xs.map(f) }
}

public func traversed<A, B>(_ f: @escaping (A) -> B) -> (A?) -> B? {
  return { x in x.map(f) }
}
