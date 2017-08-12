// MARK: - Getter

public func ix<C: Collection>(_ idx: C.Index) -> Getter<C, C, C.Element, C.Element> {
  return { forget in
    .init { xs in
      forget.unwrap(xs[idx])
    }
  }
}

public func key<K: Hashable, V>(_ key: K) -> Getter<[K: V], [K: V], V?, V?> {
  return { forget in
    .init { dict in
      forget.unwrap(dict[key])
    }
  }
}

public func elem<A: Hashable>(_ elem: A) -> Getter<Set<A>, Set<A>, Bool, Bool> {
  return { forget in
    .init { set in
      forget.unwrap(set.contains(elem))
    }
  }
}

// MARK: - Setter

public func ix<C: MutableCollection>(_ idx: C.Index) -> Setter<C, C, C.Element, C.Element> {
  return { f in
    { xs in
      var copy = xs
      copy[idx] = f(copy[idx])
      return copy
    }
  }
}

public func key<K: Hashable, V>(_ key: K) -> Setter<[K: V], [K: V], V?, V?> {
  return { f in
    { dict in
      var copy = dict
      copy[key] = f(copy[key])
      return copy
    }
  }
}

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
