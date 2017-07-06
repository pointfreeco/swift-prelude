import Prelude

infix operator %~: infixr4
infix operator .~: infixr4

infix operator .^: infixl8

public struct Lens<Root, Value> {
  public let get: (Root) -> Value
  public let set: (Root, Value) -> Root
}

public func .~ <Root, Value>(lens: Lens<Root, Value>, value: Value) -> (Root) -> Root {
  return { root in lens.set(root, value) }
}

public func %~ <Root, Value>(lens: Lens<Root, Value>, over: @escaping (Value) -> Value) -> (Root) -> Root {
  return { root in lens.set(root, over(lens.get(root))) }
}

public func .^ <Root, Value>(root: Root, lens: Lens<Root, Value>) -> Value {
  return lens.get(root)
}

// MARK: Key Paths

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

public func %~ <Root, Value>(keyPath: WritableKeyPath<Root, Value>, over: @escaping (Value) -> Value) -> (Root) -> Root {
  return lens(keyPath) %~ over
}

public func .~ <Root, Value>(keyPath: WritableKeyPath<Root, Value>, value: Value) -> (Root) -> Root {
  return lens(keyPath) .~ value
}

public func .^ <Root, Value>(root: Root, keyPath: WritableKeyPath<Root, Value>) -> Value {
  return root .^ lens(keyPath)
}
