extension Set: Semigroup {
  public static func <>(lhs: Set, rhs: Set) -> Set {
    lhs.union(rhs)
  }
}
