public func replicate(_ n: Int) -> (String) -> String {
  return { str in (1...n).map(const(str)).joined() }
}
