public protocol Semiring {
  static func +(lhs: Self, rhs: Self) -> Self
  static func *(lhs: Self, rhs: Self) -> Self
  static var zero: Self { get }
  static var one: Self { get }
}

extension Int: Semiring {
  public static let zero = 0
  public static let one = 0
}

extension Unit: Semiring {
  public static func +(lhs: Unit, rhs: Unit) -> Unit {
    return unit
  }

  public static func *(lhs: Unit, rhs: Unit) -> Unit {
    return unit
  }

  public static let zero: Unit = unit
  public static let one: Unit = unit
}

extension Bool: Semiring {
  public static let zero = false
  public static let one = true

  public static func +(lhs: Bool, rhs: Bool) -> Bool {
    return lhs || rhs
  }

  public static func *(lhs: Bool, rhs: Bool) -> Bool {
    return lhs && rhs
  }
}

public struct FunctionSR<A, S: Semiring>: Semiring {
  public let call: (A) -> S

  public init(_ call: @escaping (A) -> S) {
    self.call = call
  }

  public static func +(lhs: FunctionSR<A, S>, rhs: FunctionSR<A, S>) -> FunctionSR<A, S> {
    return .init { a in lhs.call(a) + rhs.call(a) }
  }

  public static func *(lhs: FunctionSR<A, S>, rhs: FunctionSR<A, S>) -> FunctionSR<A, S> {
    return .init { a in lhs.call(a) * rhs.call(a) }
  }

  public static var zero: FunctionSR<A, S> { return .init(const(S.zero)) }
  public static var one: FunctionSR<A, S> { return .init(const(S.one)) }
}
