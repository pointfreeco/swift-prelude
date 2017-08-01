public struct Endo<A> {
  public let call: (A) -> A

  public init(_ call: @escaping (A) -> A) {
    self.call = call
  }
}

extension Endo: Monoid {
  public static var empty: Endo<A> {
    return .init(id)
  }

  public static func <>(lhs: Endo<A>, rhs: Endo<A>) -> Endo<A> {
    return .init(lhs.call >>> rhs.call)
  }
}

extension Endo {
  func imap<B>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> A) -> Endo<B> {
    return .init(f <<< self.call <<< g)
  }
}
