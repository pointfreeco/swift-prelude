import XCTest
import Prelude

class FunctionTests: XCTestCase {
  struct IntToString: Function {
    static let live = IntToString(String.init)
    
    typealias Signature = (Int) -> String
    
    init(_ call: @escaping Signature) {
      self.call = call
    }
    
    let call: Signature
    
    func callAsFunction(integerValue: Int) -> String {
      call(integerValue)
    }
  }
  
  public func testCallAsFunction() {
    let increment = Func<Int, Int> { $0 + 1 }
    let zero = Func<Void, Int> { 0 }
    
    XCTAssertEqual(increment(0), 1)
    XCTAssertEqual(zero(), 0)
  }
  
  public func testCustomCallAsFunction() {
    let convert = IntToString.live
    
    XCTAssertEqual(convert(0), "0")
    XCTAssertEqual(convert(integerValue: 1), "1")
  }
  
  public func testTypeErasure() {
    let convert = IntToString.live
    let erasedConvert = convert.eraseToFunc()
    
    func typeIsFuncOfIntToString<F: Function>(_ f: F) -> Bool {
      return f is Func<Int, String>
    }
    
    XCTAssertTrue(typeIsFuncOfIntToString(erasedConvert))
    XCTAssertEqual(convert(0), erasedConvert(0))
  }
}
