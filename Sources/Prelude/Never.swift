extension Never: Error {}

public func absurd<A>(_ never: Never) -> A {
  switch never {}
}
