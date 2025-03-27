import SwiftUI

/**
 Example of how to use.
 ```
 struct ChangePrinter: Hashable {
     let prefix: String
     var willSet: (String, String) -> Void {
         return { old, new in
            print(prefix, ">>> old: \(old), new: \(new)")
         }
     }

     static var closure: HashableClosure<Self, String> {
        .init(subject: .init(prefix: ""), call: \.willSet)
     }
 }
 ```
 */
public struct HashableClosure<Subject: Hashable, Value: Equatable>: Hashable {
    let subject: Subject
    let call: KeyPath<Subject, (Value, Value) -> Void>

    public init(subject: Subject, call: KeyPath<Subject, (Value, Value) -> Void>) {
        self.subject = subject
        self.call = call
    }

    public func callAsFunction(old: Value, new: Value) {
        self.subject[keyPath: call](old, new)
    }
}


extension Binding where Value: Equatable {
    /// Since closures can't be hashable, we need to do a huge workaround here. This is intentionally dificult to ensure it is not misused.
    /// This only works, if the closure passed in has no dependencies (as in doesn't use outside variables), except for any part of the `Subject` (which affect its `hash`).
    /// Otherwise, the Binding might not correctly update.
    public func onWillSet<Subject: Hashable>(_ closure: HashableClosure<Subject, Value>) -> Binding<Value> {
        self[onChange: closure]
    }
}

private extension Equatable {
    subscript<Subject: Hashable>(onChange closure: HashableClosure<Subject, Self>) -> Self {
        get { self }
        set {
            if newValue != self {
                closure(old: self, new: newValue)
            }
            self = newValue
        }
    }
}
