import Tuple
import Optics
import Prelude

let tuple = 1 .*. "hello" .*. true

tuple
  |> \.second.first %~ { "\($0)!" }

print("✅")
