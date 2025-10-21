import SwiftUI

extension Binding where Value: SetAlgebra, Value.Element: Hashable {
    /// Creates a binding that checks if the set contains a specific element.
    ///
    /// When the returned binding is set to `true`, the element is inserted into the set.
    /// When set to `false`, the element is removed from the set.
    ///
    /// - Parameter element: The element to check for membership in the set.
    /// - Returns: A binding that reflects whether the element is contained in the set.
    public func contains(_ element: Value.Element) -> Binding<Bool> {
        self[contains: element]
    }
}

extension Binding where Value: SetAlgebra, Value: Hashable {
    /// Creates a binding that checks if the set is empty.
    ///
    /// When the returned binding is set to `true`, the set is cleared.
    /// When set to `false` and the set is empty, it is set to the default value.
    ///
    /// - Parameter defaultValue: The value to use when the binding is set to `false` and the current set is empty.
    /// - Returns: A binding that reflects whether the set is empty.
    public func isEmpty(default defaultValue: Value) -> Binding<Bool> {
        self[isEmpty: defaultValue]
    }
}

extension Binding where Value: RangeReplaceableCollection, Value: Hashable {
    /// Creates a binding that checks if the collection is empty.
    ///
    /// When the returned binding is set to `true`, the collection is cleared.
    /// When set to `false` and the collection is empty, it is set to the default value.
    ///
    /// - Parameter defaultValue: The value to use when the binding is set to `false` and the current collection is empty.
    /// - Returns: A binding that reflects whether the collection is empty.
    public func isEmpty(default defaultValue: Value) -> Binding<Bool> {
        self[isEmpty: defaultValue]
    }
}

extension SetAlgebra {
    fileprivate subscript(contains element: Self.Element) -> Bool {
        get {
            self.contains(element)
        }
        set {
            if newValue {
                self.insert(element)
            } else {
                self.remove(element)
            }
        }
    }
}

extension RangeReplaceableCollection {
    fileprivate subscript(isEmpty defaultValue: Self) -> Bool {
        get {
            self.isEmpty
        }
        set {
            if newValue {
                if !self.isEmpty {
                    self.removeAll(keepingCapacity: false)
                }
            } else {
                if self.isEmpty {
                    self = defaultValue
                }
            }
        }
    }
}

extension SetAlgebra {
    fileprivate subscript(isEmpty defaultValue: Self) -> Bool {
        get {
            self.isEmpty
        }
        set {
            if newValue {
                if !self.isEmpty {
                    self = .init([])
                }
            } else {
                if self.isEmpty {
                    self = defaultValue
                }
            }
        }
    }
}
