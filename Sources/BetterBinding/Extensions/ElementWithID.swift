import SwiftUI

extension Binding where Value: RangeReplaceableCollection, Value.Element: Identifiable {
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
