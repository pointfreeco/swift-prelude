public func replicate(_ n: Int) -> (String) -> String {
  return { str in (1...n).map(const(str)).joined() }
}

// MARK: - Point-free Standard Library

public func hasPrefix(_ prefix: String) -> (String) -> Bool {
  return { xs in
    xs.hasPrefix(prefix)
  }
}

public func hasSuffix(_ suffix: String) -> (String) -> Bool {
  return { xs in
    xs.hasSuffix(suffix)
  }
}

public func lowercased(_ string: String) -> String {
  return string.lowercased()
}

public func uppercased(_ string: String) -> String {
  return string.uppercased()
}
