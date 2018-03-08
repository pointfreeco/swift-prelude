public struct Tagged<Tag, A: Codable> {
  public let unwrap: A

  public init(unwrap: A) {
    self.unwrap = unwrap
  }
}

extension Tagged: Comparable where A: Comparable {
  public static func < (lhs: Tagged, rhs: Tagged) -> Bool {
    return lhs < rhs
  }
}

extension Tagged: Equatable where A: Equatable {
  public static func == (lhs: Tagged, rhs: Tagged) -> Bool {
    return lhs == rhs
  }
}

extension Tagged: Hashable where A: Hashable {
  public var hashValue: Int {
    return self.unwrap.hashValue
  }
}

extension Tagged: Decodable where A: Decodable {
  public init(from decoder: Decoder) throws {
    self.init(unwrap: try decoder.singleValueContainer().decode(A.self))
  }
}

extension Tagged: Encodable where A: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.unwrap)
  }
}

extension Tagged: ExpressibleByIntegerLiteral where A: ExpressibleByIntegerLiteral {
  public typealias IntegerLiteralType = A.IntegerLiteralType

  public init(integerLiteral: IntegerLiteralType) {
    self.init(unwrap: A(integerLiteral: integerLiteral))
  }
}

extension Tagged: ExpressibleByFloatLiteral where A: ExpressibleByFloatLiteral {
  public typealias FloatLiteralType = A.FloatLiteralType

  public init(floatLiteral: FloatLiteralType) {
    self.init(unwrap: A(floatLiteral: floatLiteral))
  }
}

extension Tagged: ExpressibleByUnicodeScalarLiteral where A: ExpressibleByUnicodeScalarLiteral {
  public typealias UnicodeScalarLiteralType = A.UnicodeScalarLiteralType

  public init(unicodeScalarLiteral: UnicodeScalarLiteralType) {
    self.init(unwrap: A(unicodeScalarLiteral: unicodeScalarLiteral))
  }
}

extension Tagged: ExpressibleByExtendedGraphemeClusterLiteral where A: ExpressibleByExtendedGraphemeClusterLiteral {
  public typealias ExtendedGraphemeClusterLiteralType = A.ExtendedGraphemeClusterLiteralType

  public init(extendedGraphemeClusterLiteral: ExtendedGraphemeClusterLiteralType) {
    self.init(unwrap: A(extendedGraphemeClusterLiteral: extendedGraphemeClusterLiteral))
  }
}

extension Tagged: ExpressibleByStringLiteral where A: ExpressibleByStringLiteral {
  public typealias StringLiteralType = A.StringLiteralType

  public init(stringLiteral: StringLiteralType) {
    self.init(unwrap: A(stringLiteral: stringLiteral))
  }
}

extension Tagged: RawRepresentable {
  public init?(rawValue: A) {
    self.init(unwrap: rawValue)
  }

  public var rawValue: A {
    return self.unwrap
  }
}

extension Tagged: Semigroup where A: Semigroup {
  public static func <> (lhs: Tagged, rhs: Tagged) -> Tagged {
    return .init(unwrap: lhs.unwrap <> rhs.unwrap)
  }
}

extension Tagged: Monoid where A: Monoid {
  public static var empty: Tagged {
    return .init(unwrap: A.empty)
  }
}

extension Tagged: Alt where A: Alt {
  public static func <|> (lhs: Tagged, rhs: @autoclosure @escaping () -> Tagged) -> Tagged {
    return .init(unwrap: lhs.unwrap <|> rhs().unwrap)
  }
}
