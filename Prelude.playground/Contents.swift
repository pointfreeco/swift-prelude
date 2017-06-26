import Prelude

let incr = { $0 + 1 }
let square: (Int) -> Int = { $0 * $0 }

[incr, square] <*> [1, 2, 3]


let xss = FreeSemiring([[1], [2]])
let yss = FreeSemiring([[3]])
let zss = FreeSemiring([[4]])

dump(xss * yss * zss)

1

