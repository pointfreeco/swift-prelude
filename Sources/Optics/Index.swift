public func ix<C: Collection>(_ idx: C.Index) -> Getter<C, C, C.Element, C.Element> {
  return { (forget: Forget<C.Element, C.Element, C.Element>) -> Forget<C.Element, C, C> in
    Forget<C.Element, C, C> { (xs: C) -> C.Element in
      forget.unwrap(xs[idx])
    }
  }
}

public func ix<C: MutableCollection>(_ idx: C.Index) -> Setter<C, C, C.Element, C.Element> {
  return { f in
    { xs in
      var copy = xs
      copy[idx] = f(copy[idx])
      return copy
    }
  }
}
