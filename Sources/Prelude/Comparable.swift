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
  return curry(A.compare) <| a
}

extension Bool: Comparable {
  public static func < (lhs: Bool, rhs: Bool) -> Bool {
    return (lhs, rhs) == (false, true)
  }
}

extension Never: Comparable {
  public static func < (_: Never, _: Never) -> Bool {
    return false
  }
}

extension Unit: Comparable {
  public static func < (_: Unit, _: Unit) -> Bool {
    return false
  }
}

public func lessThan<A: Comparable>(_ a: A) -> (A) -> Bool {
  return flip(curry(<)) <| a
}

public func lessThanOrEqual<A: Comparable>(to a: A) -> (A) -> Bool {
  return flip(curry(<=)) <| a
}

public func greaterThan<A: Comparable>(_ a: A) -> (A) -> Bool {
  return flip(curry(>)) <| a
}

public func greaterThanOrEqual<A: Comparable>(to a: A) -> (A) -> Bool {
  return flip(curry(>=)) <| a
}

public func < <A, B: Comparable>(f: @escaping (A) -> B, x: B) -> (A) -> Bool {
  return f >>> lessThan(x)
}

public func <= <A, B: Comparable>(f: @escaping (A) -> B, x: B) -> (A) -> Bool {
  return f >>> lessThanOrEqual(to: x)
}

public func > <A, B: Comparable>(f: @escaping (A) -> B, x: B) -> (A) -> Bool {
  return f >>> greaterThan(x)
}

public func >= <A, B: Comparable>(f: @escaping (A) -> B, x: B) -> (A) -> Bool {
  return f >>> greaterThanOrEqual(to: x)
}

public func clamp<T>(_ to: CountableRange<T>) -> (T) -> T {
  return { element in
    min(to.upperBound, max(to.lowerBound, element))
  }
}

public func clamp<T>(_ to: Range<T>) -> (T) -> T {
  return { element in
    min(to.upperBound, max(to.lowerBound, element))
  }
}
