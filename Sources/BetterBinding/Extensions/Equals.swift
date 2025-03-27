import SwiftUI

extension Binding where Value: Hashable {
    public func equals(to value: Value, default defaultValue: Value) -> Binding<Bool> {
        self[equals: value, defaultValue]
    }
}

private extension Equatable {
    subscript(equals value: Self, defaultValue: Self) -> Bool {
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
