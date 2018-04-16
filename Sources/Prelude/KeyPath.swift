public func get<Root, Value>(_ keyPath: KeyPath<Root, Value>) -> (Root) -> Value {
  return { root in
    root[keyPath: keyPath]
  }
}

public func over<Root, Value>(_ keyPath: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root)
  -> Root {

    return { over in
      { root in
        var copy = root
        copy[keyPath: keyPath] = over(copy[keyPath: keyPath])
        return copy
      }
    }
}

public func set<Root, Value>(_ keyPath: WritableKeyPath<Root, Value>) -> (Value) -> (Root) -> Root {
  return over(keyPath) <<< const
}

prefix operator ^

extension KeyPath {
  public static prefix func ^ (rhs: KeyPath) -> (Root) -> Value {
    return get(rhs)
  }
}

extension WritableKeyPath {
  public static prefix func ^ (rhs: WritableKeyPath)
    -> (@escaping (Value) -> Value)
    -> (Root) -> Root {

      return over(rhs)
  }
}
