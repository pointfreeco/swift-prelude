import Prelude

infix operator %~: infixr4 // over
infix operator .~: infixr4 // set
infix operator +~: infixr4 // addOver
infix operator -~: infixr4 // subOver
infix operator *~: infixr4 // mulOver
infix operator /~: infixr4 // divOver
infix operator ||~: infixr4 // disjOver
infix operator &&~: infixr4 // conjOver
infix operator <>~: infixr4 // appendOver

infix operator .^: infixl8 // viewOn

// MARK: - Lens

public struct Lens<Root, Value> {
  public let get: (Root) -> Value
  public let set: (Root, Value) -> Root
}

// Composition

extension Lens {
  public static func <<< <NextValue>(lhs: Lens, rhs: Lens<Value, NextValue>) -> Lens<Root, NextValue> {
    return .init(
      get: lhs.get >>> rhs.get,
      set: { root, nextValue in lhs.set(root, rhs.set(lhs.get(root), nextValue)) }
    )
  }
}

// Setter

extension Lens {
  public static func %~(lens: Lens, over: @escaping (Value) -> Value) -> (Root) -> Root {
    return { root in lens.set(root, over(lens.get(root))) }
  }

  public static func .~(lens: Lens, value: Value) -> (Root) -> Root {
    return lens %~ const(value)
  }
}

extension Lens where Value: NearSemiring {
  public static func +~(lens: Lens, value: Value) -> (Root) -> Root {
    return lens %~ { $0 + value }
  }

  public static func *~(lens: Lens, value: Value) -> (Root) -> Root {
    return lens %~ { $0 * value }
  }
}

extension Lens where Value: Ring {
  public static func -~(lens: Lens, value: Value) -> (Root) -> Root {
    return lens %~ { $0 - value }
  }
}

extension Lens where Value: EuclideanRing {
  public static func /~(lens: Lens, value: Value) -> (Root) -> Root {
    return lens %~ { $0 / value }
  }
}

extension Lens where Value: HeytingAlgebra {
  public static func ||~(lens: Lens, value: Value) -> (Root) -> Root {
    return lens %~ { try! $0 || value }
  }

  public static func &&~(lens: Lens, value: Value) -> (Root) -> Root {
    return lens %~ { try! $0 && value }
  }
}

extension Lens where Value: Semigroup {
  public static func <>~(lens: Lens, value: Value) -> (Root) -> Root {
    return lens %~ { $0 <> value }
  }
}

// Getter

extension Lens {
  public static func .^(root: Root, lens: Lens) -> Value {
    return lens.get(root)
  }
}

// MARK: - Key Paths

public func lens<Root, Value>(_ keyPath: WritableKeyPath<Root, Value>) -> Lens<Root, Value> {
  return Lens<Root, Value>(
    get: { root in
      root[keyPath: keyPath]
    },
    set: { root, value in
      var copy = root
      copy[keyPath: keyPath] = value
      return copy
    }
  )
}

// MARK: Composition

extension WritableKeyPath {
  public static func <<< <NextValue>(lhs: WritableKeyPath, rhs: WritableKeyPath<Value, NextValue>)
    -> WritableKeyPath<Root, NextValue> {
    return lhs.appending(path: rhs)
  }
}

// MARK: Setter

// (Overrides required (vs. a protocol with extensions) to allow for shorthand key path syntax.)

extension WritableKeyPath {
  public static func %~(keyPath: WritableKeyPath, over: @escaping (Value) -> Value) -> (Root) -> Root {
    return lens(keyPath) %~ over
  }

  public static func .~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return lens(keyPath) .~ value
  }
}

extension WritableKeyPath where Value: NearSemiring {
  public static func +~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return lens(keyPath) +~ value
  }

  public static func *~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return lens(keyPath) *~ value
  }
}

extension WritableKeyPath where Value: Ring {
  public static func -~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return lens(keyPath) -~ value
  }
}

extension WritableKeyPath where Value: EuclideanRing {
  public static func /~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return lens(keyPath) /~ value
  }
}

extension WritableKeyPath where Value: HeytingAlgebra {
  public static func ||~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return lens(keyPath) ||~ value
  }

  public static func &&~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return lens(keyPath) &&~ value
  }
}

extension WritableKeyPath where Value: Semigroup {
  public static func <>~(keyPath: WritableKeyPath, value: Value) -> (Root) -> Root {
    return lens(keyPath) <>~ value
  }
}

// Getter

extension WritableKeyPath {
  public static func .^(root: Root, keyPath: WritableKeyPath) -> Value {
    return root .^ lens(keyPath)
  }
}
