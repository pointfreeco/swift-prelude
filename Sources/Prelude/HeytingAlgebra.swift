public protocol HeytingAlgebra {
  static var ff: Self { get }
  static var tt: Self { get }
  static func implies(_ a: Self, _ b: Self) -> Self
  static func &&(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self
  static func ||(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self
  static prefix func !(not: Self) -> Self
}

extension Bool: HeytingAlgebra {
  public static let ff = false
  public static let tt = true

  public static func implies(_ a: Bool, _ b: Bool) -> Bool {
    return !a || b
  }
}

extension Unit: HeytingAlgebra {
  public static let ff = unit
  public static let tt = unit

  public static func implies(_ a: Unit, _ b: Unit) -> Unit {
    return unit
  }

  public static func &&(lhs: Unit, rhs: @autoclosure () throws -> Unit) rethrows -> Unit {
    return unit
  }

  public static func ||(lhs: Unit, rhs: @autoclosure () throws -> Unit) rethrows -> Unit {
    return unit
  }

  public static prefix func !(not: Unit) -> Unit {
    return unit
  }
}

public func not<R: HeytingAlgebra>(_ r: R) -> R {
  return !r
}

public func && <A, R: HeytingAlgebra>(f: @escaping (A) -> R, g: @escaping (A) -> R) -> (A) -> R {
  return { a in f(a) && g(a) }
}

public func || <A, R: HeytingAlgebra>(f: @escaping (A) -> R, g: @escaping (A) -> R) -> (A) -> R {
  return { a in f(a) || g(a) }
}
