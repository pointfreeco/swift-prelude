public func uncons<C: Collection>(_ xs: C) -> (C.Element, C.SubSequence)? {
  guard let head = xs.first else { return nil }
  return (head, xs.dropFirst())
}

public func unsnoc<C: BidirectionalCollection>(_ xs: C) -> (C.SubSequence, C.Element)? {
  guard let last = xs.last else { return nil }
  return (xs.dropLast(), last)
}
