public protocol DerivingEquatable: Encodable, Equatable {}

extension DerivingEquatable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    return EquatableEncoder(lhs: lhs).compare(rhs: rhs)
  }
}

private final class EquatableEncoder<T>: Encoder where T: Encodable {
  let lhs: T

  var comparing = false
  var values: [Any] = []
  lazy var currentIndex = self.values.startIndex

  init(lhs: T) {
    self.lhs = lhs
  }

  func compare(rhs: T) -> Bool {
    do {
      self.values.reserveCapacity(MemoryLayout<T>.size)
      try! self.lhs.encode(to: self)
      self.comparing = true
      try rhs.encode(to: self)
      return true
    } catch {
      return false
    }
  }

  func check<T>(_ value: T) throws where T: Equatable {
    if self.comparing {
      defer { self.currentIndex = self.values.index(after: self.currentIndex) }
      guard
        self.currentIndex < self.values.endIndex,
        let other = self.values[self.currentIndex] as? T,
        other == value else {
          throw EncodingError.invalidValue(value, .init(codingPath: [], debugDescription: "value not equal"))
      }
    } else {
      self.values.append(value)
    }
  }

  let codingPath: [CodingKey] = []
  let userInfo: [CodingUserInfoKey: Any] = [:]

  func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
    return .init(KeyedContainer(encoder: self))
  }

  func unkeyedContainer() -> UnkeyedEncodingContainer {
    return UnkeyedContainer(encoder: self)
  }

  func singleValueContainer() -> SingleValueEncodingContainer {
    return UnkeyedContainer(encoder: self)
  }

  struct KeyedContainer<Key>: KeyedEncodingContainerProtocol where Key: CodingKey {
    let encoder: EquatableEncoder

    let codingPath: [CodingKey] = []

    mutating func encodeNil(forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(unit)
    }

    mutating func encode(_ value: Bool, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Int, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Int8, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Int16, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Int32, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Int64, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: UInt, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: UInt8, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: UInt16, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: UInt32, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: UInt64, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Float, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Double, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode(_ value: String, forKey key: Key) throws {
      try self.encoder.check(key.stringValue)
      try self.encoder.check(value)
    }

    mutating func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
      try self.encoder.check(key.stringValue)
      try value.encode(to: self.encoder)
    }

    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key)
      -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {

        do {
          try self.encoder.check(key.stringValue)
        } catch {
          self.encoder.currentIndex = self.encoder.values.endIndex
        }
        return self.encoder.container(keyedBy: keyType)
    }

    mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
      do {
        try self.encoder.check(key.stringValue)
      } catch {
        self.encoder.currentIndex = self.encoder.values.endIndex
      }
      return self.encoder.unkeyedContainer()
    }

    mutating func superEncoder() -> Encoder {
      return self.encoder
    }

    mutating func superEncoder(forKey key: Key) -> Encoder {
      do {
        try self.encoder.check(key.stringValue)
      } catch {
        self.encoder.currentIndex = self.encoder.values.endIndex
      }
      return self.encoder
    }
  }

  struct UnkeyedContainer: UnkeyedEncodingContainer, SingleValueEncodingContainer {
    let encoder: EquatableEncoder

    let codingPath: [CodingKey] = []
    let count = 0

    mutating func encodeNil() throws {
      try self.encoder.check(unit)
    }

    mutating func encode(_ value: Bool) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Int) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Int8) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Int16) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Int32) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Int64) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: UInt) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: UInt8) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: UInt16) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: UInt32) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: UInt64) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Float) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: Double) throws {
      try self.encoder.check(value)
    }

    mutating func encode(_ value: String) throws {
      try self.encoder.check(value)
    }

    mutating func encode<T>(_ value: T) throws where T: Encodable {
      try value.encode(to: self.encoder)
    }

    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type)
      -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {

        return self.encoder.container(keyedBy: keyType)
    }

    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
      return self.encoder.unkeyedContainer()
    }

    mutating func superEncoder() -> Encoder {
      return self.encoder
    }
  }
}

private struct Unit: Equatable {
  static func ==(lhs: Unit, rhs: Unit) -> Bool {
    return true
  }
}

private let unit = Unit()
