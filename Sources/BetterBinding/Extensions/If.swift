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
    
    /// Creates a conditional binding that returns the value only when a property matches a specific value.
    ///
    /// When the property at the key path equals the specified value, the binding returns the current value.
    /// When the property doesn't match (or the value is `nil`), the binding returns `nil`.
    ///
    /// - Parameters:
    ///   - keyPath: The key path to a property on the wrapped value to compare.
    ///   - value: The value to match against the property.
    /// - Returns: A binding that conditionally exposes the value based on the property match.
    public func `if`<KeyPathValue: Hashable>(_ keyPath: KeyPath<Value.Wrapped, KeyPathValue>, matches value: KeyPathValue) -> Self {
        self[ifKeyPath: keyPath, matches: value]
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

    fileprivate subscript<Value: Hashable>(ifKeyPath keyPath: KeyPath<Self.Wrapped, Value>, matches value: Value) -> Self {
        get {
            if let unwrapped = self.wrapped, unwrapped[keyPath: keyPath] == value {
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
