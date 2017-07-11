public func replicate(_ n: Int) -> (String) -> String {
  return { str in (1...n).map(const(str)).joined() }
}

// MARK: - Point-free Standard Library

func hasPrefix(_ prefix: String) -> (String) -> Bool {
  return { xs in
    xs.hasPrefix(prefix)
  }
}

func hasSuffix(_ suffix: String) -> (String) -> Bool {
  return { xs in
    xs.hasSuffix(suffix)
  }
}
