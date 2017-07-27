extension Set: Semigroup {
  public static func <>(lhs: Set, rhs: Set) -> Set {
    return lhs.union(rhs)
  }
}
