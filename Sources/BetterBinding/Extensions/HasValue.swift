import SwiftUI

extension Binding where Value: _OptionalProtocol & Hashable {
    /// The returned Binding will be `true` if the receiver Binding is non-`nil` and `false` if the receiver Binding is `nil`.
    /// If the returned Binding gets set to `true` and the receiver value is `nil`, the receiver gets set to `default`. Otherwise the current value is kept.
    /// If the returned Binding gets set to `false` and the receiver value is non-`nil`, it gets set to `nil`.
    public func hasValue(default defaultValue: Value) -> Binding<Bool> {
        self[hasValueWithDefault: defaultValue]
    }
}

extension Binding where Value: _OptionalProtocol {
    /// Creates a binding that indicates whether the optional has a value.
    ///
    /// When the returned binding is set to `false`, the underlying optional is set to `nil`.
    /// When set to `true`, the underlying optional remains unchanged (it cannot create a value from nothing).
    ///
    /// - Returns: A binding that reflects whether the optional has a non-nil value.
    public func hasValue() -> Binding<Bool> {
        self.hasValue
    }
}

extension _OptionalProtocol {
    fileprivate subscript(hasValueWithDefault defaultValue: Self) -> Bool {
        get {
            !self._isNil
        }
        set {
            if newValue, self._isNil {
                self = defaultValue
            } else if !newValue, !self._isNil {
                self = nil
            }
        }
    }

    fileprivate var hasValue: Bool {
        get {
            !self._isNil
        }
        set {
            if !newValue, !self._isNil {
                self = nil
            }
        }
    }
}
