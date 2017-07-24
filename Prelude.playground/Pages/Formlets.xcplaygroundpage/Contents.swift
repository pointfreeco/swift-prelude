import Prelude
import State
import Writer
import Reader

struct Node {}

typealias I_n<A> = State<Int, A>
typealias I_a<A> = Writer<[Node], A>
typealias I_e<A> = Reader<[String:String], A>

typealias TmpFormlet<A> = I_a<I_e<A>>
typealias Formlet<A> = I_n<TmpFormlet<A>>

func pure<A>(_ a: A) -> Formlet<A> {
  return pure >>> pure >>> pure <| a
}

func createTuple<A, B>(_ a: A) -> (B) -> (A, B) {
  return { b in (a, b) }
}

func createTuple<A, B, C>(_ a: A) -> (B) -> (C) -> (A, B, C) {
  return { b in { c in (a, b, c) } }
}

func <*> <A, B> (f: Formlet<(A) -> B>, a: Formlet<A>) -> Formlet<B> {
  return pure(curry(<*>)) <*> f <*> a
}

func <*> <A, B> (f: TmpFormlet<(A) -> B>, a: TmpFormlet<A>) -> TmpFormlet<B> {
  return pure(curry(<*>)) <*> f <*> a
}

let form: Formlet<String>

func plug<A>(
  _ context: @escaping (Node) -> Node,
  formlet: Formlet<A>)
  ->
  Formlet<A> {

    return Formlet.init { gen in

      let tmp1 = formlet.eval(gen)
      tmp1.runWriter

      Writer.init(<#T##a: _##_#>, Reader<[String:String], A>.init(<#T##runReader: ([String : String]) -> A##([String : String]) -> A#>))
    }
  //(run: <#T##(Int) -> (result: Writer<[Node], Reader<[String : String], _>>, finalState: Int)#>)
}

//sig plug : (XmlContext, Formlet(α)) → Formlet(α) fun plug(k, f) {
//  fun (gen) {
//    var (x, c, gen) = f(gen); (k(x), c, gen)
//  } }
//

1

