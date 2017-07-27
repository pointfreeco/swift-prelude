import CoreGraphics

public protocol Field: EuclideanRing {}

extension CGFloat: Field {}
extension Double: Field {}
extension Float: Field {}
