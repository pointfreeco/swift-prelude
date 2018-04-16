// MARK: - Getter

public func elem<A: Hashable>(_ elem: A) -> Getter<Set<A>, Set<A>, Bool, Bool> {
  return { forget in
    .init { set in
      forget.unwrap(set.contains(elem))
    }
  }
}

// MARK: - Setter

public func elem<A: Hashable>(_ elem: A) -> Setter<Set<A>, Set<A>, Bool, Bool> {
  return { f in
    { set in
      var copy = set
      if f(copy.contains(elem)) {
        copy.insert(elem)
      } else {
        copy.remove(elem)
      }
      return copy
    }
  }
}
