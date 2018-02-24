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
