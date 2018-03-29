public protocol Monoid: Semigroup {
  static var empty: Self { get }
}

extension String: Monoid {
  public static let empty = ""
}

extension Array: Monoid {
  public static var empty: Array { return [] }
}

public func joined<M: Monoid>(_ s: M) -> ([M]) -> M {
  return { xs in
    if let head = xs.first {
      return xs.dropFirst().reduce(head) { accum, x in accum <> s <> x }
    }
    return .empty
  }
}

public struct Sum<A: Numeric> {
  public let sum: A

  public init(_ sum: A) {
    self.sum = sum
  }
}

extension Sum: Semigroup {
  public static func <> (lhs: Sum, rhs: Sum) -> Sum {
    return self.init(lhs.sum + rhs.sum)
  }
}

extension Sum: Monoid {
  public static var empty: Sum {
    return 0
  }
}

extension Sum: ExpressibleByIntegerLiteral where A: ExpressibleByIntegerLiteral {
  public typealias IntegerLiteralType = A.IntegerLiteralType

  public init(integerLiteral: IntegerLiteralType) {
    self.init(A(integerLiteral: integerLiteral))
  }
}

extension Sum: ExpressibleByFloatLiteral where A: ExpressibleByFloatLiteral {
  public typealias FloatLiteralType = A.FloatLiteralType

  public init(floatLiteral: FloatLiteralType) {
    self.init(A(floatLiteral: floatLiteral))
  }
}

public struct Product<A: Numeric> {
  public let product: A

  public init(_ product: A) {
    self.product = product
  }
}

extension Product: Semigroup {
  public static func <> (lhs: Product, rhs: Product) -> Product {
    return self.init(lhs.product * rhs.product)
  }
}

extension Product: Monoid {
  public static var empty: Product {
    return 0
  }
}

extension Product: ExpressibleByIntegerLiteral where A: ExpressibleByIntegerLiteral {
  public typealias IntegerLiteralType = A.IntegerLiteralType

  public init(integerLiteral: IntegerLiteralType) {
    self.init(A(integerLiteral: integerLiteral))
  }
}

extension Product: ExpressibleByFloatLiteral where A: ExpressibleByFloatLiteral {
  public typealias FloatLiteralType = A.FloatLiteralType

  public init(floatLiteral: FloatLiteralType) {
    self.init(A(floatLiteral: floatLiteral))
  }
}

public struct All {
  public let all: Bool

  public init(_ all: Bool) {
    self.all = all
  }
}

extension All: Semigroup {
  public static func <> (lhs: All, rhs: All) -> All {
    return self.init(lhs.all && rhs.all)
  }
}

extension All: Monoid {
  public static var empty: All {
    return true
  }
}

extension All: ExpressibleByBooleanLiteral {
  public init(booleanLiteral value: Bool) {
    self.init(value)
  }
}

public struct `Any` {
  public let any: Bool

  public init(_ any: Bool) {
    self.any = any
  }
}

extension `Any`: Semigroup {
  public static func <> (lhs: `Any`, rhs: `Any`) -> `Any` {
    return self.init(lhs.any || rhs.any)
  }
}

extension `Any`: Monoid {
  public static var empty: `Any` {
    return false
  }
}

extension `Any`: ExpressibleByBooleanLiteral {
  public init(booleanLiteral value: Bool) {
    self.init(value)
  }
}
