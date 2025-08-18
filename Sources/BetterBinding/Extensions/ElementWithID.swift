import SwiftUI

extension Binding where Value: RangeReplaceableCollection, Value.Element: Identifiable {
    /// Creates a binding to a specific element in the collection identified by its ID.
    /// 
    /// The returned binding allows you to get, set, or remove an element from the collection.
    /// When the binding is set to a non-nil value, the element is either updated (if it exists)
    /// or appended (if it doesn't exist). When set to nil, the element is removed from the collection.
    ///
    /// - Parameter id: The identifier of the element to bind to.
    /// - Returns: An optional binding to the element with the specified ID. Returns `nil` if no
    ///   element with the given ID exists in the collection.
    public func element(with id: Value.Element.ID) -> Binding<Value.Element?> {
        self[elementWithID: id]
    }
}

extension RangeReplaceableCollection where Element: Identifiable {
    fileprivate subscript(elementWithID id: Element.ID) -> Element? {
        get {
            self.first(where: { $0.id == id })
        }
        set {
            if let newValue = newValue {
                if let index = self.firstIndex(where: { $0.id == id }) {
                    // Use replaceSubrange instead of direct subscript assignment
                    self.replaceSubrange(index...index, with: [newValue])
                } else {
                    self.append(newValue)
                }
            } else {
                self.removeAll(where: { $0.id == id })
            }
        }
    }
}
