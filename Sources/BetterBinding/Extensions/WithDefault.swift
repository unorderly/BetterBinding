import SwiftUI

extension Binding where Value: _OptionalProtocol, Value.Wrapped: Hashable {
    /// Unwraps a optional Binding, returning the `default`, if the receiver is `nil`. If the value of the receiver changes, it is always applied to the receiver.
    public func withDefault(_ defaultValue: Value.Wrapped) -> Binding<Value.Wrapped> {
        self[withDefault: defaultValue]
    }
}

private extension _OptionalProtocol {
    subscript(withDefault defaultValue: Self.Wrapped) -> Self.Wrapped {
        get {
            self.withFallback(defaultValue)
        }
        set {
            self = .init(newValue)
        }
    }
}

