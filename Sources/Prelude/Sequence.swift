public func <¢> <A, S: Sequence>(f: (S.Element) -> A, xs: S) -> [A] {
  return xs.map(f)
}

public func >>- <S: Sequence, T: Sequence>(f: (S.Element) -> T, xs: S) -> [T.Element] {
  return xs.flatMap(f)
}

public func catOptionals<S: Sequence, A>(_ xs: S) -> [A] where S.Element == A? {
  return xs |> mapOptional(id)
}

public func mapOptional<S: Sequence, A>(_ f: @escaping (S.Element) -> A?) -> (S) -> [A] {
  return { xs in
    xs.flatMap(f)
  }
}

// MARK: - Point-free Standard Library

public func contains<S: Sequence>(_ x: S.Element) -> (S) -> Bool where S.Element: Equatable {
  return { xs in
    xs.contains(x)
  }
}

public func contains<S: Sequence>(where p: @escaping (S.Element) -> Bool) -> (S) -> Bool {
  return { xs in
    xs.contains(where: p)
  }
}

public func drop<S: Sequence>(while p: @escaping (S.Element) -> Bool) -> (S) -> S.SubSequence {
  return { xs in
    xs.drop(while: p)
  }
}

public func dropFirst<S: Sequence>(_ xs: S) -> S.SubSequence {
  return xs.dropFirst()
}

public func dropFirst<S: Sequence>(_ n: Int) -> (S) -> S.SubSequence {
  return { xs in
    xs.dropFirst(n)
  }
}

public func dropLast<S: Sequence>(_ xs: S) -> S.SubSequence {
  return xs.dropLast()
}

public func dropLast<S: Sequence>(_ n: Int) -> (S) -> S.SubSequence {
  return { xs in
    xs.dropLast(n)
  }
}

public func filter<S: Sequence>(_ p: @escaping (S.Element) -> Bool) -> (S) -> [S.Element] {
  return { xs in
    xs.filter(p)
  }
}

public func flatMap<S: Sequence, T: Sequence>(_ f: @escaping (S.Element) -> T) -> (S) -> [T.Element] {
  return { xs in
    xs.flatMap(f)
  }
}

public func forEach<S: Sequence>(_ f: @escaping (S.Element) -> ()) -> (S) -> () {
  return { xs in
    xs.forEach(f)
  }
}

public func map<A, S: Sequence>(_ f: @escaping (S.Element) -> A) -> (S) -> [A] {
  return { xs in
    xs.map(f)
  }
}

public func prefix<S: Sequence>(_ n: Int) -> (S) -> S.SubSequence {
  return { xs in
    xs.prefix(n)
  }
}

public func prefix<S: Sequence>(while p: @escaping (S.Element) -> Bool) -> (S) -> S.SubSequence {
  return { xs in
    xs.prefix(while: p)
  }
}

public func reduce<A, S: Sequence>(_ f: @escaping (A, S.Element) -> A) -> (A) -> (S) -> A {
  return { a in
    { xs in
      xs.reduce(a, f)
    }
  }
}

public func suffix<S: Sequence>(_ n: Int) -> (S) -> S.SubSequence {
  return { xs in
    xs.suffix(n)
  }
}
