import SwiftUI

struct ContentView: View {
    @State private var isPresented = false

    var body: some View {
        Button("Sheet") {
            isPresented.toggle()
        }
        .sheet(isPresented: $isPresented) {
            Image(systemName: "apple.logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .phaseAnimator([true, false]) { content, phase in
                    content
                        .opacity(phase ? 1 : 0)
                }
        }
    }
}

#Preview {
    ContentView()
}
