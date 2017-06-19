infix operator >>>: infixr9
infix operator <<<: infixr9

infix operator <>: infixr5
prefix operator <>
postfix operator <>

infix operator <|: infixr0
infix operator |>: infixl1

infix operator <¢>: infixr4
infix operator ¢>: infixr4
infix operator <¢: infixr4
infix operator <£>: infixl1

infix operator >¢<: infixl4
infix operator >£<: infixl4

infix operator <|>: infixl3

infix operator <*>: infixl4
infix operator *>: infixl4
infix operator <*: infixl4

infix operator >>-: infixl1
infix operator -<<: infixr1
infix operator >->: infixr1
infix operator <-<: infixr1

// Non-standard

precedencegroup HashRocket {
  associativity: left
  higherThan: infixr5
}

infix operator =>: HashRocket
