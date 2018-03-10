extension Optional {
  public func filter(_ p: @escaping (Wrapped) -> Bool) -> Optional {
    return self.flatMap { p($0) ? $0 : nil }
  }
}

public func filterMapValues<Key, Value, NewValue>(
  _ f: @escaping (Value) -> NewValue?
  )
  -> ([Key: Value])
  -> [Key: NewValue] {

    return { dict in
      var newDict = [Key: NewValue](minimumCapacity: dict.capacity)
      for (key, value) in dict {
        if let newValue = f(value) {
          newDict[key] = newValue
        }
      }
      return newDict
    }
}

public func filteredValues<Key, Value>(_ dict: [Key: Value?]) -> [Key: Value] {
  return dict |> filterMapValues(id)
}
