@testable import Either
import Foundation
@testable import Prelude
@testable import Tuple

extension Tuple: Codable where A: Codable, B: Codable {
  public init(from decoder: Decoder) throws {
    self.first = try A(from: decoder)
    self.second = try B(from: decoder)
  }

  public func encode(to encoder: Encoder) throws {
    try self.first.encode(to: encoder)
    try self.second.encode(to: encoder)
  }
}

public struct Row<Name, Value: Codable>: Codable {
  struct CodingKeys: CodingKey {
    var stringValue: String

    init(stringValue: String) {
      self.stringValue = stringValue
    }

    var intValue: Int? { nil }
    init?(intValue: Int) { nil }
  }

  let value: Value
  init(_ value: Value) {
    self.value = value
  }

  init(_ name: Name.Type, _ value: Value) {
    self.value = value
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.value = try container.decode(Value.self, forKey: .init(stringValue: String(describing: Name.self)))
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.value, forKey: .init(stringValue: String(describing: Name.self)))
  }
}

extension Tuple where B == Prelude.Unit {
  public init(_ a: A) {
    self.init(first: a, second: unit)
  }
}

extension Tuple {
  public init<B>(_ a: A, _ b: B) where Tuple == Tuple2<A, B> {
    self.init(first: a, second: Tuple1(b))
  }
  public init<B, C>(_ a: A, _ b: B, _ c: C) where Tuple == Tuple3<A, B, C> {
    self.init(first: a, second: Tuple2(b, c))
  }
  public init<B, C, D>(_ a: A, _ b: B, _ c: C, _ d: D) where Tuple == Tuple4<A, B, C, D> {
    self.init(first: a, second: Tuple3(b, c, d))
  }
  public init<B, C, D, E>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) where Tuple == Tuple5<A, B, C, D, E> {
    self.init(first: a, second: Tuple4(b, c, d, e))
  }
  public init<B, C, D, E, F>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) where Tuple == Tuple6<A, B, C, D, E, F> {
    self.init(first: a, second: Tuple5(b, c, d, e, f))
  }
}

extension Tuple {
  public subscript<K, V>(_ key: K.Type) -> V where Tuple == T2<Row<K, V>, B> {
    return self |> get1 >>> ^\.value
  }
  public subscript<K, V, Z>(_ key: K.Type) -> V where Tuple == T3<A, Row<K, V>, Z> {
    return self |> get2 >>> ^\.value
  }
  public subscript<K, B, V, Z>(_ key: K.Type) -> V where Tuple == T4<A, B, Row<K, V>, Z> {
    return self |> get3 >>> ^\.value
  }
  public subscript<K, B, C, V, Z>(_ key: K.Type) -> V where Tuple == T5<A, B, C, Row<K, V>, Z> {
    return self |> get4 >>> ^\.value
  }
  public subscript<K, B, C, D, V, Z>(_ key: K.Type) -> V where Tuple == T6<A, B, C, D, Row<K, V>, Z> {
    return self |> get5 >>> ^\.value
  }
  public subscript<K, B, C, D, E, V, Z>(_ key: K.Type) -> V where Tuple == T7<A, B, C, D, E, Row<K, V>, Z> {
    return self |> get6 >>> ^\.value
  }
}

typealias R1<K, V, Z> = T2<Row<K, V>, Z> where V: Codable
typealias R2<K1, V1, K2, V2, Z> = T3<Row<K1, V1>, Row<K2, V2>, Z> where V1: Codable, V2: Codable
typealias R3<K1, V1, K2, V2, K3, V3, Z> = T4<Row<K1, V1>, Row<K2, V2>, Row<K3, V3>, Z> where V1: Codable, V2: Codable, V3: Codable

typealias Row1<K, V> = R1<K, V, Prelude.Unit> where V: Codable
typealias Row2<K1, V1, K2, V2> = R2<K1, V1, K2, V2, Prelude.Unit> where V1: Codable, V2: Codable
typealias Row3<K1, V1, K2, V2, K3, V3> = R3<K1, V1, K2, V2, K3, V3, Prelude.Unit> where V1: Codable, V2: Codable, V3: Codable

extension Row: CustomStringConvertible {
  public var description: String {
    "\(Name.self): \(self.value)"
  }
}

extension Tuple: CustomStringConvertible {
  public var description: String {
    "\(self.first), \(self.second)"
  }
}

extension Prelude.Unit: CustomStringConvertible {
  public var description: String {
    "()"
  }
}

// --

enum id {}
enum name {}
enum title {}

typealias User = Row2<
  id, Int,
  name, String
>

let myUser = User(
  Row(id.self, 1),
  Row(name.self, "Blob")
)

func giveTitle<Z>(_ data: R2<id, Int, name, String, Z>) -> R3<id, Int, name, String, title, String, Z> {
  
    data.first
      .*. data.second.first
      .*. Row(title.self, "#\(data[id.self]) - \(data[name.self])")
      .*. rest(data)
//  return "#\(data[id.self]) - \(data[name.self])"
}

giveTitle(myUser)

let json = try! JSONEncoder().encode(myUser)
String(decoding: json, as: UTF8.self)

let hasId = try! JSONDecoder()
  .decode(Row1<id, Int>.self, from: json)
hasId[id.self]

let hasName = try! JSONDecoder()
  .decode(Row1<name, String>.self, from: json)
hasName[name.self]
