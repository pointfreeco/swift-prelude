@_exported import Tagged

extension Tagged: Semigroup where RawValue: Semigroup {
  public static func <> (lhs: Tagged, rhs: Tagged) -> Tagged {
    return .init(rawValue: lhs.rawValue <> rhs.rawValue)
  }
}

extension Tagged: Monoid where RawValue: Monoid {
  public static var empty: Tagged {
    return .init(rawValue: RawValue.empty)
  }
}

extension Tagged: Alt where RawValue: Alt {
  public static func <|> (lhs: Tagged, rhs: @autoclosure @escaping () -> Tagged) -> Tagged {
    return .init(rawValue: lhs.rawValue <|> rhs().rawValue)
  }
}
