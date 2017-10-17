public typealias E2<A, Z> = Either<A, Z>
public typealias E3<A, B, Z> = Either<A, E2<B, Z>>
public typealias E4<A, B, C, Z> = Either<A, E3<B, C, Z>>
public typealias E5<A, B, C, D, Z> = Either<A, E4<B, C, D, Z>>
public typealias E6<A, B, C, D, E, Z> = Either<A, E5<B, C, D, E, Z>>
public typealias E7<A, B, C, D, E, F, Z> = Either<A, E6<B, C, D, E, F, Z>>

public typealias Either1<A> = E2<A, Never>
public typealias Either2<A, B> = E3<A, B, Never>
public typealias Either3<A, B, C> = E4<A, B, C, Never>
public typealias Either4<A, B, C, D> = E5<A, B, C, D, Never>
public typealias Either5<A, B, C, D, E> = E6<A, B, C, D, E, Never>
public typealias Either6<A, B, C, D, E, F> = E7<A, B, C, D, E, F, Never>

public func inj1<A, Z>(_ v: A) -> E2<A, Z> {
  return .left(v)
}

public func inj2<A, B, Z>(_ v: B) -> E3<A, B, Z> {
  return .right(.left(v))
}

public func inj3<A, B, C, Z>(_ v: C) -> E4<A, B, C, Z> {
  return .right(.right(.left(v)))
}

public func inj4<A, B, C, D, Z>(_ v: D) -> E5<A, B, C, D, Z> {
  return .right(.right(.right(.left(v))))
}

public func inj5<A, B, C, D, E, Z>(_ v: E) -> E6<A, B, C, D, E, Z> {
  return .right(.right(.right(.right(.left(v)))))
}

public func inj6<A, B, C, D, E, F, Z>(_ v: F) -> E7<A, B, C, D, E, F, Z> {
  return .right(.right(.right(.right(.right(.left(v))))))
}

public func proj1<A, Z>(_ e: E2<A, Z>) -> A? {
  if case let .left(v) = e { return v }
  return nil
}

public func proj2<A, B, Z>(_ e: E3<A, B, Z>) -> B? {
  if case let .right(.left(v)) = e { return v }
  return nil
}

public func proj3<A, B, C, Z>(_ e: E4<A, B, C, Z>) -> C? {
  if case let .right(.right(.left(v))) = e { return v }
  return nil
}

public func proj4<A, B, C, D, Z>(_ e: E5<A, B, C, D, Z>) -> D? {
  if case let .right(.right(.right(.left(v)))) = e { return v }
  return nil
}

public func proj5<A, B, C, D, E, Z>(_ e: E6<A, B, C, D, E, Z>) -> E? {
  if case let .right(.right(.right(.right(.left(v))))) = e { return v }
  return nil
}

public func proj6<A, B, C, D, E, F, Z>(_ e: E7<A, B, C, D, E, F, Z>) -> F? {
  if case let .right(.right(.right(.right(.right(.left(v)))))) = e { return v }
  return nil
}

public func at1<A, R, Z>(_ v: R, _ f: @escaping (A) -> R) -> (E2<A, Z>) -> R {
  return { proj1($0).map(f) ?? v }
}

public func at2<A, B, R, Z>(_ v: R, _ f: @escaping (B) -> R) -> (E3<A, B, Z>) -> R {
  return { proj2($0).map(f) ?? v }
}

public func at3<A, B, C, R, Z>(_ v: R, _ f: @escaping (C) -> R) -> (E4<A, B, C, Z>) -> R {
  return { proj3($0).map(f) ?? v }
}

public func at4<A, B, C, D, R, Z>(_ v: R, _ f: @escaping (D) -> R) -> (E5<A, B, C, D, Z>) -> R {
  return { proj4($0).map(f) ?? v }
}

public func at5<A, B, C, D, E, R, Z>(_ v: R, _ f: @escaping (E) -> R) -> (E6<A, B, C, D, E, Z>) -> R {
  return { proj5($0).map(f) ?? v }
}

public func at6<A, B, C, D, E, F, R, Z>(_ v: R, _ f: @escaping (F) -> R) -> (E7<A, B, C, D, E, F, Z>) -> R {
  return { proj6($0).map(f) ?? v }
}
