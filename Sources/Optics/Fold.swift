
public typealias Fold<R, S, T, A, B> = (Forget<R, A, B>) -> Forget<R, S, T>
