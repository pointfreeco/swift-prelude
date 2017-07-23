#if os(iOS)
  import Prelude
  import UIKit
  import UIKit.UIGestureRecognizerSubclass

  public struct Events<A> {
    private let ref: A
    fileprivate init(_ ref: A) {
      self.ref = ref
    }
  }

  public protocol Evented {}

  extension NSObject: Evented {}

  public extension Evented {
    public var events: Events<Self> {
      return Events(self)
    }
  }

  private var gestureRecognizerKey = 0

  private final class GestureRecognizer: UIGestureRecognizer {
    fileprivate let touchesBeganEvent = Event<Set<UITouch>>()
    fileprivate let touchesMovedEvent = Event<Set<UITouch>>()
    fileprivate let touchesEndedEvent = Event<Set<UITouch>>()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
      self.touchesBeganEvent.push(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
      self.touchesMovedEvent.push(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
      self.touchesEndedEvent.push(touches)
    }
  }

  public extension Events where A: UIView {
    private var gestureRecognizer: GestureRecognizer {
      return objc_getAssociatedObject(self.ref, &gestureRecognizerKey) as? GestureRecognizer
        ?? {
          let gestureRecognizer = GestureRecognizer()
          objc_setAssociatedObject(self.ref, &gestureRecognizerKey, gestureRecognizer, .OBJC_ASSOCIATION_RETAIN)
          self.ref.addGestureRecognizer(gestureRecognizer)
          return gestureRecognizer
        }()
    }

    var touches: Event<Set<UITouch>> {
      return self.touchesBegan <|> self.touchesMoved <|> self.touchesEnded
    }

    var touchesBegan: Event<Set<UITouch>> {
      return self.gestureRecognizer.touchesBeganEvent
    }

    var touchesMoved: Event<Set<UITouch>> {
      return self.gestureRecognizer.touchesMovedEvent
    }

    var touchesEnded: Event<Set<UITouch>> {
      return self.gestureRecognizer.touchesEndedEvent
    }
  }

  extension UIView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.events.touchesBegan.push(touches)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.events.touchesMoved.push(touches)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.events.touchesEnded.push(touches)
    }
  }
#endif
