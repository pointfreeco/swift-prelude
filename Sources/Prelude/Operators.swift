infix operator <|: infixr0
infix operator |>: infixl1

// Semigroupoid
infix operator >>>: infixr9
infix operator <<<: infixr9

// Functor
infix operator <¢>: infixl4
infix operator ¢>: infixl4
infix operator <¢: infixl4
infix operator <£>: infixl1

// Contravariant
infix operator >¢<: infixl4
infix operator >£<: infixl4

// Alt
infix operator <|>: infixl3

// Apply
infix operator <*>: infixl4
infix operator *>: infixl4
infix operator <*: infixl4
// Apply (right-associative)
infix operator <%>: infixr4
infix operator %>: infixr4
infix operator <%: infixr4

// Bind
infix operator >>-: infixl1
infix operator -<<: infixr1
// Kleisli
infix operator >=>: infixr1
infix operator <-<: infixr1

// Extend
infix operator <<-: infixr1
infix operator ->>: infixl1
// Co-Kleisli
infix operator ->-: infixr1
infix operator -<-: infixr1

// Semigroup
infix operator <>: infixr5
prefix operator <>
postfix operator <>

// Non-standard

precedencegroup HashRocket {
  associativity: left
  higherThan: infixr5
}

infix operator =>: HashRocket
