import Prelude

struct State<S, A> {
  let runState: (S) -> (A, S)

  init(_ runState: @escaping (S) -> (A, S)) {
    self.runState = runState
  }

  func map<B>(_ f: @escaping (A) -> B) -> State<S, B> {
    return .init { s in
      let (a, s_) = self.runState(s)
      return (f(a), s_)
    }
  }

  func apply<B>(_ f: State<S, (A) -> B>) -> State<S, B> {
    return .init { s in
      let tmp1 = self.runState(s)
      let tmp2 = f.runState(s)
      fatalError()
    }
  }

  func flatMap<B>(_ f: @escaping (A) -> State<S, B>) -> State<S, B> {
    
  }
}

struct Reader<R, A> {
  let runReader: (R) -> A
}

struct Writer<W, A> {
  let runWriter: (A, W)
}
