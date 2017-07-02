import Prelude

let add: (Int) -> (Int) -> Int = { x in { y in x + y } }
let incr = add(1)
let square: (Int) -> Int = { $0 * $0 }

[incr, square] <*> [1, 2, 3]
[add] <*> [1] <*> [2, 3]
