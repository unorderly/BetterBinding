//
//  BetterBindingDemoApp.swift
//  BetterBindingDemo
//
//  Created by Leo Mehlig on 27.03.25.
//

import SwiftUI
import BetterBinding

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ToggleElements: Identifiable, Hashable {
    let id: String
    var value: Bool
}
struct ContentView: View {
    @State var getSetFlag: String? = nil

    @State var flag: String? = nil

    @State var elements1: [ToggleElements] = [
        .init(id: "A", value: false),
        .init(id: "B", value: true),
        .init(id: "C", value: false),
    ]

    @State var elements2: [ToggleElements] = [
        .init(id: "A", value: false),
        .init(id: "B", value: true),
        .init(id: "C", value: false),
    ]

    var elementsBinding: Binding<[ToggleElements]> {
        flag != nil ? $elements1 : $elements2
    }

    @State var equatableBindingElements: [ToggleElements] = [
        .init(id: "A", value: false),
        .init(id: "B", value: true),
        .init(id: "C", value: false),
    ]

    struct ChangePrinter<Value: CustomDebugStringConvertible & Equatable>: Hashable {
        let prefix: String
        var willSet: (Value, Value) -> Void {
            return { old, new in
                print(prefix, ">>> old: \(old), new: \(new)")
            }
        }

        static var closure: HashableClosure<Self, Value> {
            .init(subject: .init(prefix: ""), call: \.willSet)
        }
    }


    var body: some View {
        let _ = print("ContentView body")
        let _ = Self._printChanges()
        ScrollView {
            VStack(spacing: 20) {
                Text("Using `Binding(get:set:)`")
                    .font(.headline)
                NestedToggle(title: "Get/Set Flag", isOn: Binding(get: { getSetFlag != nil }, set: { newValue in
                    if newValue, getSetFlag == nil {
                        getSetFlag = "Hello, World!"
                    } else if !newValue, getSetFlag != nil {
                        getSetFlag = nil
                    }
                }))
                if let getSetFlag {
                    Text(getSetFlag)
                }

                ForEach(elements1) { element in
                    Text("\(element.id) - \(element.value)")
                }
                ForEach(elements2) { element in
                    Text("\(element.id) - \(element.value)")
                }

                Text("Using `BetterBinding`")
                    .font(.headline)
                NestedToggle(title: "Flag", isOn: $flag
                    .onWillSet(ChangePrinter.closure)
                    .hasValue(default: "Hello, World!")
                    )
                if let flag {
                    Text(flag)
                }

                Text("With `@Binding`")
                ForEach(elementsBinding.wrappedValue) { element in
                    EquatableBindingNestedToggle(title: element.id, isOn: elementsBinding.element(with: element.id).withDefault(element).value)
                }

                Text("With `@EquatableBinding`")
                ForEach(equatableBindingElements) { element in
                    EquatableBindingNestedToggle(title: element.id, isOn: $equatableBindingElements.element(with: element.id).withDefault(element).value)
                }

            }
            .padding()
        }
    }
}

struct NestedToggle: View {
    var title: String
    @Binding var binding: Bool


    init(title: String, isOn binding: Binding<Bool>) {
        self._binding = binding
        self.title = title
//        print("Nested init (title = \(title))")
    }

    var body: some View {
        let _ = print("Nested body (title = \(title))")
        let _ = Self._printChanges()
        Toggle(title, isOn: $binding)
    }
}

struct EquatableBindingNestedToggle: View {
    var title: String
    @EquatableBinding var binding: Bool


    init(title: String, isOn binding: Binding<Bool>) {
        self._binding = binding.equatable()
        self.title = title
//        print("Nested init (title = \(title))")
    }

    var body: some View {
        let _ = print("Nested body (title = \(title))")
        let _ = Self._printChanges()
        Toggle(title, isOn: $binding)
    }
}


#Preview {
    ContentView()
}
