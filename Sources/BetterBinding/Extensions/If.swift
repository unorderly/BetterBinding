import SwiftUI

extension Binding where Value: _OptionalProtocol {
    /// Creates a conditional binding that returns the value only when the condition is true.
    ///
    /// When the condition is `true`, the binding returns the current value.
    /// When the condition is `false`, the binding returns `nil`.
    ///
    /// - Parameter condition: The condition that determines whether to return the value or `nil`.
    /// - Returns: A binding that conditionally exposes the value.
    public func `if`(_ condition: Bool) -> Self {
        self[ifTrue: condition]
    }
}

extension Binding where Value == Bool {
    /// Creates a conditional binding that performs a logical AND operation with the condition.
    ///
    /// The returned binding's value is the result of `self && condition`.
    /// When setting the binding value, it directly updates the underlying boolean value.
    ///
    /// - Parameter condition: The condition to AND with the binding's value.
    /// - Returns: A binding that represents the logical AND of the original value and the condition.
    public func `if`(_ condition: Bool) -> Self {
        self[ifTrue: condition]
    }
}

extension Bool {
    fileprivate subscript(ifTrue condition: Bool) -> Bool {
        get {
            self && condition
        }
        set {
            self = newValue
        }
    }
}

extension _OptionalProtocol {
    fileprivate subscript(ifTrue condition: Bool) -> Self {
        get {
            if condition {
                self
            } else {
                nil
            }
        }
        set {
            self = newValue
        }
    }
}
