precedencegroup SemigroupoidCompose { // infixr 9
  associativity: right
  higherThan: SemigroupAppend
}

precedencegroup SemigroupAppend { // infixr 5
  associativity: right
  higherThan: AdditionPrecedence
  lowerThan: MultiplicationPrecedence
}

precedencegroup FunctionApplyLow { // infixr 0
  associativity: right
}

precedencegroup FunctionApplyHigh { // infixl 9
  associativity: left
  higherThan: SemigroupoidCompose
}

precedencegroup FunctionApplyFlipped { // infixl 1
  associativity: left
  higherThan: FunctionApplyLow
}

precedencegroup FunctorMap { // infixl 4
  associativity: left
  higherThan: ApplicativeApply
}

precedencegroup FunctorMapFlipped { // infixl 1
  associativity: left
  higherThan: FunctionApplyFlipped
}

precedencegroup Alt { // infixl 3
  associativity: left
}

precedencegroup ApplicativeApply { // infixl 4
  associativity: left
  higherThan: Alt
}

precedencegroup MonadFlatMap { // infixl 1
  associativity: left
  higherThan: FunctorMapFlipped
}

precedencegroup MonadFlatMapFlipped { // infixr 1
  associativity: right
  higherThan: FunctionApplyLow
}

precedencegroup KleisliCompose { // infixr 1
  associativity: right
  higherThan: MonadFlatMapFlipped
}

infix operator >>>: SemigroupoidCompose
infix operator <<<: SemigroupoidCompose

infix operator <>: SemigroupAppend
prefix operator <>
postfix operator <>

infix operator ¢: FunctionApplyLow
infix operator <|: FunctionApplyHigh
infix operator |>: FunctionApplyFlipped

infix operator <¢>: FunctorMap
infix operator ¢>: FunctorMap
infix operator <¢: FunctorMap
infix operator <£>: FunctorMapFlipped

infix operator <|>: Alt

infix operator <*>: ApplicativeApply
infix operator *>: ApplicativeApply
infix operator <*: ApplicativeApply

infix operator >>-: MonadFlatMap
infix operator -<<: MonadFlatMapFlipped
infix operator >->: KleisliCompose
infix operator <-<: KleisliCompose

// Non-standard

precedencegroup HashRocket {
  associativity: left
  higherThan: SemigroupAppend
}

infix operator =>: HashRocket
