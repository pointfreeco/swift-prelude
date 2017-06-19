import XCTest
import Prelude

class EitherTests: XCTestCase {
  func testEither() {
    XCTAssertEqual("5", Either<String, Int>.right(5).either(id, String.init))
    XCTAssertEqual("Error", Either<String, Int>.left("Error").either(id, String.init))
  }

  func testLeft() {
    XCTAssertEqual(.some("Error"), Either<String, Int>.left("Error").left)
    XCTAssertNil(Either<String, Int>.right(5).left)
  }

  func testRight() {
    XCTAssertNil(Either<String, Int>.left("Error").right)
    XCTAssertEqual(.some(5), Either<String, Int>.right(5).right)
  }

  func testIsLeft() {
    XCTAssertTrue(Either<String, Int>.left("Error").isLeft)
    XCTAssertFalse(Either<String, Int>.right(5).isLeft)
  }

  func testIsRight() {
    XCTAssertFalse(Either<String, Int>.left("Error").isRight)
    XCTAssertTrue(Either<String, Int>.right(5).isRight)
  }

  func testMap() {
    XCTAssertEqual(2, (Either<Int, Int>.right(1) |> map { $0 + 1 }).right)
    XCTAssertEqual(1, (Either<Int, Int>.left(1) |> map { $0 + 1 }).left)
    XCTAssertEqual(2, Either<Int, Int>.right(1).map { $0 + 1 }.right)
    XCTAssertEqual(1, Either<Int, Int>.left(1).map { $0 + 1 }.left)
    XCTAssertEqual(2, ({ $0 + 1 } <¢> Either<Int, Int>.right(1)).right)
    XCTAssertEqual(1, ({ $0 + 1 } <¢> Either<Int, Int>.left(1)).left)
  }

  func testApply() {
    XCTAssertEqual(2, (Either<String, (Int) -> Int>.right { $0 + 1 } <*> .right(1)).right)
  }

  func testAlt() {
    XCTAssertEqual(2, (Either<String, Int>.left("Error") <|> Either<String, Int>.right(2)).right)
    XCTAssertEqual("1", (Either<String, Int>.left("1") <|> Either<String, Int>.left("2")).left)
    XCTAssertEqual(1, (Either<String, Int>.right(1) <|> Either<String, Int>.right(2)).right)
    XCTAssertEqual(1, (Either<String, Int>.right(1) <|> Either<String, Int>.left("Error")).right)
  }

  func testPure() {
    XCTAssertEqual(5, (pure(5) as Either<String, Int>).right)
  }

  func testFlatMap() {
    XCTAssertEqual(2, ({ .right($0 + 1) } >>- Either<Int, Int>.right(1)).right)
    XCTAssertEqual(2, ({ Either<Int, Int>.left($0 + 1) } >>- Either<Int, Int>.right(1)).left)

    XCTAssertEqual(1, ({ .right($0 + 1) } >>- Either<Int, Int>.left(1)).left)
    XCTAssertEqual(1, ({ Either<Int, Int>.left($0 + 1) } >>- Either<Int, Int>.left(1)).left)
  }

  func testAppend() {
    XCTAssertEqual([1, 2],
                   (Either<String, [Int]>.right([1]) <> Either<String, [Int]>.right([2])).right ?? [])
    XCTAssertNil((Either<String, [Int]>.right([1]) <> Either<String, [Int]>.left("Error")).right)
    XCTAssertNil((Either<String, [Int]>.left("Error") <> Either<String, [Int]>.right([2])).right)
  }
}
