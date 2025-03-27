import SwiftUI

extension Binding where Value: Hashable {
    /// Converts a non-optional Binding into an optional binding.
    /// If the returned Binding get set to `nil`, the receiver Binding will be set to `default`.
    public func asOptional(`default` defaultValue: Value) -> Binding<Value?> {
        self[asOptionalWithDefault: defaultValue]
    }
}



private extension Hashable {
    subscript(asOptionalWithDefault defaultValue: Self) -> Self? {
        get {
            self
        }
        set {
            self = newValue ?? defaultValue
        }
    }
}




