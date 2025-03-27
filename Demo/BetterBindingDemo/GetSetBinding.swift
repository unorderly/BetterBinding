import SwiftUI

extension Binding {
    public func getSet_asOptional(_ defaultValue: Value) -> Binding<Value?> {
        Binding<Value?>(get: { self.wrappedValue },
                        set: { newValue in self.wrappedValue = newValue ?? defaultValue })
    }


    public func getSet_hasValue<T>(default: T?) -> Binding<Bool> where Value == T? {
        Binding<Bool>(get: { self.wrappedValue != nil }, set: { newValue in
            if newValue {
                self.wrappedValue = self.wrappedValue ?? `default`
            } else {
                self.wrappedValue = nil
            }
        })
    }

    public func getSet_withDefault<T>(_ defaultValue: T) -> Binding<T> where Value == T? {
        Binding<T>(get: { self.wrappedValue ?? defaultValue },
                   set: { newValue in self.wrappedValue = newValue })
    }
}

extension Binding where Value: RangeReplaceableCollection, Value.Element: Identifiable {
    public func getSet_element(with id: Value.Element.ID) -> Binding<Value.Element?> {
        Binding<Value.Element?>(get: {
            self.wrappedValue.first(where: { $0.id == id })
        },
                                set: { newValue in
            if let newValue = newValue {
                if let index = self.wrappedValue.firstIndex(where: { $0.id == id }) {
                    // Use replaceSubrange instead of direct subscript assignment
                    self.wrappedValue.replaceSubrange(index...index, with: [newValue])
                } else {
                    self.wrappedValue.append(newValue)
                }
            } else {
                self.wrappedValue.removeAll(where: { $0.id == id })
            }
        })
    }
}
