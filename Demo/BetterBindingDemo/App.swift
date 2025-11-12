import BetterBinding
import SwiftUI

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State var getSetFlag: String?
    @State var betterFlag: String?
    @State var count: Int = 0

    var body: some View {
        let _ = print("ContentView body drawn")
        let _ = Self._printChanges()
        ScrollView {
            VStack(spacing: 20) {
                Text("BetterBinding Demo")
                    .font(.title)
                Text("BetterBinding only redraws when its value changes, whereas the Binding(get:set:) is recomputed and causes a redraw every time the containing view is redrawn.\n\nRandomize the count or toggle values to see how a change to a @State property of the containing view affects the bindings.\n\nEach toggle has a color which changes and is randomized on redraw.")
                
                Spacer()
                
                VStack(spacing: 20) {
                    NestedToggle(title: "Binding(get:set:)", isOn: Binding(get: { getSetFlag != nil }, set: { newValue in
                        if newValue, getSetFlag == nil {
                            getSetFlag = "Hello, World!"
                        } else if !newValue, getSetFlag != nil {
                            getSetFlag = nil
                        }
                    }))
                    
                    NestedToggle(title: "BetterBinding", isOn: $betterFlag.hasValue(default: "Hello, World!"))
                    
                    Button("Randomize count") {
                        count = Int.random(in: 0...100)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()
                
                Spacer()
                
                LabeledContent("getSetFlag:", value: getSetFlag ?? "nil")
                LabeledContent("betterFlag:", value: betterFlag ?? "nil")
                LabeledContent("count:", value: "\(count)")
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
    }

    var body: some View {
        let _ = print("NestedToggle(\(title)) body drawn")
        let _ = Self._printChanges()
        HStack {
            Circle().fill(Color.random).frame(height: 15)
            Toggle(self.title, isOn: self.$binding)
                .fontDesign(.monospaced)
        }
    }
}

extension Color {
    static var random: Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}

#Preview {
    ContentView()
}
