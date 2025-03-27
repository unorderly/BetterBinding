import SwiftUI

@propertyWrapper @frozen @dynamicMemberLookup
public struct EquatableBinding<Value: Equatable>: Equatable {
    private let binding: Binding<Value>
    public var wrappedValue: Value {
        self.binding.wrappedValue
    }

    init(_ binding: Binding<Value>) {
        self.binding = binding
    }

    public static func == (left: EquatableBinding<Value>, right: EquatableBinding<Value>) -> Bool {
        left.wrappedValue == right.wrappedValue
    }

    public var projectedValue: Binding<Value> {
        self.binding
    }


    public static func constant(_ value: Value) -> EquatableBinding<Value> {
        Binding.constant(value).equatable()
    }

    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> EquatableBinding<Subject> where Subject: Equatable {
        self.binding[dynamicMember: keyPath].equatable()
    }

    public var transaction: Transaction { self.binding.transaction }

    public func transaction(_ transaction: Transaction) -> EquatableBinding<Value> {
        self.binding.transaction(transaction).equatable()
    }

    public func animation(_ animation: Animation? = .default) -> EquatableBinding<Value> {
        self.binding.animation(animation).equatable()
    }
}

extension EquatableBinding : @unchecked Sendable where Value : Sendable { }

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension EquatableBinding : Identifiable where Value : Identifiable {
    public typealias ID = Value.ID
    public var id: Value.ID { self.binding.id }
}

extension Binding where Value: Equatable {
    public func equatable() -> EquatableBinding<Value> {
        .init(self)
    }
}
