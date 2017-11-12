import Prelude
import XCTest
import Either

class NestedTests: XCTestCase {
  func testNested() {
    let either: Either3<Int, String, Bool> = inj2("hello world")

    XCTAssertEqual(nil, get1(either))
    XCTAssertEqual("hello world", get2(either))
    XCTAssertEqual(nil, get3(either))
    XCTAssertTrue(inj2("hello world") == either)
  }

  func testEquality() {
    let lhs: Either4<Int, String, Bool, Prelude.Unit> = inj1(2)

    XCTAssertTrue(lhs == lhs)
    XCTAssertFalse(lhs == inj2(""))
    XCTAssertFalse(lhs == inj3(true))
    XCTAssertFalse(lhs == inj4(unit))
  }

  func testDestructure() {
    XCTAssertEqual(
      9,
      destructure(
        inj1(3),
        { $0 * $0 },
        { (value: String) in value.count }
      )
    )

    XCTAssertEqual(
      5,
      destructure(
        inj2("hello"),
        { $0 * $0 },
        { (value: String) in value.count }
      )
    )

    XCTAssertEqual(
      9,
      _destructure(
        Either1.left(3),
        { (x: Int) -> Int in x * x }
      )
    )
  }

  // Either2<B, C>   (injects into)  Either3<A, B, C>

  func testCombinations() {
    let intOrString: Either2<Int, String> = inj2("h")

    let tmp = wtf1(intOrString, { string in
      string.count == 0 ? inj1(-1) :
        string.count == 1 ? inj2("only one character?") :
        inj3(true)
    })

    XCTAssertTrue(inj3(true) == tmp)
    print(tmp)
  }

  func testMoreCombinations() {

    let err1OrErr2OrInt: Either3<Error1, Error2, Int> = inj3(1)

    let tmp = wtf2(
      err1OrErr2OrInt,
      { int -> Either4<Error1, Error2, Error3, Int>  in
        if int < 0  { return inj1(Error1()) }
        if int == 0 { return inj2(Error2()) }
        if int == 1 { return inj3(Error3()) }
        return inj4(int * int)
    })

    XCTAssertTrue(inj4(1764) == tmp)
  }
}

public func wtf1<E, F, A, B, Z>(
  _ e: E3<E, A, Z>,
  _ f: @escaping (A) -> E4<E, F, B, Z>
  )
  -> E4<E, F, B, Z> {

    return _destructure(e, inj1, f)
}

public func wtf2<E, F, G, A, B, Z>(
  _ e: E4<E, F, A, Z>,
  _ f: @escaping (A) -> E5<E, F, G, B, Z>
  )
  -> E5<E, F, G, B, Z> {

    return _destructure(e, inj1, inj2,f)
}






struct Error1: Equatable {
  static func ==(lhs: Error1, rhs: Error1) -> Bool {
    return true
  }
}
struct Error2: Equatable {
  static func ==(lhs: Error2, rhs: Error2) -> Bool {
    return true
  }
}
struct Error3: Equatable {
  static func ==(lhs: Error3, rhs: Error3) -> Bool {
    return true
  }
}
