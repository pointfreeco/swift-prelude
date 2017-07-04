extension Never: Equatable {
  public static func == (_: Never, _: Never) -> Bool {
    return true
  }
}

extension Unit: Equatable {
  public static func == (_: Unit, _: Unit) -> Bool {
    return true
  }
}

public func equal<A: Equatable>(to a: A) -> (A) -> Bool {
  return curry(==) <| a
}
