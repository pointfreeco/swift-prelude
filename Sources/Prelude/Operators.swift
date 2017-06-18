precedencegroup HashRocket {
  associativity: left
  higherThan: Semigroup
}
infix operator =>: HashRocket

precedencegroup Alt {
  associativity: left
}

precedencegroup Apply {
  higherThan: Alt
  associativity: left
}

precedencegroup Functor {
  higherThan: Apply
  associativity: left
}

precedencegroup FunctionApplication {
  associativity: left
  higherThan: Semigroup
}

precedencegroup FunctionApplicationFlipped {
  associativity: left
  higherThan: FunctionApplication
}

precedencegroup Semigroup {
  associativity: right
  higherThan: AdditionPrecedence
  lowerThan: MultiplicationPrecedence
}

precedencegroup FunctionComposition {
  associativity: right
}

precedencegroup MonadicBind {
  associativity: right
}


infix operator <<<: FunctionComposition
infix operator >>>: FunctionComposition
infix operator <|: FunctionApplication
infix operator |>: FunctionApplicationFlipped
infix operator <|>: Alt
infix operator <*>: Apply
infix operator <*: Apply
infix operator *>: Apply

infix operator <¢>: Functor
infix operator <¢: Functor

infix operator <>: Semigroup
prefix operator <>
postfix operator <>

infix operator >>-: MonadicBind
