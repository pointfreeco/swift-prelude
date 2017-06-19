precedencegroup infixr0 {
  associativity: right
}
precedencegroup infixr1 {
  associativity: right
  higherThan: infixr0
}
precedencegroup infixr2 {
  associativity: right
  higherThan: infixr1
}
precedencegroup infixr3 {
  associativity: right
  higherThan: infixr2
}
precedencegroup infixr4 {
  associativity: right
  higherThan: infixr3
}
precedencegroup infixr5 {
  associativity: right
  higherThan: infixr4
  lowerThan: AdditionPrecedence
}
precedencegroup infixr6 {
  associativity: right
  higherThan: AdditionPrecedence
  lowerThan: MultiplicationPrecedence
}
precedencegroup infixr7 {
  associativity: right
  higherThan: MultiplicationPrecedence
}
precedencegroup infixr8 {
  associativity: right
  higherThan: infixr7
}
precedencegroup infixr9 {
  associativity: right
  higherThan: infixr8
}

precedencegroup infixl0 {
  associativity: left
}
precedencegroup infixl1 {
  associativity: left
  higherThan: infixl0
}
precedencegroup infixl2 {
  associativity: left
  higherThan: infixl1
}
precedencegroup infixl3 {
  associativity: left
  higherThan: infixl2
}
precedencegroup infixl4 {
  associativity: left
  higherThan: infixl3
}
precedencegroup infixl5 {
  associativity: left
  higherThan: infixl4
}
precedencegroup infixl6 {
  associativity: left
  higherThan: infixl5
}
precedencegroup infixl7 {
  associativity: left
  higherThan: infixl6
}
precedencegroup infixl8 {
  associativity: left
  higherThan: infixl7
}
precedencegroup infixl9 {
  associativity: left
  higherThan: infixl8
}
