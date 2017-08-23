public protocol Alt {
  static func <|>(lhs: Self, rhs: @autoclosure @escaping () -> Self) -> Self
}

extension Array: Alt {
  public static func <|>(lhs: Array, rhs: @autoclosure @escaping () -> Array) -> Array {
    return lhs + rhs()
  }
}

extension Optional: Alt {
  public static func <|>(lhs: Optional, rhs: @autoclosure @escaping () -> Optional) -> Optional {
    return lhs ?? rhs()
  }
}
