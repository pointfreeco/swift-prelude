import XCTest

import EitherTests
import FrpTests
import OpticsTests
import PreludeTests
import TupleTests
import ValidationNearSemiringTests
import ValidationSemigroupTests

var tests = [XCTestCaseEntry]()
tests += EitherTests.__allTests()
tests += FrpTests.__allTests()
tests += OpticsTests.__allTests()
tests += PreludeTests.__allTests()
tests += TupleTests.__allTests()
tests += ValidationNearSemiringTests.__allTests()
tests += ValidationSemigroupTests.__allTests()

XCTMain(tests)
