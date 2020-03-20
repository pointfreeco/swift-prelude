extension Comparable {
  public static func compare(_ x: Self, _ y: Self) -> Comparator {
    if x == y {
      return .eq
    } else if x < y {
      return .lt
    } else { // x > y
      return .gt
    }
  }
}

public func compare<A: Comparable>(_ a: A) -> (A) -> Comparator {
  curry(A.compare) <| a
}

extension Bool: Comparable {
  public static func < (lhs: Bool, rhs: Bool) -> Bool {
    (lhs, rhs) == (false, true)
  }
}

extension Unit: Comparable {
  public static func < (_: Unit, _: Unit) -> Bool {
    false
  }
}

public func lessThan<A: Comparable>(_ a: A) -> (A) -> Bool {
  flip(curry(<)) <| a
}

public func lessThanOrEqual<A: Comparable>(to a: A) -> (A) -> Bool {
  flip(curry(<=)) <| a
}

public func greaterThan<A: Comparable>(_ a: A) -> (A) -> Bool {
  flip(curry(>)) <| a
}

public func greaterThanOrEqual<A: Comparable>(to a: A) -> (A) -> Bool {
  flip(curry(>=)) <| a
}

public func < <A, B: Comparable>(f: @escaping (A) -> B, x: B) -> (A) -> Bool {
  f >>> lessThan(x)
}

public func <= <A, B: Comparable>(f: @escaping (A) -> B, x: B) -> (A) -> Bool {
  f >>> lessThanOrEqual(to: x)
}

public func > <A, B: Comparable>(f: @escaping (A) -> B, x: B) -> (A) -> Bool {
  f >>> greaterThan(x)
}

public func >= <A, B: Comparable>(f: @escaping (A) -> B, x: B) -> (A) -> Bool {
  f >>> greaterThanOrEqual(to: x)
}

public func clamp<T>(_ to: CountableRange<T>) -> (T) -> T {
  { element in
    min(to.upperBound, max(to.lowerBound, element))
  }
}

public func clamp<T>(_ to: Range<T>) -> (T) -> T {
  { element in
    min(to.upperBound, max(to.lowerBound, element))
  }
}

public func their<A, B>(_ f: @escaping (A) -> B, _ g: @escaping (B, B) -> Bool) -> (A, A) -> Bool {
  { g(f($0), f($1)) }
}

public func their<A, B: Comparable>(_ f: @escaping (A) -> B) -> (A, A) -> Bool {
  their(f, <)
}
