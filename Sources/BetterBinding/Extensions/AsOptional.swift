import SwiftUI

extension Binding where Value: Hashable {
    /// Converts a non-optional binding into an optional binding.
    ///
    /// This creates an optional binding from a non-optional binding. When the returned optional
    /// binding is set to `nil`, the underlying non-optional binding is set to the provided default value.
    ///
    /// - Parameter defaultValue: The value to use when the optional binding is set to `nil`.
    /// - Returns: An optional binding that wraps the original non-optional binding.
    public func asOptional(default defaultValue: Value) -> Binding<Value?> {
        self[asOptionalWithDefault: defaultValue]
    }
}

extension Hashable {
    fileprivate subscript(asOptionalWithDefault defaultValue: Self) -> Self? {
        get {
            self
        }
        set {
            self = newValue ?? defaultValue
        }
    }
}
