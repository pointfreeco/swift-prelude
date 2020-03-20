public func replicate(_ n: Int) -> (String) -> String {
  { str in (1...n).map(const(str)).joined() }
}

// MARK: - Point-free Standard Library

public func hasPrefix(_ prefix: String) -> (String) -> Bool {
  { xs in
    xs.hasPrefix(prefix)
  }
}

public func hasSuffix(_ suffix: String) -> (String) -> Bool {
  { xs in
    xs.hasSuffix(suffix)
  }
}

public func lowercased(_ string: String) -> String {
  string.lowercased()
}

public func uppercased(_ string: String) -> String {
  string.uppercased()
}
