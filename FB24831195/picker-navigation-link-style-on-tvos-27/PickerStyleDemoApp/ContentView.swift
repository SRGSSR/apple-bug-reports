import SwiftUI

struct ContentView: View {
    @State private var flavor: Flavor = .hazelnut

    var body: some View {
        NavigationStack {
            List {
                Picker("Flavor", selection: $flavor) {
                    ForEach(Flavor.allCases) { flavor in
                        Text(flavor.name)
                            .tag(flavor)
                    }
                }
                .pickerStyle(.navigationLink) // This picker style doesn't seem to work on tvOS 27.
            }
        }
    }
}

#Preview {
    ContentView()
}
