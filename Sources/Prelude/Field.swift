public protocol Field: EuclideanRing {}

extension Double: Field {}
extension Float: Field {}

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
  import CoreGraphics

  extension CGFloat: Field {}
#endif
