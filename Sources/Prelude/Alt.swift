public protocol Alt {
  static func <|>(lhs: Self, rhs: Self) -> Self
}

extension Array: Alt {
  public static func <|>(lhs: Array, rhs: Array) -> Array {
    return lhs + rhs
  }
}

extension Optional: Alt {
  public static func <|>(lhs: Optional, rhs: Optional) -> Optional {
    return lhs ?? rhs
  }
}
