import SwiftUI

struct ContentView: View {
    @State private var appleVideoPlayerIsPresented = false
    @State private var customVideoPlayerIsPresented = false

    var body: some View {
        HStack {
            openPlayerButton(
                title: "Open Player [SwiftUI Native]",
                description: "Pressing this button will show use cases of the `VideoPlayer` component provided by the AVKit framework."
            ) {
                appleVideoPlayerIsPresented = true
            }

            openPlayerButton(
                title: "Open Player [UIViewControllerRepresentable]",
                description: "Pressing this button will present a custom player view built using `AVPlayerViewController`."
            ) {
                customVideoPlayerIsPresented = true
            }
        }
        .fullScreenCover(isPresented: $appleVideoPlayerIsPresented) {
            AppleVideoPlayerView()
        }
        .fullScreenCover(isPresented: $customVideoPlayerIsPresented) {
            CustomVideoPlayerView()
        }
    }

    private func openPlayerButton(title: String, description: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 30) {
                    Text(title)
                        .font(.subheadline)
                    Text(description)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                Image(systemName: "chevron.up")
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

