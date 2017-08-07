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
