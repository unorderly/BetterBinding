# BetterBinding
Extensions to SwiftUI `Binding`, that don't cause extra redraws.

When a view redraws, every `Binding(get:set:)` it creates is a new instance. SwiftUI treats new binding instances as changes, causing child views to redraw unnecessarily even if the underlying values haven't changed.

BetterBinding solves this by using hashable subscripts instead of closures, allowing SwiftUI to recognize when bindings are equivalent and avoid unnecessary redraws.

Run the demo app to see this in action.

## When to use
Use `BetterBinding` when:
  - Transforming optional to boolean
  - Selecting from enums/sets with boolean toggles
  - Accessing collection elements by ID
  - Adding logging/analytics to bindings
  - Using standard transformation patterns

Use `Binding(get:set:)` when:
  - Custom business logic is required
  - Non-standard type transformations
  - Complex multi-step computations in get/set
  - The pattern doesn't match any BetterBinding extension

## Examples

### `Binding<Bool>` that toggles an optional default value

Instead of:
```swift
@State var username: String?

Toggle("Has username", isOn: Binding(
    get: { username != nil },
    set: { newValue in
        if newValue {
            username = "Guest"
        } else {
            username = nil
        }
    }
))
```

You can use:
```swift
@State var username: String?

Toggle("Has username", isOn: $username.hasValue(default: "Guest"))
```

### `Binding<T>` for a non-optional control from an optional value

Instead of:
```swift
@State var count: Int?

TextField("Count", value: Binding(
    get: { count ?? 0 },
    set: { count = $0 }
), format: .number)
```

You can use:
```swift
@State var count: Int?

TextField("Count", value: $count.withDefault(0), format: .number)
```

### `Binding<Bool>` that toggles set membership

Instead of:
```swift
@State var selectedTags: Set<String> = []

Toggle("Swift", isOn: Binding(
    get: { selectedTags.contains("Swift") },
    set: { newValue in
        if newValue {
            selectedTags.insert("Swift")
        } else {
            selectedTags.remove("Swift")
        }
    }
))
```

You can use:
```swift
@State var selectedTags: Set<String>

Toggle("Swift", isOn: $selectedTags.contains("Swift"))
```

### `Binding<Bool>` that toggles between two values

Instead of:
```swift
@State var theme: Theme = .light

Toggle("Dark mode", isOn: Binding(
    get: { theme == .dark },
    set: { newValue in
        theme = newValue ? .dark : .light
    }
))
```

You can use:
```swift
@State var theme: Theme = .light

Toggle("Dark mode", isOn: $theme.equals(to: .dark, default: .light))
```

### `Binding<Element?>` to a specific element in a collection

Instead of:
```swift
@State var items: [Item]
let itemID: UUID // The ID of the item to edit

TextField("Name", text: Binding(
    get: { items.first(where: { $0.id == itemID })?.name ?? "" },
    set: { newValue in
        if let index = items.firstIndex(where: { $0.id == itemID }) {
            items[index].name = newValue
        }
    }
))
```

You can use:
```swift
@State var items: [Item]

TextField("Name", text: $items.element(with: itemID).name.withDefault(""))
```

## Reading the Demo Logs

Run the demo target (`Demo/BetterBindingDemo`) and watch the console. If you tap the first toggle, and then the second, you should see output similar to this.
```sh
ContentView body drawn
ContentView: _getSetFlag changed.
NestedToggle(Binding(get:set:)) body drawn
NestedToggle: @self, _binding changed.                  ← ✓ Expected redraw (BetterBinding does not redraw)

ContentView body drawn
ContentView: _betterFlag changed.
NestedToggle(Binding(get:set:)) body drawn
NestedToggle: @self, _binding changed.                  ← ⚠️ Unnecessary redraw!
NestedToggle(BetterBinding) body drawn
NestedToggle: @self, _binding changed.                  ← ✓ Expected redraw
```

The important detail is which toggles are redrawn and report that `_binding changed`. When `_getSetFlag` changes, only the `NestedToggle` containing the `Binding(get:set:)` is redrawn, the `BetterBinding` remains stable and isn't redrawn even though `ContentView` redraws. When `_betterFlag` is changed, both toggles are redrawn: the `BetterBinding` toggle redraws because its value changed (expected), but the `Binding(get:set:)` toggle also redraws unnecessarily because the binding is recreated even though `getSetFlag` didn't change.

This shows that `Binding(get:set:)` is recreated whenever anything triggers the containing view to redraw, whereas the `BetterBinding` binding keeps its identity and only redraws when its value actually changes.
