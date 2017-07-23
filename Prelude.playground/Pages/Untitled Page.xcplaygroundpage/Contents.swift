

//import Either
//import Prelude
//import ValidationSemigroup
//
//struct CountedSet<A: Hashable> {
//  let data: [A: Int]
//
//  init(_ data: [A: Int]) {
//    self.data = data
//  }
//
//  init(_ a: A) {
//    self.data = [a: 1]
//  }
//
//  init(_ xs: Set<A>) {
//    self.data = [A: Int](uniqueKeysWithValues: xs.map { ($0, 1) })
//  }
//
//  init(_ xs: [A]) {
//    self.data = [A: Int](uniqueKeysWithValues: xs.map { ($0, 1) })
//  }
//
//  func intersection(_ other: CountedSet<A>) -> CountedSet<A> {
//    var result: [A: Int] = [:]
//    print(self.data)
//    self.data.forEach { key, value in
//      result[key] = other.data[key].map { min($0, value) } ?? 0
//    }
//    return .init(result)
//  }
//}
//
//func intersection<A>(_ lhs: CountedSet<A>, _ rhs: CountedSet<A>) -> CountedSet<A> {
//  return lhs.intersection(rhs)
//}
//
//let xss = [[2, 3], [2]]  //2*3 + 2
//let factored = FreeNearSemiring.init([[2, 3], [2]]) // 2 * (3+2)
//
//let tmp1 = xss
//  .map(CountedSet.init)
//  .reduce(CountedSet([]), intersection)
//
//print(tmp1)
//
//
//func factorize<A: Hashable>(xss: [[A]]) -> [[A]] {
////
////  let tmp1 = xss.map { CountedSet($0) }.reduce(CountedSet([])) { accum, s in accum.intersection(s) }
//
//
//  fatalError()
//}
//
//typealias Phone = String
//typealias Email = String
//
//struct Tagged<T, A> {
//  let value: A
//}
//
//struct TaggedUser {
//  enum Name {}
//  enum Bio {}
//  enum Contact {}
//
//  let name: Tagged<Name, String>
//  let bio: Tagged<Bio, String>
//  let contact: Tagged<Contact, Either<Email, Phone>>
//}
//
//func validate(_ name: Tagged<TaggedUser.Name, String>) -> Validation<[Tagged<TaggedUser.Name, String>], Tagged<TaggedUser.Name, String>> {
//
//  return name.value.isEmpty
//    ? .invalid([.init(value: "email")])
//    : .valid(name)
//}
//
//func validate(_ bio: Tagged<TaggedUser.Bio, String>) -> Validation<[Tagged<TaggedUser.Bio, String>], Tagged<TaggedUser.Bio, String>> {
//
//  return bio.value.count > 10
//    ? .invalid([.init(value: "bio")])
//    : .valid(bio)
//}
//
//func validate(_ phone: Tagged<TaggedUser.Contact, String>) -> Validation<[Tagged<TaggedUser.Contact, String>], Tagged<TaggedUser.Contact, Either<Email, Phone>>> {
//
//  return phone.value.count != 7
//    ? .invalid([.init(value: "phone")])
//    : .valid(.init(value: .right(phone.value)))
//}
//
//curry(TaggedUser.init)
//  <¢> validate(Tagged<TaggedUser.Name, String>(value: "yoooo"))
//  <*> validate(Tagged<TaggedUser.Bio, String>(value: "yoooo"))
////  <*> validate(Tagged<TaggedUser.Contact, String>(value: "yoooo"))
//
//1
//
//
//
//

