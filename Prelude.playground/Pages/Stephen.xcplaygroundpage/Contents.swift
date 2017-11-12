import Either
import Foundation
import Prelude

func zurry<A, B>(_ f: @escaping (A) -> () -> B) -> (A) -> B {
  return { f($0)() }
}

let uppercased = zurry(String.uppercased)

let defaultFileManager = IO { FileManager.default }

let contentsEqual = defaultFileManager.map { curry($0.contentsEqual) }

let mockContentsEqual: IO<(String) -> (String) -> Bool> =
  pure <<< const <<< const <| true

perform <| contentsEqual
  <*> pure("file_a")
  <*> pure("file_b")

perform <| mockContentsEqual
  <*> pure("file_a")
  <*> pure("file_b")

extension Either where L == Error {
  public static func wrap(_ fn: @escaping () throws -> R) -> Either {
    do {
      return .right(try fn())
    } catch let error {
      return .left(error)
    }
  }

  public static func wrap<A>(_ fn: @escaping (A) throws -> R) -> (A) -> Either {
    return { a in
      do {
        return .right(try fn(a))
      } catch let error {
        return .left(error)
      }
    }
  }

  public static func wrap<A, B>(_ fn: @escaping (A, B) throws -> R) -> (A, B) -> Either {
    return { a, b in
      do {
        return .right(try fn(a, b))
      } catch let error {
        return .left(error)
      }
    }
  }
}

//public func warp<A, B, C, D>(_ f: @escaping (A) -> (B, C) throws -> D) -> (B, C) -> (A) -> Either<Error, D> {
//
//  return { b, c in
//    { a in
//      Either.wrap {
//        try f(a)(b, c)
//      }
//    }
//  }
//}

// GOAL

// Take method
let copyItem = FileManager.copyItem(atPath:toPath:)

public func flip2<A, B, C, D>(_ f: @escaping (A) -> (B, C) throws -> D) -> (B, C) -> (A) throws -> D {
  return { b, c in
    { a in
      try f(a)(b, c)
    }
  }
}

let flipped = flip2(copyItem)

defaultFileManager

let tmp1 = FileManager.copyItem(atPath:toPath:) >>> Either.wrap
let tmp2 = tmp1 <¢> defaultFileManager
let tmp3 = curry(<*>)(tmp2) <<< pure

let tmpincr = IO { { $0 + 1 } }
let tmpincr2 = { tmpincr <*> pure($0) }
let tmpincr3 = { (<*>)(tmpincr, pure($0)) }
let tmpincr4 = { curry(<*>)(tmpincr)(pure($0)) }
let tmpincr5 = curry(<*>)(tmpincr) <<< pure

//let tmpincr5 = { flip(curry(<*>))(pure($0))(tmpincr) }

//let tmp3 = { }

//let tmp3: (String, String) -> IO<Either<Error, ()>>
//  = flip(curry(<*>)) <<< pure <<< tmp2

// IO<FileManager> >>> ((FileManager) -> ((String, String) throws -> ()))
// IO<FileManager> >>>



