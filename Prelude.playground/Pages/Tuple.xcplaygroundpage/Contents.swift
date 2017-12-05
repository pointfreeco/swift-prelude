import Optics
import Prelude
import Tuple

let tuple = 1 .*. "hello" .*. true

tuple
  |> \.first .~ 2
  |> \.second.first .~ "Hello!"
  |> \.second.second.first .~ false

print("✅")
