import SwiftUI
import WebKit

struct ContentView: View {
    @State private var page = WebPage()
    @State private var columnWidth: CGFloat = 120.5

    var body: some View {
        HStack(spacing: 0) {
            VStack {
                Text("Column width")
                // The WebView gets the remaining width. Only a fractional width like 120.5 triggers the bug,
                // e.g. half of an odd screen width. Whole widths like 120 work as expected.
                Picker("Column width", selection: $columnWidth) {
                    Text("120").tag(CGFloat(120))
                    Text("120.5").tag(CGFloat(120.5))
                }
                .pickerStyle(.segmented)
            }
            .padding(8)
            .frame(width: columnWidth)
            .frame(maxHeight: .infinity)
            .background(.orange)
            WebView(page)
        }
        .safeAreaInset(edge: .trailing, spacing: 0) {
            Color.purple
                .frame(width: 84)
                .ignoresSafeArea()
        }
        .onAppear {
            page.load(html: html)
        }
    }
}

private let html = """
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { margin: 0; background: #0a84ff; color: white; font: 17px -apple-system; }
        div { min-height: 100vh; padding: 16px; box-sizing: border-box; border-right: 6px solid red; }
    </style>
    <div>The red line marks the trailing edge of the web content. It should touch the purple safe area bar.</div>
    """

#Preview {
    ContentView()
}
