public func coalesce<A>(with `default`: A) -> (A?) -> A {
  return { x in x ?? `default` }
}
