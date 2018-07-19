// Generated using Sourcery 0.11.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import XCTest

@testable import PreludeTests; @testable import EitherTests; @testable import FrpTests; @testable import NonEmptyTests; @testable import OpticsTests; @testable import ReaderTests; @testable import StateTests; @testable import TupleTests; @testable import ValidationNearSemiringTests; @testable import ValidationSemigroupTests; @testable import WriterTests;
extension ArrayTests {
  static var allTests: [(String, (ArrayTests) -> () throws -> Void)] = [
  ]
}
extension ChoiceTests {
  static var allTests: [(String, (ChoiceTests) -> () throws -> Void)] = [
  ]
}
extension EitherTests {
  static var allTests: [(String, (EitherTests) -> () throws -> Void)] = [
    ("testEither", testEither),
    ("testLeft", testLeft),
    ("testRight", testRight),
    ("testIsLeft", testIsLeft),
    ("testIsRight", testIsRight),
    ("testWrap", testWrap),
    ("testUnwrap", testUnwrap),
    ("testMap", testMap),
    ("testApply", testApply),
    ("testAlt", testAlt),
    ("testPure", testPure),
    ("testAppend", testAppend)
  ]
}
extension EventTests {
  static var allTests: [(String, (EventTests) -> () throws -> Void)] = [
    ("testCombine", testCombine),
    ("testMerge", testMerge),
    ("testFilter", testFilter),
    ("testReduce", testReduce),
    ("testCount", testCount),
    ("testWithLast", testWithLast),
    ("testSampleOn", testSampleOn),
    ("testMapOptional", testMapOptional),
    ("testCatOptionals", testCatOptionals),
    ("testMap", testMap),
    ("testApply", testApply),
    ("testAppend", testAppend),
    ("testConcat", testConcat)
  ]
}
extension FreeNearSemiringTests {
  static var allTests: [(String, (FreeNearSemiringTests) -> () throws -> Void)] = [
    ("testOp", testOp)
  ]
}
extension FunctionTests {
  static var allTests: [(String, (FunctionTests) -> () throws -> Void)] = [
  ]
}
extension KeyPathTests {
  static var allTests: [(String, (KeyPathTests) -> () throws -> Void)] = [
    ("testGet", testGet),
    ("testOver", testOver),
    ("testSet", testSet)
  ]
}
extension MonoidTests {
  static var allTests: [(String, (MonoidTests) -> () throws -> Void)] = [
  ]
}
extension NestedTests {
  static var allTests: [(String, (NestedTests) -> () throws -> Void)] = [
    ("testNested", testNested)
  ]
}
extension NonEmptyTests {
  static var allTests: [(String, (NonEmptyTests) -> () throws -> Void)] = [
    ("testMap", testMap),
    ("testApply", testApply),
    ("testPure", testPure),
    ("testFlatMap", testFlatMap)
  ]
}
extension OpticsTests {
  static var allTests: [(String, (OpticsTests) -> () throws -> Void)] = [
    ("testViewOn", testViewOn),
    ("testIx", testIx),
    ("testKey", testKey),
    ("testElem", testElem),
    ("testOver", testOver),
    ("testSet", testSet),
    ("testAddOver", testAddOver),
    ("testSubOver", testSubOver),
    ("testMulOver", testMulOver),
    ("testDivOver", testDivOver),
    ("testDisjOver", testDisjOver),
    ("testConjOver", testConjOver),
    ("testAppendOver", testAppendOver),
    ("testTraversed", testTraversed),
    ("testStrongPrisms", testStrongPrisms),
    ("testChoicePrisms", testChoicePrisms),
    ("testLots", testLots),
    ("testGetters", testGetters)
  ]
}
extension OptionalTests {
  static var allTests: [(String, (OptionalTests) -> () throws -> Void)] = [
  ]
}
extension ParallelTests {
  static var allTests: [(String, (ParallelTests) -> () throws -> Void)] = [
    ("testParallel", testParallel),
    ("testRace", testRace),
    ("testSequenceThreadSafety", testSequenceThreadSafety),
    ("testApplyThreadSafety", testApplyThreadSafety),
    ("testAltThreadSafety", testAltThreadSafety)
  ]
}
extension PreludeTupleTests {
  static var allTests: [(String, (PreludeTupleTests) -> () throws -> Void)] = [
  ]
}
extension ReaderTests {
  static var allTests: [(String, (ReaderTests) -> () throws -> Void)] = [
  ]
}
extension SemigroupTests {
  static var allTests: [(String, (SemigroupTests) -> () throws -> Void)] = [
  ]
}
extension SequenceTests {
  static var allTests: [(String, (SequenceTests) -> () throws -> Void)] = [
    ("testCatOptionals", testCatOptionals),
    ("testMapOptional", testMapOptional),
    ("testConcat", testConcat),
    ("testIntersperse", testIntersperse)
  ]
}
extension StateTests {
  static var allTests: [(String, (StateTests) -> () throws -> Void)] = [
  ]
}
extension StringTests {
  static var allTests: [(String, (StringTests) -> () throws -> Void)] = [
    ("testJoined", testJoined)
  ]
}
extension StrongTests {
  static var allTests: [(String, (StrongTests) -> () throws -> Void)] = [
  ]
}
extension TupleTests {
  static var allTests: [(String, (TupleTests) -> () throws -> Void)] = [
    ("testTuples", testTuples)
  ]
}
extension UnitTests {
  static var allTests: [(String, (UnitTests) -> () throws -> Void)] = [
  ]
}
extension ValidationNearSemiringTests {
  static var allTests: [(String, (ValidationNearSemiringTests) -> () throws -> Void)] = [
    ("testValidData", testValidData),
    ("testInvalidData", testInvalidData)
  ]
}
extension ValidationSemigroupTests {
  static var allTests: [(String, (ValidationSemigroupTests) -> () throws -> Void)] = [
    ("testValidData", testValidData),
    ("testInvalidData", testInvalidData)
  ]
}
extension WriterTests {
  static var allTests: [(String, (WriterTests) -> () throws -> Void)] = [
  ]
}

// swiftlint:disable trailing_comma
XCTMain([
  testCase(ArrayTests.allTests),
  testCase(ChoiceTests.allTests),
  testCase(EitherTests.allTests),
  testCase(EventTests.allTests),
  testCase(FreeNearSemiringTests.allTests),
  testCase(FunctionTests.allTests),
  testCase(KeyPathTests.allTests),
  testCase(MonoidTests.allTests),
  testCase(NestedTests.allTests),
  testCase(NonEmptyTests.allTests),
  testCase(OpticsTests.allTests),
  testCase(OptionalTests.allTests),
  testCase(ParallelTests.allTests),
  testCase(PreludeTupleTests.allTests),
  testCase(ReaderTests.allTests),
  testCase(SemigroupTests.allTests),
  testCase(SequenceTests.allTests),
  testCase(StateTests.allTests),
  testCase(StringTests.allTests),
  testCase(StrongTests.allTests),
  testCase(TupleTests.allTests),
  testCase(UnitTests.allTests),
  testCase(ValidationNearSemiringTests.allTests),
  testCase(ValidationSemigroupTests.allTests),
  testCase(WriterTests.allTests),
])
// swiftlint:enable trailing_comma
