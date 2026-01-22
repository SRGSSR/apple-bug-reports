import AVKit
import SwiftUI
import os

struct AppleVideoPlayerView: View {
    @State private var player = Player(url: streamUrl, subsystem: "VideoPlayer")

    var body: some View {
        VideoPlayer(player: player)
            .ignoresSafeArea()
            .onDisappear {
                signPoster.emitEvent(posterName, "\(Self.self) disappears")
            }
    }
}
