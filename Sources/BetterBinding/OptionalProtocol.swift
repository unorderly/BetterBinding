public protocol _OptionalProtocol: ExpressibleByNilLiteral {
    /**
     This is useful as you cannot compare `_OptionalType` to `nil`.
     */
    var _isNil: Bool { get }

    associatedtype Wrapped

    func withFallback(_ defaultValue: Wrapped) -> Wrapped

    init(_ wrapped: Wrapped)
}

extension Optional: _OptionalProtocol {
    public var _isNil: Bool { self == nil }
    public func withFallback(_ defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }

    public init (_ wrapped: Wrapped) {
        self = wrapped
    }
}
