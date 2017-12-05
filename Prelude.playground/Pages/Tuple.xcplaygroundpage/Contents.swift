import Tuple
import Optics
import Prelude

let tuple = 1 .*. "hello" .*. true

tuple
  |> \.first .~ 2
  |> \.second.first .~ "Hello!"
  |> \.second.second.first .~ false

print("✅")
