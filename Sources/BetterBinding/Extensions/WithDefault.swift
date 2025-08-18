import SwiftUI

extension Binding where Value: _OptionalProtocol, Value.Wrapped: Hashable {
    /// Unwraps an optional binding, providing a default value when the binding is `nil`.
    /// 
    /// This creates a non-optional binding from an optional binding. When the underlying optional
    /// is `nil`, the binding returns the default value. Any changes to the returned binding
    /// are always applied to the underlying optional binding.
    ///
    /// - Parameter defaultValue: The value to use when the underlying binding is `nil`.
    /// - Returns: A non-optional binding that uses the default value when the original is `nil`.
    public func withDefault(_ defaultValue: Value.Wrapped) -> Binding<Value.Wrapped> {
        self[withDefault: defaultValue]
    }
}

extension _OptionalProtocol {
    fileprivate subscript(withDefault defaultValue: Self.Wrapped) -> Self.Wrapped {
        get {
            self.withFallback(defaultValue)
        }
        set {
            self = .init(newValue)
        }
    }
}
