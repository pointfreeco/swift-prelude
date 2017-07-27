import Prelude
import ValidationSemigroup

struct User { let name: String; let bio: String; let email: String }
let createUser = { name in { bio in { email in User(name: name, bio: bio, email: email) } } }

func validate(name: String) -> Validation<[String], String> {
  return !name.isEmpty
    ? pure(name)
    : .invalid(["Name must be at least 1 character."])
}

func validate(bio: String) -> Validation<[String], String> {
  return bio.count <= 10
    ? pure(bio)
    : .invalid(["Bio must 10 characters or less."])
}

func validate(email: String) -> Validation<[String], String> {
  return email.contains("@")
    ? pure(email)
    : .invalid(["Email must be valid."])
}

let validUser = pure(createUser)
  <*> validate(name: "Blob")
  <*> validate(bio: "I'm a blob")
  <*> validate(email: "blob@pointfree.co")
// => .valid(User(name: "Blob", bio: "I'm a blob", email: "blob@pointfree.co"))

let invalidUser = pure(createUser)
  <*> validate(name: "Blob")
  <*> validate(bio: "Blobbin around the world")
  <*> validate(email: "blob")
// => .invalid(["Bio must 10 characters or less.", "Email must be valid."])
