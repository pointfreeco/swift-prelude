public struct Tagged<Tag, A: Codable /* FIXME: conditional conformance */> {
  public let unwrap: A

  public init(unwrap: A) {
    self.unwrap = unwrap
  }
}

extension Tagged: Codable /* FIXME: where A: Codable */ {
  public init(from decoder: Decoder) throws {
    self.init(unwrap: try decoder.singleValueContainer().decode(A.self))
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.unwrap)
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
