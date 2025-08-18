import SwiftUI

/// A wrapper for closures that can be made hashable by associating them with a hashable subject.
///
/// This struct enables the use of closures in scenarios where hashability is required, such as in SwiftUI bindings
/// that need to track changes. The closure must be a pure function that depends only on the `Subject` instance
/// for its behavior to maintain proper hashability semantics.
///
/// ## Example Usage
/// ```swift
/// struct ChangePrinter: Hashable {
///     let prefix: String
///     var willSet: (String, String) -> Void {
///         return { old, new in
///            print(prefix, ">>> old: \(old), new: \(new)")
///         }
///     }
///
///     static var closure: HashableClosure<Self, String> {
///        .init(subject: .init(prefix: ""), call: \.willSet)
///     }
/// }
/// ```
///
/// - Important: The closure should not capture external variables beyond what's accessible through the `Subject`.
///   Otherwise, the binding may not update correctly.
public struct HashableClosure<Subject: Hashable, Value: Equatable>: Hashable {
    let subject: Subject
    let call: KeyPath<Subject, (Value, Value) -> Void>

    /// Creates a new hashable closure wrapper.
    ///
    /// - Parameters:
    ///   - subject: The hashable subject that contains the closure logic.
    ///   - call: A key path to the closure on the subject.
    public init(subject: Subject, call: KeyPath<Subject, (Value, Value) -> Void>) {
        self.subject = subject
        self.call = call
    }

    /// Invokes the wrapped closure with the old and new values.
    ///
    /// - Parameters:
    ///   - old: The previous value.
    ///   - new: The new value.
    public func callAsFunction(old: Value, new: Value) {
        self.subject[keyPath: self.call](old, new)
    }
}

extension Binding where Value: Equatable {
    /// Attaches a callback that is invoked whenever the binding's value is about to change.
    ///
    /// This method provides a way to observe changes to a binding's value before they are applied.
    /// The callback receives both the old and new values, allowing you to perform side effects
    /// or logging when the value changes.
    ///
    /// - Parameter closure: A hashable closure that will be called with the old and new values
    ///   when the binding is about to change. The closure must be pure and only depend on its
    ///   hashable subject to ensure proper binding updates.
    /// - Returns: A new binding that calls the closure before applying value changes.
    ///
    /// - Important: The closure must not capture external variables beyond what's accessible
    ///   through its hashable subject. This ensures the binding updates correctly when the
    ///   closure's dependencies change.
    public func onWillSet<Subject: Hashable>(_ closure: HashableClosure<Subject, Value>) -> Binding<Value> {
        self[onChange: closure]
    }
}

extension Equatable {
    fileprivate subscript<Subject: Hashable>(onChange closure: HashableClosure<Subject, Self>) -> Self {
        get { self }
        set {
            if newValue != self {
                closure(old: self, new: newValue)
            }
            self = newValue
        }
    }
}
