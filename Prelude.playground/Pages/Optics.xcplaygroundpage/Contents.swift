import Optics
import Prelude

struct User {
  private(set) var id: Int
  private(set) var name: String

  public init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}

let user = User(id: 1, name: "Stephen")

dump(
  user
    |> (\.id +~ 1)
    <> (\.name %~ uppercased)
)
