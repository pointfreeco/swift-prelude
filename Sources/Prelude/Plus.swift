public protocol Plus: Alt {
  static var empty: Self { get }
}

extension Array: Plus {}

extension Optional: Plus {
  public static var empty: Optional {
    return .none
  }
}
