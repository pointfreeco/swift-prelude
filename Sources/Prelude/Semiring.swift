public protocol Semiring: NearSemiring {}

extension Int: Semiring {}

extension Unit: Semiring {}

extension Bool: Semiring {
}
