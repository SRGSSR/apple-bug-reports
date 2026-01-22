import AVFoundation
import SwiftUI
import os

struct CustomVideoPlayerView: View {
    @State private var player = Player(url: streamUrl, subsystem: "CustomVideoPlayer")

    var body: some View {
        CustomVideoPlayer(player: player)
            .ignoresSafeArea()
            .onDisappear {
                signPoster.emitEvent(posterName, "\(Self.self) disappears")
            }
    }
}
