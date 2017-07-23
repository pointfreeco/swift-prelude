import Frp
import PlaygroundSupport
import Prelude
import UIKit
import ValidationSemigroup

let (email, pushEmail) = Event<String>.create()
let (name, pushName) = Event<String>.create()
let (password, pushPassword) = Event<String>.create()

struct SignupData {
  let email: String
  let name: String
  let password: String
}

func create(_ email: String) -> (String) -> (String) -> SignupData {
  return { name in { password in .init(email: email, name: name, password: password) } }
}

let validatedEmail: Event<Validation<[String], String>> = email.map {
  $0.contains("@")
    ? .valid($0)
    : .invalid(["invalid email"])
}

let validatedName: Event<Validation<[String], String>> = name.map {
  !$0.isEmpty
    ? .valid($0)
    : .invalid(["invalid name"])
}

let validatedPassword: Event<Validation<[String], String>> = password.map {
  !$0.isEmpty
    ? .valid($0)
    : .invalid(["invalid password"])
}

let signups = pure(create)
  <*> validatedEmail
  <*> validatedName
  <*> validatedPassword

signups.subscribe {
  print("Attempted sign-up: \($0)")
}

pushEmail("brando@pointfree.co")
pushName("brando")
pushPassword("secret")

pushEmail("brandopointfree.co")

let (clicks, pushClick) = Event<()>.create()

let numClicks = clicks.reduce(0, { count, _ in count + 1 })
numClicks.subscribe {
  print("Click: \($0)")
}

pushClick(())
pushClick(())
pushClick(())
pushClick(())
pushClick(())

// UIKit

let view = UIView(frame: .init(x: 0, y: 0, width: 640, height: 480))
view.backgroundColor = .white
let square = UIView(frame: .init(x: 0, y: 0, width: 50, height: 50))
square.backgroundColor = .red
view.addSubview(square)

let touching = Event.merge(
  view.events.touchesBegan.map(const(true)),
  view.events.touchesEnded.map(const(false))
)

view.events.touches
  .mapOptional { $0.first }
  .map { $0.preciseLocation(in: view) }
  .subscribe { square.center = $0 }

PlaygroundPage.current.liveView = view
