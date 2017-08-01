public struct Forget<R, A, B> {
  public let unwrap: (A) -> R

  public init(_ unwrap: @escaping (A) -> R) {
    self.unwrap = unwrap
  }
}
