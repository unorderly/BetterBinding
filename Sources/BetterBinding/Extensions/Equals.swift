import SwiftUI

extension Binding where Value: Hashable {
    /// Creates a binding that checks if the value equals a specific target value.
    /// 
    /// When the returned binding is set to `true`, the underlying value is set to the target value.
    /// When set to `false` and the current value equals the target value, it is set to the default value.
    ///
    /// - Parameters:
    ///   - value: The target value to compare against.
    ///   - defaultValue: The value to use when the binding is set to `false` and the current value equals the target.
    /// - Returns: A binding that reflects whether the underlying value equals the target value.
    public func equals(to value: Value, default defaultValue: Value) -> Binding<Bool> {
        self[equals: value, defaultValue]
    }
}

extension Equatable {
    fileprivate subscript(equals value: Self, defaultValue: Self) -> Bool {
        get {
            self == value
        }
        set {
            if newValue {
                if self != value {
                    self = value
                }
            } else {
                if self == value {
                    self = defaultValue
                }
            }
        }
    }
}
