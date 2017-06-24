import Prelude

let incr = { $0 + 1 }
let square: (Int) -> Int = { $0 * $0 }

[incr, square] <*> [1, 2, 3]
